Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46247
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752209AbcJLCTV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 22:19:21 -0400
Date: Tue, 11 Oct 2016 23:19:13 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Kosuke Tatsukawa <tatsu@ab.jp.nec.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        "Mauro Carvalho Chehab" <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Johannes Stezenbach" <js@linuxtv.org>,
        Jiri Kosina <jikos@kernel.org>,
        "Patrick Boettcher" <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Michael Krufky" <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        "jrg.otte@gmail.com" <jrg.otte@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Wolfram Sang <wsa-dev@sang-engineering.com>
Subject: Re: [PATCH v2 28/31] cpia2_usb: don't use stack for DMA
Message-ID: <20161011231913.4c3df3d4@vento.lan>
In-Reply-To: <17EC94B0A072C34B8DCF0D30AD16044A028EFC0B@BPXM09GP.gisp.nec.co.jp>
References: <c2dd60621e2e63076d4c7e250eed9cacb7d5bad3.1476179975.git.mchehab@s-opensource.com>
        <17EC94B0A072C34B8DCF0D30AD16044A028EFC0B@BPXM09GP.gisp.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Oct 2016 22:56:06 +0000
Kosuke Tatsukawa <tatsu@ab.jp.nec.com> escreveu:

> Hi,
> 
> > The USB control messages require DMA to work. We cannot pass
> > a stack-allocated buffer, as it is not warranted that the
> > stack would be into a DMA enabled area.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/usb/cpia2/cpia2_usb.c | 32 +++++++++++++++++++++++++++++---
> >  1 file changed, 29 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/usb/cpia2/cpia2_usb.c b/drivers/media/usb/cpia2/cpia2_usb.c
> > index 13620cdf0599..417d683b237d 100644
> > --- a/drivers/media/usb/cpia2/cpia2_usb.c
> > +++ b/drivers/media/usb/cpia2/cpia2_usb.c
> > @@ -545,10 +545,19 @@ static void free_sbufs(struct camera_data *cam)
> >  static int write_packet(struct usb_device *udev,
> >  			u8 request, u8 * registers, u16 start, size_t size)
> >  {
> > +	unsigned char *buf;
> > +	int ret;
> > +
> >  	if (!registers || size <= 0)
> >  		return -EINVAL;
> >  
> > -	return usb_control_msg(udev,
> > +	buf = kmalloc(size, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	memcpy(buf, registers, size);
> > +
> > +	ret = usb_control_msg(udev,
> >  			       usb_sndctrlpipe(udev, 0),
> >  			       request,
> >  			       USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> > @@ -557,6 +566,9 @@ static int write_packet(struct usb_device *udev,
> >  			       registers,	/* buffer */  
>                                =========
> 
> I think you also want to change the argument to usb_control_msg() from
> "registers" to "buf" in write_packet().

True!

Thanks for pointing it! Just sent a version of the patch with this fixed.

Regards,
Mauro
