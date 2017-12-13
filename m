Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:56943 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752903AbdLMN5m (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Dec 2017 08:57:42 -0500
Date: Wed, 13 Dec 2017 13:57:40 +0000
From: Sean Young <sean@mess.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [bug report] media: lirc: improve locking
Message-ID: <20171213135740.dtssns4jtyg2l7jb@gofer.mess.org>
References: <20171213100731.2oamrvxqdfkhml4d@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213100731.2oamrvxqdfkhml4d@mwanda>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 13, 2017 at 01:07:31PM +0300, Dan Carpenter wrote:
> Hello Sean Young,
> 
> The patch 131fd7fc3c01: "media: lirc: improve locking" from Nov 4,
> 2017, leads to the following static checker warning:
> 
> 	drivers/media/rc/lirc_dev.c:373 ir_lirc_transmit_ir()
> 	error: 'txbuf' dereferencing possible ERR_PTR()
> 
> drivers/media/rc/lirc_dev.c
>    330                  txbuf = memdup_user(buf, n);
>    331                  if (IS_ERR(txbuf)) {
>    332                          ret = PTR_ERR(txbuf);
>    333                          goto out;
>                                 ^^^^^^^^
> This used to be a direct return...
> 
>    334                  }
>    335          }
>    336  
>    337          for (i = 0; i < count; i++) {
>    338                  if (txbuf[i] > IR_MAX_DURATION / 1000 - duration || !txbuf[i]) {
>    339                          ret = -EINVAL;
>    340                          goto out;
>    341                  }
>    342  
>    343                  duration += txbuf[i];
>    344          }
>    345  
>    346          ret = dev->tx_ir(dev, txbuf, count);
>    347          if (ret < 0)
>    348                  goto out;
>    349  
>    350          if (fh->send_mode == LIRC_MODE_SCANCODE) {
>    351                  ret = n;
>    352          } else {
>    353                  for (duration = i = 0; i < ret; i++)
>    354                          duration += txbuf[i];
>    355  
>    356                  ret *= sizeof(unsigned int);
>    357  
>    358                  /*
>    359                   * The lircd gap calculation expects the write function to
>    360                   * wait for the actual IR signal to be transmitted before
>    361                   * returning.
>    362                   */
>    363                  towait = ktime_us_delta(ktime_add_us(start, duration),
>    364                                          ktime_get());
>    365                  if (towait > 0) {
>    366                          set_current_state(TASK_INTERRUPTIBLE);
>    367                          schedule_timeout(usecs_to_jiffies(towait));
>                                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> This looks like a long wait?  Are you sure you want to hold the lock
> this whole time?

Good point, there is no need for that.

>    368                  }
>    369          }
>    370  
>    371  out:
>    372          mutex_unlock(&dev->lock);
>    373          kfree(txbuf);
>                       ^^^^^
> Can't pass an error pointer to kfree().

Yep.

Thank you for the report. I'll write patch.

Thanks

Sean
