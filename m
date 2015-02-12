Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:55219 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbbBLV5G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 16:57:06 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so7880267wiv.2
        for <linux-media@vger.kernel.org>; Thu, 12 Feb 2015 13:57:04 -0800 (PST)
Date: Thu, 12 Feb 2015 21:57:00 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: David =?utf-8?B?Q2ltYsWvcmVr?= <david.cimburek@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
Message-ID: <20150212215700.GA4882@turing>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <54D9E14A.5090200@iki.fi>
 <e65f6b905eae37f11e697ad20b97c37c@hardeman.nu>
 <CAEmZozPN2xDQMyao8GAYB1KqKxvgznn6CNc+LgPGhE=TJfDbFQ@mail.gmail.com>
 <32c10d8cd2303ed9476db1b68924170a@hardeman.nu>
 <CAEmZozP5jrJnWAF6ZbXtvkRveZE29BnSg+hO2x9KDSyPmjBBaQ@mail.gmail.com>
 <20150212095029.018f63df@recife.lan>
 <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEmZozOTuigxavH_5M4mw5kDHS_mxgwLS53HipG2o4uvm_09OQ@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 12, 2015 at 06:34:40PM +0100, David Cimbůrek wrote:
> 2015-02-12 12:50 GMT+01:00 Mauro Carvalho Chehab <mchehab@osg.samsung.com>:
> > Em Wed, 11 Feb 2015 17:41:01 +0100
> > David Cimbůrek <david.cimburek@gmail.com> escreveu:
> >
> > Please don't top post. I reordered the messages below in order to get some
> > sanity.
> >
> >>
> >> 2015-02-11 15:40 GMT+01:00 David Härdeman <david@hardeman.nu>:
> >> > Can you generate some scancodes before and after commit
> >> > af3a4a9bbeb00df3e42e77240b4cdac5479812f9?
> >>
> >> Let me know what exactly do you want me to do (which commands, which
> >> traces etc.). I'm not very familiar with the Linux media stuff...
> >
> > As root, you should run:
> >
> >         # ir-keytable -r
> >
> > This will print the scancodes and their key associations.
> >
> > Also, on what architecture are you testing?
> >
> > Regards,
> > Mauro
> 
> Output of the "ir-keytable -r" is available here:
> http://pastebin.com/eEDu1Bmn. It is the same before and after the
> patch.
> 
> Architecture is x86_64.
>
>

>From the top-posted thread. Merging it here to not confuse people.

> I'll try to describe my thoughts.
> 
> The changed structure "dib0700_rc_response" is used in
> dib0700_core.c:dib0700_rc_urb_completion(struct urb *purb) function:
> 
> struct dib0700_rc_response *poll_reply;
> ...
> poll_reply = purb->transfer_buffer;
> 
> dib0700_rc_urb_completion() is then used in
> dib0700_core.c:dib0700_rc_setup() in macros usb_fill_bulk_urb and
> usb_fill_int_urb. These macros are defined in header file usb.h. Here
> I have found in macro description this:
> 
>  * @transfer_buffer: pointer to the transfer buffer
> 
> I suppose that it means that the struct dib0700_rc_response is being
> filled from this transfer buffer. Therefore I suppose that the order
> of structure members IS important.
> 
> Of course it's only my guess but my patch is really working for me :-)

Hi,

I looked at this again and I still don't see why the order is important.
Plus the code looks like it does what it should be doing when using
RC_SCANCODE_NEC, RC_SCANCODE_NEC32, RC_SCANCODE_NECX and RC_SCANCODE_RC5.

Unfortunately I can't review this if I am not sure about it, and I don't
have the device to be able to properly test your patch.

Hopefully your print of the scancodes helps.

Luis
