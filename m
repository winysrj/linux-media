Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:59287
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751970AbcKGMxu (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 7 Nov 2016 07:53:50 -0500
Date: Mon, 7 Nov 2016 10:53:42 -0200
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Johannes Stezenbach <js@linuxtv.org>
Cc: VDR User <user.vdr@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jiri Kosina <jikos@kernel.org>,
        Patrick Boettcher <patrick.boettcher@posteo.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        =?UTF-8?B?SsO2cmc=?= Otte <jrg.otte@gmail.com>
Subject: Re: [PATCH v2 18/31] gp8psk: don't do DMA on stack
Message-ID: <20161107105342.2ea517bb@vento.lan>
In-Reply-To: <20161107112947.qlxpzhxi5k3w7ajz@linuxtv.org>
References: <cover.1476179975.git.mchehab@s-opensource.com>
        <632081ba085ddf0ded63cce3dbcf3870485d3cd3.1476179975.git.mchehab@s-opensource.com>
        <CAA7C2qiW+Co3XVt1AQDYka9MdSYG8OELxNzecqAia9df0P3Neg@mail.gmail.com>
        <20161107112947.qlxpzhxi5k3w7ajz@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 7 Nov 2016 12:29:47 +0100
Johannes Stezenbach <js@linuxtv.org> escreveu:

> On Sun, Nov 06, 2016 at 11:51:14AM -0800, VDR User wrote:
> > I applied this patch to the 4.8.4 kernel driver (that I'm currently
> > running) and it caused nothing but "frontend 0/0 timed out while
> > tuning". Is there another patch that should be used in conjunction
> > with this? If not, this patch breaks the gp8psk driver.
> > 
> > Thanks.  
> 
> Thanks for testing.  "If it's not tested it's broken"...
> 
> > On Tue, Oct 11, 2016 at 3:09 AM, Mauro Carvalho Chehab
> > <mchehab@s-opensource.com> wrote:  
> 
> > > index 5d0384dd45b5..fa215ad37f7b 100644
> > > --- a/drivers/media/usb/dvb-usb/gp8psk.c
> > > +++ b/drivers/media/usb/dvb-usb/gp8psk.c  
> 
> > >  int gp8psk_usb_in_op(struct dvb_usb_device *d, u8 req, u16 value, u16 index, u8 *b, int blen)
> > >  {
> > > +       struct gp8psk_state *st = d->priv;
> > >         int ret = 0,try = 0;
> > >
> > >         if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
> > >                 return ret;
> > >
> > >         while (ret >= 0 && ret != blen && try < 3) {
> > > +               memcpy(st->data, b, blen);
> > >                 ret = usb_control_msg(d->udev,
> > >                         usb_rcvctrlpipe(d->udev,0),
> > >                         req,
> > >                         USB_TYPE_VENDOR | USB_DIR_IN,
> > > -                       value,index,b,blen,
> > > +                       value, index, st->data, blen,
> > >                         2000);  
> 
> I guess for usb_in the memcpy should be after the usb_control_msg
> and from st->data to b.

Yes, this should fix the issue. Just sent a patch with Johannes
suggestion. Please test.

Regards,
Mauro
