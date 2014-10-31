Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:52180 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaJaO0v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Oct 2014 10:26:51 -0400
Received: by mail-wi0-f174.google.com with SMTP id d1so1460526wiv.13
        for <linux-media@vger.kernel.org>; Fri, 31 Oct 2014 07:26:50 -0700 (PDT)
Date: Fri, 31 Oct 2014 16:26:45 +0200
From: Aya Mahfouz <mahfouz.saif.elyazal@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: staging: media: lirc: lirc_zilog.c: replace custom print macros
 with dev_* and pr_*
Message-ID: <20141031142644.GA4166@localhost.localdomain>
References: <20141031130600.GA16310@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031130600.GA16310@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 31, 2014 at 04:06:00PM +0300, Dan Carpenter wrote:
> Hello Aya Mahfouz,
> 

Hello Dan, 

> The patch be4aa8157c98: "staging: media: lirc: lirc_zilog.c: replace
> custom print macros with dev_* and pr_*" from Oct 26, 2014, leads to
> the following static checker warning:
> 
> 	drivers/staging/media/lirc/lirc_zilog.c:1340 close()
> 	error: we previously assumed 'ir' could be null (see line 1339)
> 
> drivers/staging/media/lirc/lirc_zilog.c
>   1333  /* Close the IR device */
>   1334  static int close(struct inode *node, struct file *filep)
>   1335  {
>   1336          /* find our IR struct */
>   1337          struct IR *ir = filep->private_data;
>   1338  
>   1339          if (ir == NULL) {
>                     ^^^^^^^^^^
>   1340                  dev_err(ir->l.dev, "close: no private_data attached to the file!\n");
>                                 ^^^^^^^^^
> 
> I suggest you just delete the error message.  Can "ir" actually be NULL
> here anyway?
>

Since I'm a newbie and this is not my code, I prefer to use pr_err().
 
>   1341                  return -ENODEV;
>   1342          }
>   1343  
> 
> 	drivers/staging/media/lirc/lirc_zilog.c:1636 ir_probe()
> 	error: potential null dereference 'ir'.  (kzalloc returns null)
> 
> drivers/staging/media/lirc/lirc_zilog.c
>   1614          dev_info(ir->l.dev, "IR unit on %s (i2c-%d) registered as lirc%d and ready\n",
>   1615                     adap->name, adap->nr, ir->l.minor);
>   1616  
>   1617  out_ok:
>   1618          if (rx != NULL)
>   1619                  put_ir_rx(rx, true);
>   1620          if (tx != NULL)
>   1621                  put_ir_tx(tx, true);
>   1622          put_ir_device(ir, true);
>   1623          dev_info(ir->l.dev, "probe of IR %s on %s (i2c-%d) done\n",
>   1624                     tx_probe ? "Tx" : "Rx", adap->name, adap->nr);
>   1625          mutex_unlock(&ir_devices_lock);
>   1626          return 0;
>   1627  
>   1628  out_put_xx:
>   1629          if (rx != NULL)
>   1630                  put_ir_rx(rx, true);
>                         ^^^^^^^^^^^^^^^^^^^
> Btw, I think this is a double free?  On some paths we call put_ir_rx()
> before the goto out_put_xx;.
> 

I'll read about this and see how to fix it.

>   1631          if (tx != NULL)
>   1632                  put_ir_tx(tx, true);
>   1633  out_put_ir:
>   1634          put_ir_device(ir, true);
>   1635  out_no_ir:
>   1636          dev_err(ir->l.dev, "%s: probing IR %s on %s (i2c-%d) failed with %d\n",
>                         ^^^^^^^^^
> Null dereference.
> 
>   1637                      __func__, tx_probe ? "Tx" : "Rx", adap->name, adap->nr,
>   1638                     ret);
>   1639          mutex_unlock(&ir_devices_lock);
>   1640          return ret;
>   1641  }
> 

In general, I can send a new patch to fix the aforementioned warnings.
Kindly let me know if you prefer that I send a second version of this
patch.

> regards,
> dan carpenter

Kind Regards,
Aya Saif El-yazal Mahfouz
