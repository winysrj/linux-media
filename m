Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110809.mail.gq1.yahoo.com ([67.195.13.232]:21592 "HELO
	web110809.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753688AbZCMAtL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2009 20:49:11 -0400
Message-ID: <705905.97455.qm@web110809.mail.gq1.yahoo.com>
Date: Thu, 12 Mar 2009 17:49:08 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS based cards
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hi Alexey,


I numbered your comments and append all answers to the end of this email.


--- On Fri, 3/13/09, Alexey Klimov <klimov.linux@gmail.com> wrote:

> From: Alexey Klimov <klimov.linux@gmail.com>
> Subject: Re: [PATCH 1/1] siano: add high level SDIO interface driver for SMS based cards
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>, "Michael Krufky" <mkrufky@linuxtv.org>, linux-media@vger.kernel.org
> Date: Friday, March 13, 2009, 12:46 AM
> Hello, Uri
> 
> On Thu, 2009-03-12 at 06:52 -0700, Uri Shkolnik wrote:
> > # HG changeset patch
> > # User Uri Shkolnik <uris@siano-ms.com>
> > # Date 1236865697 -7200
> > # Node ID 7352ee1288f651d19d58c7bb479a98f070ad98e6
> > # Parent 
> 3392722cc5b687586c4d898b73050ab6e59bf401
> > siano: add high level SDIO interface driver for SMS
> based cards
> > 
> > From: Uri Shkolnik <uris@siano-ms.com>
> > 
> > This patch provides SDIO interface driver for
> > SMS (Siano Mobile Silicon) based devices.
> > The patch includes SMS high level SDIO driver and
> > requires patching the kernel SDIO stack, 
> > those stack patches had been provided previously.
> > 
> > I would like to thank Pierre Ossman, MMC maintainer,
> > who wrote this driver.
> > 
> > Priority: normal
> > 
> > Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> > 
> > diff -r 3392722cc5b6 -r 7352ee1288f6
> linux/drivers/media/dvb/siano/smssdio.c
> > --- /dev/null    Thu Jan 01 00:00:00
> 1970 +0000
> > +++
> b/linux/drivers/media/dvb/siano/smssdio.c   
> Thu Mar 12 15:48:17 2009 +0200
> > @@ -0,0 +1,356 @@
> > +/*
> > + *  smssdio.c - Siano 1xxx SDIO interface
> driver
> > + *
> > + *  Copyright 2008 Pierre Ossman
> 
> I'm sorry, but may be 2009 ?
[ #1 ]

> 
> > + *
> > + * Based on code by Siano Mobile Silicon, Inc.,
> > + * Copyright (C) 2006-2008, Uri Shkolnik
> > + *
> > + * This program is free software; you can
> redistribute it and/or modify
> > + * it under the terms of the GNU General Public
> License as published by
> > + * the Free Software Foundation; either version 2 of
> the License, or (at
> > + * your option) any later version.
> > + *
> > + *
> > + * This hardware is a bit odd in that all transfers
> should be done
> > + * to/from the SMSSDIO_DATA register, yet the
> "increase address" bit
> > + * always needs to be set.
> > + *
> > + * Also, buffers from the card are always aligned to
> 128 byte
> > + * boundaries.
> > + */
> > +
> > +/*
> > + * General cleanup notes:
> > + *
> > + * - only typedefs should be name *_t
> > + *
> > + * - use ERR_PTR and friends for
> smscore_register_device()
> > + *
> > + * - smscore_getbuffer should zero fields
> > + *
> > + * Fix stop command
> > + */
> > +
> > +#include <linux/moduleparam.h>
> > +#include <linux/firmware.h>
> > +#include <linux/delay.h>
> > +#include <linux/mmc/card.h>
> > +#include <linux/mmc/sdio_func.h>
> > +#include <linux/mmc/sdio_ids.h>
> > +
> > +#include "smscoreapi.h"
> > +#include "sms-cards.h"
> > +
> > +/* Registers */
> > +
> > +#define SMSSDIO_DATA   
>     0x00
> > +#define SMSSDIO_INT   
>     0x04
> > +
> > +static const struct sdio_device_id smssdio_ids[] = {
> > +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO,
> SDIO_DEVICE_ID_SIANO_STELLAR),
> > +     .driver_data =
> SMS1XXX_BOARD_SIANO_STELLAR},
> > +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO,
> SDIO_DEVICE_ID_SIANO_NOVA_A0),
> > +     .driver_data =
> SMS1XXX_BOARD_SIANO_NOVA_A},
> > +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO,
> SDIO_DEVICE_ID_SIANO_NOVA_B0),
> > +     .driver_data =
> SMS1XXX_BOARD_SIANO_NOVA_B},
> > +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO,
> SDIO_DEVICE_ID_SIANO_VEGA_A0),
> > +     .driver_data =
> SMS1XXX_BOARD_SIANO_VEGA},
> > +    {SDIO_DEVICE(SDIO_VENDOR_ID_SIANO,
> SDIO_DEVICE_ID_SIANO_VENICE),
> > +     .driver_data =
> SMS1XXX_BOARD_SIANO_VEGA},
> > +    { /* end: all zeroes */ },
> > +};
> > +
> > +MODULE_DEVICE_TABLE(sdio, smssdio_ids);
> > +
> > +struct smssdio_device {
> > +    struct sdio_func *func;
> > +
> > +    struct smscore_device_t *coredev;
> > +
> > +    struct smscore_buffer_t
> *split_cb;
> > +};
> > +
> >
> +/*******************************************************************/
> > +/* Siano core callbacks       
>                
>                
>     */
> >
> +/*******************************************************************/
> > +
> > +static int smssdio_sendrequest(void *context, void
> *buffer, size_t size)
> > +{
> > +    int ret;
> > +    struct smssdio_device *smsdev;
> > +
> > +    smsdev = context;
> > +
> > +    sdio_claim_host(smsdev->func);
> > +
> > +    while (size >=
> smsdev->func->cur_blksize) {
> > +        ret =
> sdio_write_blocks(smsdev->func, SMSSDIO_DATA, buffer,
> 1);
> > +        if (ret)
> > +       
>     goto out;
> > +
> > +        buffer +=
> smsdev->func->cur_blksize;
> > +        size -=
> smsdev->func->cur_blksize;
> > +    }
> > +
> > +    if (size) {
> > +        ret =
> sdio_write_bytes(smsdev->func, SMSSDIO_DATA,
> > +       
>            
>    buffer, size);
> > +        if (ret)
> > +       
>     goto out;
> > +    }
> 
> Do you really need this check and goto ?
> Without them, as i see, the algorithm will do the same.
> 

[ #2 ]

> > +
> > +out:
> > +   
> sdio_release_host(smsdev->func);
> > +
> > +    return ret;
> > +}
> > +
> >
> +/*******************************************************************/
> > +/* SDIO callbacks         
>                
>                
>         */
> >
> +/*******************************************************************/
> > +
> > +static void smssdio_interrupt(struct sdio_func
> *func)
> > +{
> > +    int ret, isr;
> > +
> > +    struct smssdio_device *smsdev;
> > +    struct smscore_buffer_t *cb;
> > +    struct SmsMsgHdr_ST *hdr;
> > +    size_t size;
> > +
> > +    smsdev = sdio_get_drvdata(func);
> > +
> > +    /*
> > +     * The interrupt
> register has no defined meaning. It is just
> > +     * a way of turning of
> the level triggered interrupt.
> > +     */
> > +    isr = sdio_readb(func,
> SMSSDIO_INT, &ret);
> > +    if (ret) {
> > +       
> dev_err(&smsdev->func->dev,
> > +       
>     "Unable to read interrupt register!\n");
> > +        return;
> > +    }
> > +
> > +    if (smsdev->split_cb == NULL)
> {
> > +        cb =
> smscore_getbuffer(smsdev->coredev);
> > +        if (!cb) {
> > +       
>     dev_err(&smsdev->func->dev,
> > +       
>         "Unable to allocate
> data buffer!\n");
> > +       
>     return;
> > +        }
> > +
> > +        ret =
> sdio_read_blocks(smsdev->func, cb->p, SMSSDIO_DATA,
> 1);
> > +        if (ret) {
> > +       
>     dev_err(&smsdev->func->dev,
> > +       
>         "Error %d reading
> initial block!\n", ret);
> > +       
>     return;
> > +        }
> > +
> > +        hdr =
> cb->p;
> > +
> > +        if
> (hdr->msgFlags & MSG_HDR_FLAG_SPLIT_MSG) {
> > +       
>     smsdev->split_cb = cb;
> > +       
>     return;
> > +        }
> > +
> > +        size =
> hdr->msgLength - smsdev->func->cur_blksize;
> > +    } else {
> > +        cb =
> smsdev->split_cb;
> > +        hdr =
> cb->p;
> > +
> > +        size =
> hdr->msgLength - sizeof(struct SmsMsgHdr_ST);
> > +
> > +       
> smsdev->split_cb = NULL;
> > +    }
> > +
> > +    if (hdr->msgLength >
> smsdev->func->cur_blksize) {
> > +        void *buffer;
> > +
> > +        size =
> ALIGN(size, 128);
> > +        buffer =
> cb->p + hdr->msgLength;
> > +
> > +       
> BUG_ON(smsdev->func->cur_blksize != 128);
> > +
> > +        /*
> > +         *
> First attempt to transfer all of it in one go...
> > +         */
> > +        ret =
> sdio_read_blocks(smsdev->func, buffer,
> > +       
>            
>    SMSSDIO_DATA, size / 128);
> > +        if (ret
> && ret != -EINVAL) {
> > +       
>     smscore_putbuffer(smsdev->coredev,
> cb);
> > +       
>     dev_err(&smsdev->func->dev,
> > +       
>         "Error %d reading data
> from card!\n", ret);
> > +       
>     return;
> > +        }
> > +
> > +        /*
> > +         *
> ..then fall back to one block at a time if that is
> > +         *
> not possible...
> > +         *
> > +         *
> (we have to do this manually because of the
> > +         *
> problem with the "increase address" bit)
> > +         */
> > +        if (ret ==
> -EINVAL) {
> > +       
>     while (size) {
> > +       
>         ret =
> sdio_read_blocks(smsdev->func,
> > +       
>            
>            buffer,
> SMSSDIO_DATA, 1);
> > +       
>         if (ret) {
> > +       
>            
> smscore_putbuffer(smsdev->coredev, cb);
> > +       
>            
> dev_err(&smsdev->func->dev,
> > +       
>            
>     "Error %d reading "
> > +       
>            
>     "data from card!\n", ret);
> > +       
>            
> return;
> > +       
>         }
> > +
> > +       
>         buffer +=
> smsdev->func->cur_blksize;
> > +       
>         if (size >
> smsdev->func->cur_blksize)
> > +       
>            
> size -= smsdev->func->cur_blksize;
> > +       
>         else
> > +       
>            
> size = 0;
> > +       
>     }
> > +        }
> > +    }
> > +
> > +    cb->size = hdr->msgLength;
> > +    cb->offset = 0;
> > +
> > +   
> smscore_onresponse(smsdev->coredev, cb);
> > +}
> > +
> > +static int smssdio_probe(struct sdio_func *func,
> > +       
>      const struct sdio_device_id
> *id)
> > +{
> > +    int ret;
> > +
> > +    int board_id;
> > +    struct smssdio_device *smsdev;
> > +    struct smsdevice_params_t params;
> > +
> > +    board_id = id->driver_data;
> > +
> > +    smsdev = kzalloc(sizeof(struct
> smssdio_device), GFP_KERNEL);
> > +    if (!smsdev)
> > +        return
> -ENOMEM;
> > +
> > +    smsdev->func = func;
> > +
> > +    memset(&params, 0,
> sizeof(struct smsdevice_params_t));
> > +
> > +    params.device =
> &func->dev;
> > +    params.buffer_size =
> 0x5000;    /* ?? */
> > +    params.num_buffers =
> 22;    /* ?? */
> > +    params.context = smsdev;
> > +
> > +    snprintf(params.devpath,
> sizeof(params.devpath),
> > +   
>      "sdio\\%s",
> sdio_func_id(func));
> > +
> > +    params.sendrequest_handler =
> smssdio_sendrequest;
> > +
> > +    params.device_type =
> sms_get_board(board_id)->type;
> > +
> > +    if (params.device_type !=
> SMS_STELLAR)
> > +        params.flags |=
> SMS_DEVICE_FAMILY2;
> > +    else {
> > +        /*
> > +         *
> FIXME: Stellar needs special handling...
> > +         */
> > +        ret = -ENODEV;
> > +        goto free;
> > +    }
> > +
> > +    ret =
> smscore_register_device(&params,
> &smsdev->coredev);
> > +    if (ret < 0)
> > +        goto free;
> > +
> > +   
> smscore_set_board_id(smsdev->coredev, board_id);
> > +
> > +    sdio_claim_host(func);
> > +
> > +    ret = sdio_enable_func(func);
> > +    if (ret)
> > +        goto release;
> > +
> > +    ret = sdio_set_block_size(func,
> 128);
> > +    if (ret)
> > +        goto disable;
> > +
> > +    ret = sdio_claim_irq(func,
> smssdio_interrupt);
> > +    if (ret)
> > +        goto disable;
> > +
> > +    sdio_set_drvdata(func, smsdev);
> > +
> > +    sdio_release_host(func);
> > +
> > +    ret =
> smscore_start_device(smsdev->coredev);
> > +    if (ret < 0)
> > +        goto reclaim;
> > +
> > +    return 0;
> > +
> > +reclaim:
> > +    sdio_claim_host(func);
> > +    sdio_release_irq(func);
> > +disable:
> > +    sdio_disable_func(func);
> > +release:
> > +    sdio_release_host(func);
> > +   
> smscore_unregister_device(smsdev->coredev);
> > +free:
> > +    kfree(smsdev);
> > +
> > +    return ret;
> > +}
> > +
> > +static void smssdio_remove(struct sdio_func *func)
> > +{
> > +    struct smssdio_device *smsdev;
> > +
> > +    smsdev = sdio_get_drvdata(func);
> > +
> > +    /* FIXME: racy! */
> > +    if (smsdev->split_cb)
> > +       
> smscore_putbuffer(smsdev->coredev, smsdev->split_cb);
> 
> May be you want to introduce mutex lock or even spinlock to
> prevent race
> condition ?
> 
[ #3 ]
> 
> > +
> > +   
> smscore_unregister_device(smsdev->coredev);
> > +
> > +    sdio_claim_host(func);
> > +    sdio_release_irq(func);
> > +    sdio_disable_func(func);
> > +    sdio_release_host(func);
> > +
> > +    kfree(smsdev);
> > +}
> > +
> > +static struct sdio_driver smssdio_driver = {
> > +    .name = "smssdio",
> > +    .id_table = smssdio_ids,
> > +    .probe = smssdio_probe,
> > +    .remove = smssdio_remove,
> > +};
> > +
> >
> +/*******************************************************************/
> > +/* Module functions         
>                
>                
>       */
> >
> +/*******************************************************************/
> > +
> > +int smssdio_register(void)
> 
> Dont you want to make this function static int __init ?
> 
[ #4 ]

> > +{
> > +    int ret = 0;
> > +
> > +    printk(KERN_INFO "smssdio: Siano
> SMS1xxx SDIO driver\n");
> > +    printk(KERN_INFO "smssdio:
> Copyright Pierre Ossman\n");
> > +
> > +    ret =
> sdio_register_driver(&smssdio_driver);
> > +
> > +    return ret;
> > +}
> > +
> > +void smssdio_unregister(void)
> 
> And the same here - static void __exit ?

[#5 ]

> 
> > +{
> > +   
> sdio_unregister_driver(&smssdio_driver);
> > +}
> > +
> > +MODULE_DESCRIPTION("Siano SMS1xxx SDIO driver");
> > +MODULE_AUTHOR("Pierre Ossman");
> > +MODULE_LICENSE("GPL");
> 
> 
> Good luck,
> -- 
> best regards, Klimov Alexey
> 
> 

First, before anything else, I would like to thank you for the detailed review.

Regarding this patch and your comments regarding it - A preliminary fact must be shared. This patch had been written by Pierre Ossman, who is the Linux kernel MMC maintainer. He wrote this patch back in summer 2008, and the commit of it has been delayed from various reasons.

This fact establishes two additional issues -
1) Regarding your comment #1, yes it should be 2008... (and not 2009)
2) Regarding re-submitting this particular patch, with some corrections - As it has been requested clearly by Pierre, I must not alter his file, only patch on top of it (e.g. commit it and only than patch it further), unless, of course, if something is broken (than I'll contact him and ask his permission to alter this principal patch). 
But since this driver passes various QA tests and it works fine (and since your comments do not indicate broken things, just suggest improvements), I must obey Pierre's request. So if needed, we'll create a second, following patch, in order to answer your (and others) comments.

Comment #2 - True, this is redundant code, and it will be deleted.

Comment #3 - The first half of a "split message" (which is a device --> host message that is combined from exactly two parts), may be submitted and before the second half is process, the device is removed. Actually, there is no risk with this, since all buffers (dynamically allocated kernel buffers) are freed as a result of this event by the main module component, the "smscore". 

Comment #4 & #5 - Here I must ask a question. The module's init and exit points are in the main component ("smscore"), the SDIO interface drivers is used by this main component, and actually those _register and _unregister functions are inner implementation of the SMS module. Are those module inner component's main entry and exit points need to be flagged as __init and __exit as well?


Best regard,
and thanks again,

Uri


      
