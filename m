Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:48356 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbeGYPIy (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Jul 2018 11:08:54 -0400
Date: Wed, 25 Jul 2018 10:57:01 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Akihiro TSUKADA <tskd08@gmail.com>
Cc: Colin Ian King <colin.king@canonical.com>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mika.batsman@gmail.com
Subject: Re: media: dvb-usb-v2/gl861: ensure USB message buffers DMA'able
Message-ID: <20180725105701.4f3b429b@coco.lan>
In-Reply-To: <d2465376-4b3e-7d3d-86d2-0cd8d7543520@gmail.com>
References: <8308d9f0-2257-101c-69e3-8fe165de9348@canonical.com>
        <d2465376-4b3e-7d3d-86d2-0cd8d7543520@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 3 Jul 2018 21:07:07 +0900
Akihiro TSUKADA <tskd08@gmail.com> escreveu:

> Hi,
> thanks for the report.
> 
> >  47        buf = NULL;
> > 
> > Condition rlen > 0, taking false branch.
> > 
> >  48        if (rlen > 0) {
> >  49                buf = kmalloc(rlen, GFP_KERNEL);
> >  50                if (!buf)
> >  51                        return -ENOMEM;
> >  52        }
> > 
> >  53        usleep_range(1000, 2000); /* avoid I2C errors */
> >  54
> >    CID 1470241 (#1 of 1): Explicit null dereferenced (FORWARD_NULL).
> > var_deref_model: Passing null pointer buf to usb_control_msg, which
> > dereferences it.
> > 
> >  55        ret = usb_control_msg(d->udev, usb_rcvctrlpipe(d->udev, 0),
> > req, type,
> >  56                              value, index, buf, rlen, 2000);
> > 
> > 
> > The assignment of buf = NULL means a null buffer is passed down the usb
> > control message stack until it eventually gets dereferenced. This only
> > occurs when rlen <= 0.   I was unsure how to fix this for the case when
> > rlen <= 0, so I am flagging this up as an issue that needs fixing.
> >   
> 
> Since rlen is an u16, null pointer is passed only when rlen == 0,
> so I think it is not a problem,
> but I am OK to add a guard in order to make scan result clean.

There was another patch proposed to fix this issue with does the
right thing when rlen == 0. I rebased it on the top of the current
tree:
	https://git.linuxtv.org/media_tree.git/commit/?id=0b666e1c8120c0b17a8a68aaed58e22011f06ab3

That should cover both cases.

Thanks,
Mauro
