Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27372 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbcF2Ut5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 16:49:57 -0400
Date: Wed, 29 Jun 2016 23:49:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org
Subject: re: [media] cec: add HDMI CEC framework (adapter)
Message-ID: <20160629204917.GA5949@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans Verkuil,

The patch 9881fe0ca187: "[media] cec: add HDMI CEC framework
(adapter)" from Jun 25, 2016, leads to the following static checker
warning:

	drivers/staging/media/cec/cec-adap.c:1445 cec_receive_notify()
	error: buffer overflow 'adap->phys_addrs' 15 <= 15

drivers/staging/media/cec/cec-adap.c
  1373  static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
  1374                                bool is_reply)
  1375  {
  1376          bool is_broadcast = cec_msg_is_broadcast(msg);
  1377          u8 dest_laddr = cec_msg_destination(msg);
  1378          u8 init_laddr = cec_msg_initiator(msg);
  1379          u8 devtype = cec_log_addr2dev(adap, dest_laddr);
  1380          int la_idx = cec_log_addr2idx(adap, dest_laddr);
  1381          bool is_directed = la_idx >= 0;
  1382          bool from_unregistered = init_laddr == 0xf;

It's complaining about this.

  1383          struct cec_msg tx_cec_msg = { };
  1384  
  1385          dprintk(1, "cec_receive_notify: %*ph\n", msg->len, msg->msg);
  1386  
  1387          if (adap->ops->received) {
  1388                  /* Allow drivers to process the message first */
  1389                  if (adap->ops->received(adap, msg) != -ENOMSG)
  1390                          return 0;
  1391          }
  1392  
  1393          /*
  1394           * REPORT_PHYSICAL_ADDR, CEC_MSG_USER_CONTROL_PRESSED and
  1395           * CEC_MSG_USER_CONTROL_RELEASED messages always have to be
  1396           * handled by the CEC core, even if the passthrough mode is on.
  1397           * The others are just ignored if passthrough mode is on.
  1398           */
  1399          switch (msg->msg[1]) {
  1400          case CEC_MSG_GET_CEC_VERSION:
  1401          case CEC_MSG_GIVE_DEVICE_VENDOR_ID:
  1402          case CEC_MSG_ABORT:
  1403          case CEC_MSG_GIVE_DEVICE_POWER_STATUS:
  1404          case CEC_MSG_GIVE_PHYSICAL_ADDR:
  1405          case CEC_MSG_GIVE_OSD_NAME:
  1406          case CEC_MSG_GIVE_FEATURES:
  1407                  /*
  1408                   * Skip processing these messages if the passthrough mode
  1409                   * is on.
  1410                   */
  1411                  if (adap->passthrough)
  1412                          goto skip_processing;
  1413                  /* Ignore if addressing is wrong */
  1414                  if (is_broadcast || from_unregistered)
  1415                          return 0;
  1416                  break;
  1417  
  1418          case CEC_MSG_USER_CONTROL_PRESSED:
  1419          case CEC_MSG_USER_CONTROL_RELEASED:
  1420                  /* Wrong addressing mode: don't process */
  1421                  if (is_broadcast || from_unregistered)
  1422                          goto skip_processing;
  1423                  break;
  1424  
  1425          case CEC_MSG_REPORT_PHYSICAL_ADDR:
  1426                  /*
  1427                   * This message is always processed, regardless of the
  1428                   * passthrough setting.
  1429                   *
  1430                   * Exception: don't process if wrong addressing mode.
  1431                   */
  1432                  if (!is_broadcast)

Should this be:
			if (!is_broadcast || from_unregistered) ?

Maybe that's not possible.

  1433                          goto skip_processing;
  1434                  break;
  1435  
  1436          default:
  1437                  break;
  1438          }
  1439  
  1440          cec_msg_set_reply_to(&tx_cec_msg, msg);
  1441  
  1442          switch (msg->msg[1]) {
  1443          /* The following messages are processed but still passed through */
  1444          case CEC_MSG_REPORT_PHYSICAL_ADDR:
  1445                  adap->phys_addrs[init_laddr] =
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Here is where the warning gets generated.  We would be writing over a
struct hole so it's not the end of the world I suppose.

  1446                          (msg->msg[2] << 8) | msg->msg[3];
  1447                  dprintk(1, "Reported physical address %04x for logical address %d\n",
  1448                          adap->phys_addrs[init_laddr], init_laddr);
  1449                  break;
  1450  
  1451          case CEC_MSG_USER_CONTROL_PRESSED:

regards,
dan carpenter
