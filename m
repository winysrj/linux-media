Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:44519 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbaEVKPf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 May 2014 06:15:35 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N5Z00BVP0HXVG30@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 May 2014 06:15:33 -0400 (EDT)
Date: Thu, 22 May 2014 07:15:26 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Changbing Xiong <cb.xiong@samsung.com>,
	Trevor G <trevor.forums@gmail.com>,
	"Reynaldo H. Verdejo Pinochet" <r.verdejo@sisa.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 2/8] [media] au0828: Improve debug messages for
 urb_completion
Message-id: <20140522071526.0e549806.m.chehab@samsung.com>
In-reply-to: <CAPybu_3FbfNXHd8Dp-7UPCuLsrhdjo0kKbLAyfAcu5QpwjWPng@mail.gmail.com>
References: <1400696402-1805-1-git-send-email-m.chehab@samsung.com>
 <1400696402-1805-3-git-send-email-m.chehab@samsung.com>
 <CAPybu_3FbfNXHd8Dp-7UPCuLsrhdjo0kKbLAyfAcu5QpwjWPng@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 22 May 2014 10:36:24 +0200
Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com> escreveu:

> Hello Mauro
> 
> Are you aware that using dynamic printk you can decide to print
> __func__ on demand?
> 
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/dynamic-debug-howto.txt#n213

Yes, I'm aware.

Yet, but changing the driver to use the dynamic printk's should
be done on a separate patch that would convert all printks to use the
dev_* printk macros. 

The goal of this specific patch is just to make the already existing
debug macros more useful, allowing to see when the DMA stuck, like:

[  248.733896] au0828/0: urb_completion: 0
[  248.733900] au0828/0: urb_completion: not streaming!
[  248.733998] au0828/0: urb_completion: 0
[  248.734005] au0828/0: urb_completion: not streaming!
[  248.734042] au0828/0: urb_completion: 0
[  248.734045] au0828/0: urb_completion: not streaming!
[  248.734097] au0828/0: urb_completion: 1536
[  248.734101] au0828/0: urb_completion: not streaming!
[  248.734164] au0828/0: urb_completion: 2048
[  248.734168] au0828/0: urb_completion: not streaming!
[  248.734200] au0828/0: urb_completion: 514
[  248.734204] au0828/0: urb_completion: not streaming!
...
> 
> 
> Perhaps it is better to not add __func__
> 
> Regards!
> 
> On Wed, May 21, 2014 at 8:19 PM, Mauro Carvalho Chehab
> <m.chehab@samsung.com> wrote:
> > Sometimes, it helps to know how much data was received by
> > urb_completion. Add that information to the optional debug
> > log.
> >
> > Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> > ---
> >  drivers/media/usb/au0828/au0828-dvb.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/media/usb/au0828/au0828-dvb.c b/drivers/media/usb/au0828/au0828-dvb.c
> > index 2019e4a168b2..ab5f93643021 100755
> > --- a/drivers/media/usb/au0828/au0828-dvb.c
> > +++ b/drivers/media/usb/au0828/au0828-dvb.c
> > @@ -114,16 +114,20 @@ static void urb_completion(struct urb *purb)
> >         int ptype = usb_pipetype(purb->pipe);
> >         unsigned char *ptr;
> >
> > -       dprintk(2, "%s()\n", __func__);
> > +       dprintk(2, "%s: %d\n", __func__, purb->actual_length);
> >
> > -       if (!dev)
> > +       if (!dev) {
> > +               dprintk(2, "%s: no dev!\n", __func__);
> >                 return;
> > +       }
> >
> > -       if (dev->urb_streaming == 0)
> > +       if (dev->urb_streaming == 0) {
> > +               dprintk(2, "%s: not streaming!\n", __func__);
> >                 return;
> > +       }
> >
> >         if (ptype != PIPE_BULK) {
> > -               printk(KERN_ERR "%s() Unsupported URB type %d\n",
> > +               printk(KERN_ERR "%s: Unsupported URB type %d\n",
> >                        __func__, ptype);
> >                 return;
> >         }
> > --
> > 1.9.0
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
