Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:50119
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S938935AbdDYB5t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 24 Apr 2017 21:57:49 -0400
Date: Mon, 24 Apr 2017 22:57:38 -0300
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
        linux-media@vger.kernel.org, hdegoede@redhat.com
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170424225731.7532e368@vento.lan>
In-Reply-To: <20170424220701.GA27846@amd>
References: <1487074823-28274-1-git-send-email-sakari.ailus@linux.intel.com>
        <1487074823-28274-2-git-send-email-sakari.ailus@linux.intel.com>
        <20170414232332.63850d7b@vento.lan>
        <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
        <20170419105118.72b8e284@vento.lan>
        <20170424093059.GA20427@amd>
        <20170424103802.00d3b554@vento.lan>
        <20170424220701.GA27846@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 25 Apr 2017 00:07:01 +0200
Pavel Machek <pavel@ucw.cz> escreveu:

> Hi!
> 
> > Please don't add a new application under lib/. It is fine if you want
> > some testing application, if the ones there aren't enough, but please
> > place it under contrib/test/.
> > 
> > You should likely take a look at v4l2grab first, as it could have
> > almost everything you would need.  
> 
> I really need some kind of video output. v4l2grab is not useful
> there. v4l2gl might be, but I don't think I have enough dependencies.

Well, you could use some app to show the snaps that v4l2grab takes.

Yeah, compiling v4l2gl on N9 can indeed be complex. I suspect that it 
shouldn't hard to compile xawtv there (probably disabling some optional
features).

> Umm, and it looks like libv4l can not automatically convert from
> GRBG10.. and if it could, going through RGB24 would probably be too
> slow on this device :-(.

I suspect it shouldn't be hard to add support for GRBG10. It already
supports 8 and 16 bits Bayer formats, at lib/libv4lconvert/bayer.c
(to both RGB and YUV formats).

How it would preform is another question ;)

> > IMO, the above belongs to a separate processing module under
> > 	lib/libv4lconvert/processing/  
> 
> Is there an example using autogain/autowhitebalance from
> libv4lconvert?

Well, if you plug a USB camera without those controls, it should
automatically expose controls for it, as if the device had such
controls.

Thanks,
Mauro
