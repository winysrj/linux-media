Return-path: <linux-media-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17146 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757992AbaJaNGQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 09:06:16 -0400
Date: Fri, 31 Oct 2014 16:06:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: mahfouz.saif.elyazal@gmail.com
Cc: linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141031130600.GA16310@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Aya Mahfouz,

The patch be4aa8157c98: "staging: media: lirc: lirc_zilog.c: replace
custom print macros with dev_* and pr_*" from Oct 26, 2014, leads to
the following static checker warning:

	drivers/staging/media/lirc/lirc_zilog.c:1340 close()
	error: we previously assumed 'ir' could be null (see line 1339)

drivers/staging/media/lirc/lirc_zilog.c
  1333  /* Close the IR device */
  1334  static int close(struct inode *node, struct file *filep)
  1335  {
  1336          /* find our IR struct */
  1337          struct IR *ir = filep->private_data;
  1338  
  1339          if (ir == NULL) {
                    ^^^^^^^^^^
  1340                  dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
                                ^^^^^^^^^

I suggest you just delete the error message.  Can "ir" actually be NULL
here anyway?

  1341                  return -ENODEV;
  1342          }
  1343  

	drivers/staging/media/lirc/lirc_zilog.c:1636 ir_probe()
	error: potential null dereference 'ir'.  (kzalloc returns null)

drivers/staging/media/lirc/lirc_zilog.c
  1614          dev_info(ir->l.dev, "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
  1615                     adap->name, adap->nr, ir->l.minor);
  1616  
  1617  out_ok:
  1618          if (rx != NULL)
  1619                  put_ir_rx(rx, true);
  1620          if (tx != NULL)
  1621                  put_ir_tx(tx, true);
  1622          put_ir_device(ir, true);
  1623          dev_info(ir->l.dev, "probe of IR %s on %s (i2c-%d) done\n",
  1624                     tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
  1625          mutex_unlock(&ir_devices_lock);
  1626          return 0;
  1627  
  1628  out_put_xx:
  1629          if (rx != NULL)
  1630                  put_ir_rx(rx, true);
                        ^^^^^^^^^^^^^^^^^^^
Btw, I think this is a double free?  On some paths we call put_ir_rx()
before the goto out_put_xx;.

  1631          if (tx != NULL)
  1632                  put_ir_tx(tx, true);
  1633  out_put_ir:
  1634          put_ir_device(ir, true);
  1635  out_no_ir:
  1636          dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
                        ^^^^^^^^^
Null dereference.

  1637                      __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
  1638                     ret);
  1639          mutex_unlock(&ir_devices_lock);
  1640          return ret;
  1641  }

regards,
dan carpenter
