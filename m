Return-path: <linux-media-owner@vger.kernel.org>
Received: from 95-130-160-7.hsi.glasfaser-ostbayern.de ([95.130.160.7]:51687
	"EHLO mx02.net.xebec.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753465AbaHKPUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Aug 2014 11:20:42 -0400
Received: from localhost (localhost [127.0.0.1])
	by mx02.net.xebec.de (Postfix) with ESMTP id C8A56E0C4
	for <linux-media@vger.kernel.org>; Mon, 11 Aug 2014 17:13:36 +0200 (CEST)
Message-ID: <53E8DD95.8070100@netandweb.de>
Date: Mon, 11 Aug 2014 17:13:25 +0200
From: Ernst Bachmann <ernst.vger@netandweb.de>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: RC Support on TT-S2400 devices (ttusb2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm using a Technotrend S2400 USB DVB-S Receiver (driver is ttusb2).
That device includes a IR Remote Control.

I was wondering if there was a specific reason why the RC receiver is
not supported by the ttusb2 driver?

The protocol seems to be identical to the one used by the CT-3650 Device
(in the same driver).

I simply re-compiled the driver with the .rc.core initializer copied
from ttusb2_properties_ct3650
to ttusb2_properties_s2400, and the remote seems to be working fine.

-------------

*** ttusb2.c.orig       2014-08-10 20:42:03.000000000 +0200
--- ttusb2.c    2014-08-10 20:42:03.000000000 +0200
***************
*** 684,699 ****
--- 684,706 ----
  static struct dvb_usb_device_properties ttusb2_properties_s2400 = {
        .caps = DVB_USB_IS_AN_I2C_ADAPTER,
 
        .usb_ctrl = CYPRESS_FX2,
        .firmware = "dvb-usb-tt-s2400-01.fw",
 
        .size_of_priv = sizeof(struct ttusb2_state),
 
+       .rc.core = {
+               .rc_interval      = 150, /* Less than IR_KEYPRESS_TIMEOUT */
+               .rc_codes         = RC_MAP_TT_1500,
+               .rc_query         = tt3650_rc_query,
+               .allowed_protos   = RC_BIT_RC5,
+       },
+
        .num_adapters = 1,
        .adapter = {
                {
                .num_frontends = 1,
                .fe = {{
                        .streaming_ctrl   = NULL,
 
                        .frontend_attach  = ttusb2_frontend_tda10086_attach,

------------

I don't know if it runs stable over a longer period, some other post I
found mentioned there might be a timing problem with RC-Polling
interrupting other accesses?

However, it would be great to have working RC Support for that device
out-of-the box (without recompile) sometime in the future, so I'd really
appreciate if you could look into it.


Thanks in advance,
Ernst Bachmann
