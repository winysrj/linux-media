Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40367 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751939AbZLCJDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 3 Dec 2009 04:03:45 -0500
Date: Thu, 3 Dec 2009 10:03:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe Taeubert <u.taeubert@road.de>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Problem on RJ54N1CB0C
In-Reply-To: <200912030948.43627.u.taeubert@road.de>
Message-ID: <Pine.LNX.4.64.0912030959560.4328@axis700.grange>
References: <200911130950.30581.u.taeubert@road.de> <200911160807.25160.u.taeubert@road.de>
 <Pine.LNX.4.64.0911170909440.4504@axis700.grange> <200912030948.43627.u.taeubert@road.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Uwe

On Thu, 3 Dec 2009, Uwe Taeubert wrote:

> Hello Guennadi,
> now  our driver is working. I found the registers to fix and manipulate the 
> exposure values. So, now, if I switch from preview to heigher resolution 
> pictures, the taken photo is as bright as the preview. I read out the preview 
> exposure data, modify it according to the desired divider settings and then I 
> switch to the new mode. 
> Now it is also possible to change exposure values in case of flashlight use 
> depending on AF values to prevent over exposure of near objects. But, it is 
> not done, yet.
> The resolution depending divider switching is not tested in all details, yet. 
> It is done for our preferred resolutions.

cool! Thanks for sharing your success! I'm currently busy with getting 
ready for the approaching merge window, but it would be good to get your 
functionality integrated in the mainline driver. I think, it would also be 
good for you to migrate to the in-tree version, so, would be cool, if you 
could try the mainstream version and send us patches against it.

> I'm using the English version.

Hm, good to know...

Thanks
Guennadi
> 
> Regard
> Uwe
> 
> Am Tuesday 17 November 2009 09:28:18 schrieben Sie:
> > Hi Uwe
> >
> > On Mon, 16 Nov 2009, Uwe Taeubert wrote:
> > > Hi Guennadi
> > > You will find the driver sources for our Sharp module in lz0p39ha.c and
> > > the initialization data in lz0p39ha_init.c. In lz0p35du_set_fmt_cap() you
> > > can see the resolution depending change of the divider. In our system we
> > > get correct pictures in all resolution mensioned there. But FYI, if no
> > > flashlight is desired, we do not switch to still mode - only still mode
> > > generates flash controll signals.
> > > We are working with the Technical Manual Ver. 2.2C, also under NDA.
> >
> > May I ask you if you have an English or a Japanese version?:-) I've got a
> > 2.3C Japanese...
> >
> > > Concerning the exposure control, I know the use of the registers 0x04d8
> > > and 0x04d9 is more a hack but a solution. And the result is unsatisfying
> > > - it was a try.divide  
> > >
> > > At the moment I'm checking the influence of RAMPCLK- TGCLK-ratio. I was
> > > able to get higher exposer by changing RAMPCLK but I wasn't able to
> > > calculate a well doing relation between all clocks and to have a fast
> > > frame rate.
> > >
> > > The driver content is in a preliminary state. I'm working on
> > > lz0p35du_set_fmt_cap function. We do not diffenrentialte between preview
> > > and still mode. It makes it easier to handle buffers in VFL at the
> > > moment.
> >
> > Thanks for the code. I looked briefly at it and one essential difference
> > that occurred to me is, that you're setting the RESIZE registers at the
> > beginning of the format-change function (lz0p35du_set_fmt_cap()), and I am
> > doing this following code examples, that I had in the end, followed by a
> > killer delay of 230ms... You might try to do that in the end, but it might
> > only become worse, because, as I said, my version of the driver has
> > problems with bigger images.
> >
> > My driver also doesn't set autofocus ATM, as there had been errors in
> > examples that I had and I didn't have time to experiment with those
> > values. I'm also relying on the automatic exposure area selection (0x58c
> > bit 7) instead of setting it automatically. You also don't seem to
> > dynamically adjust INC_USE_SEL registers, instead you just initialise them
> > to 0xff. And in my experience that register does make a difference, so,
> > you might try to play with it a bit. Have a look at my driver, although, I
> > don't think values I configure there are perfect either.
> >
> > In fact, it might indeed become a problem for you, that you're updating
> > the RESIZE registers too early and not pausing after that.
> >
> > Unfortunately, I do not have time now to look at the driver in detail ATM,
> > let me know your results when you fix your problem.
> >
> > Thanks
> > Guennadi
> > ---
> > Guennadi Liakhovetski, Ph.D.
> > Freelance Open-Source Software Developer
> > http://www.open-technology.de/
> 
> 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
