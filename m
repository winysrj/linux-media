Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:55936 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbeC2TT4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 29 Mar 2018 15:19:56 -0400
Date: Thu, 29 Mar 2018 16:19:46 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Nasser <afshin.nasser@gmail.com>
Cc: p.zabel@pengutronix.de, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, bparrot@ti.com, garsilva@embeddedor.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media: i2c: tvp5150: fix color burst lock instability
 on some hardware
Message-ID: <20180329161946.3a8cdd0d@recife.lan>
In-Reply-To: <20180329180757.GA27220@smart-ThinkPad-T410>
References: <20180325225633.5899-1-Afshin.Nasser@gmail.com>
        <20180326064353.187f752c@vento.lan>
        <20180326222921.GA5373@smart-ThinkPad-T410>
        <20180329143435.GA4392@smart-ThinkPad-T410>
        <20180329120240.169a5f33@vento.lan>
        <20180329180757.GA27220@smart-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 29 Mar 2018 22:37:57 +0430
Nasser <afshin.nasser@gmail.com> escreveu:

> On Thu, Mar 29, 2018 at 12:02:40PM -0300, Mauro Carvalho Chehab wrote:
> > Em Thu, 29 Mar 2018 19:04:35 +0430
> > Nasser <afshin.nasser@gmail.com> escreveu:
> >   
> > > On Tue, Mar 27, 2018 at 02:59:21AM +0430, Nasser wrote:
> > > Hi Mauro,
> > > 
> > > Thank you for taking time to review my patch.
> > > 
> > > May be I should rephrase the commit message to something like:
> > > 	Use the default register values as suggested in TVP5150AM1 datasheet
> > > 
> > > As this is not a hardware-dependent issue. Am I missing something?  
> > 
> > It is not a matter of rephasing, but, instead, to be sure that it won't
> > cause regressions on existing hardware.
> > 
> > Yet, it would worth if you could describe at the patch what hardware
> > did you test it, and if VBI was tested too.
> >   
> 
> Does this means that I should resend the patch with this additional info?
> Sorry for not being clear about that. This was a custom board based on
> ARM. The VBI was not used.

That's what I suspected when you send your patch :-)

The tvp5150 is used by several USB and PCI devices for analog TV and
for video stream capture, with may have different requirements from what
you're doing on your ARM board.

Changing a register setting global wide without enough care will
very likely break support for existing boards.

That's why I said that the right thing to do is to pass a parameter to
the driver specifying what "extra" features are needed.

Without looking at tvp5150/tvp5151/tvp5150am datasheets nor testing,
I'd risk to say that, at the specific case of your patch, touching at
VBLK settings have a potential risk of affecting VBI handling.

> > Anyway, I'll try to find some time to run some tests on the hardware
> > I have with tvp5150 too.  
> 
> It sounds great.

Yes, but I won't be able to do it on the next couple of weeks. We're
approaching the merge window for Kernel 4.17.

Thanks,
Mauro
