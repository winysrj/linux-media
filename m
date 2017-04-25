Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50085
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S979752AbdDYBrm (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 21:47:42 -0400
Date: Mon, 24 Apr 2017 22:47:31 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170424224724.5bb52382@vento.lan>
In-Reply-To: <20170424212914.GA20780@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
        <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170414232332.63850d7b@vento.lan>
        <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
        <20170419105118.72b8e284@vento.lan>
        <20170424093059.GA20427@amd>
        <20170424103802.00d3b554@vento.lan>
        <20170424212914.GA20780@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 24 Apr 2017 23:29:14 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > > For focus to be useful, we need autofocus implmented
> > > somewhere. Unfortunately, v4l framework does not seem to provide good
> > > place where to put autofocus. I believe, long-term, we'll need some
> > > kind of "video server" providing this kind of services.
> > > 
> > > Anyway, we probably don't want autofocus in kernel (even through some
> > > cameras do it in hardware), and we probably don't want autofocus in
> > > each and every user application.
> > > 
> > > So what remains is libv4l2.   
> > 
> > IMO, the best place for autofocus is at libv4l2. Putting it on a
> > separate "video server" application looks really weird for me.  
> 
> Well... let me see. libraries are quite limited -- it is hard to open
> files, or use threads/have custom main loop. It may be useful to
> switch resolutions -- do autofocus/autogain at lower resolution, then
> switch to high one for taking picture. It would be good to have that
> in "system" code, but I'm not at all sure libv4l2 design will allow
> that.

I don't see why it would be hard to open files or have threads inside
a library. There are several libraries that do that already, specially
the ones designed to be used on multimidia apps.

Resolution switch can indeed be a problem on devices that use MC
and subdev API, as a plugin would be required to teach the library
about N9 specifics (or the Kernel API should be improved to let
a generic application to better detect the hardware capabilities).

> It would be good if application could say "render live camera into
> this window" and only care about user interface, then say "give me a
> high resolution jpeg". But that would require main loop in the
> library...

Nothing prevents writing an upper layer on the top of libv4l in
order to provide such kind of functions.

> It would be nice if more than one application could be accessing the
> camera at the same time... (I.e. something graphical running preview
> then using command line tool to grab a picture.) This one is
> definitely not solveable inside a library...

Someone once suggested to have something like pulseaudio for V4L.
For such usage, a server would be interesting. Yet, I would code it
in a way that applications using libv4l will talk with such daemon
in a transparent way.

> > The above looks really odd. Why do you want to make libv4l2 dependent
> > on sdl?  
> 
> I don't, but I had some nasty problems with linker; this should really
> go into application but it refused to link. Scary libtool.

That's weird. 


> > If you're adding a SDL-specific application, you'll need to add the 
> > needed autoconf bits to detect if SDL devel package is installed,
> > auto-disabling it if not.
> > 
> > Yet, I don't think that SDL should be part of the library, but,
> > instead, part of some application.  
> 
> Agreed. libtool prevented me from doing the right thing.

if you add libSDL detection at configure.ac, you likely won't need to
deal with libtool.

On a quick look at web, it seems that there's a m4 module that does
the right thing, according with:
	https://wiki.libsdl.org/FAQLinux


Thanks,
Mauro
