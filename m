Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32955 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946892AbdDYLaN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Apr 2017 07:30:13 -0400
Date: Tue, 25 Apr 2017 13:30:09 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, sre@kernel.org,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, ivo.g.dimitrov.75@gmail.com,
        patrikbachan@gmail.com, serge@hallyn.com, abcloriens@gmail.com,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Subject: Re: support autofocus / autogain in libv4l2
Message-ID: <20170425113009.GH30553@pali>
References: <20170414232332.63850d7b@vento.lan>
 <20170416091209.GB7456@valkosipuli.retiisi.org.uk>
 <20170419105118.72b8e284@vento.lan>
 <20170424093059.GA20427@amd>
 <20170424103802.00d3b554@vento.lan>
 <20170424212914.GA20780@amd>
 <20170424224724.5bb52382@vento.lan>
 <20170425080538.GA30380@amd>
 <20170425080815.GD30553@pali>
 <20170425112330.GB7926@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170425112330.GB7926@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday 25 April 2017 13:23:30 Pavel Machek wrote:
> Hi!
> On Tue 2017-04-25 10:08:15, Pali Rohár wrote:
> > On Tuesday 25 April 2017 10:05:38 Pavel Machek wrote:
> > > > > It would be nice if more than one application could be accessing the
> > > > > camera at the same time... (I.e. something graphical running preview
> > > > > then using command line tool to grab a picture.) This one is
> > > > > definitely not solveable inside a library...
> > > > 
> > > > Someone once suggested to have something like pulseaudio for V4L.
> > > > For such usage, a server would be interesting. Yet, I would code it
> > > > in a way that applications using libv4l will talk with such daemon
> > > > in a transparent way.
> > > 
> > > Yes, we need something like pulseaudio for V4L. And yes, we should
> > > make it transparent for applications using libv4l.
> > 
> > IIRC there is already some effort in writing such "video" server which
> > would support accessing more application into webcam video, like
> > pulseaudio server for accessing more applications to microphone input.
> 
> Do you have project name / url / something?

Pinos (renamed from PulseVideo)

https://blogs.gnome.org/uraeus/2015/06/30/introducing-pulse-video/
https://cgit.freedesktop.org/~wtay/pinos/

But from git history it looks like it is probably dead now...

-- 
Pali Rohár
pali.rohar@gmail.com
