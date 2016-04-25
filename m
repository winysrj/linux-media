Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:34128 "EHLO
	mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbcDYP0r (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Apr 2016 11:26:47 -0400
Received: by mail-pf0-f170.google.com with SMTP id y69so48084803pfb.1
        for <linux-media@vger.kernel.org>; Mon, 25 Apr 2016 08:26:46 -0700 (PDT)
Date: Mon, 25 Apr 2016 12:26:40 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] [media] tvp686x: Don't go past array
Message-ID: <20160425152640.GA24174@laptop.cereza>
References: <d25dd8ca8edffc6cc8cee2dac9b907c333a0aa84.1461403421.git.mchehab@osg.samsung.com>
 <571E0159.9050406@xs4all.nl>
 <20160425094000.1dc6db29@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160425094000.1dc6db29@recife.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro, Hans:

Thanks for the fixes to this driver :-)

On 25 Apr 09:40 AM, Mauro Carvalho Chehab wrote:
> Ezequiel,
> 
> Btw, I'm not seeing support for fps != 25 (or 30 fps) on this driver.
> As the device seems to support setting the fps, you should be adding
> support on it for VIDIOC_S_PARM and VIDIOC_G_PARM.
> 
> On both ioctls, the driver should return the actual framerate used.
> So, you'll need to add a code that would convert from the 15 possible
> framerate converter register settings to v4l2_fract.
> 

OK, thanks for the information.

In fact, framerate support is implemented in the driver that is in
production.

Support for s_parm, g_parm was in the original submission [1]
but we removed it later [2] because we thought it was unused.
I can't see how we came to that conclusion, since it is actually
used to set the framerate!

Anyway, since we are discussing this, I would like to know if
having s_parm/g_parm is enough for framerate setting support.

When I implemented this a year ago, the v4l2src gstreamer plugin
seemed to require enum_frame_size and enum_frame_interval as well.
It didn't make much sense, but I ended up implementing them
to get it to work. Should that be required?

(To be honest, v4lsrc is quite picky regarding parameters,
so it wouldn't be that surprising if it needs some love).

Thanks!

[1] http://www.spinics.net/lists/linux-media/msg95953.html
[2] http://www.spinics.net/lists/linux-media/msg96503.html
-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
