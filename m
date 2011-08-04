Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:34601 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1HDQiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Aug 2011 12:38:06 -0400
Received: from tele (unknown [IPv6:2a01:e35:2f5c:9de0:212:bfff:fe1e:8db5])
	by smtp1-g21.free.fr (Postfix) with ESMTP id 9C2179401A3
	for <linux-media@vger.kernel.org>; Thu,  4 Aug 2011 18:37:57 +0200 (CEST)
Date: Thu, 4 Aug 2011 18:40:20 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Workshop-2011] Media Subsystem Workshop 2011
Message-ID: <20110804184020.6edb96d8@tele>
In-Reply-To: <4E3A9332.1060404@redhat.com>
References: <4E398381.4080505@redhat.com>
 <alpine.LNX.2.00.1108031418480.16384@banach.math.auburn.edu>
 <4E39B150.40108@redhat.com>
 <4E3A84F0.5050208@redhat.com>
 <4E3A9332.1060404@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 04 Aug 2011 09:40:18 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> > What we need for this is a simple API (new v4l ioctl's I guess) for the
> > stillcam mode of these dual mode cameras (stillcam + webcam). So that the
> > webcam drivers can grow code to also allow access to the stored pictures,
> > which were taken in standalone (iow not connected to usb) stillcam mode.
> > 
> > This API does not need to be terribly complex. AFAIK all of the currently
> > supported dual cam cameras don't have filenames only picture numbers,
> > so the API could consist of a simple, get highest picture nr, is picture
> > X present (some slots may contain deleted pictures), get picture X,
> > delete picture X, delete all API.  
> 
> That sounds to work. I would map it on a way close to the controls API
> (or like the DVB FE_[GET|SET]_PROPERTY API), as this would make easier to expand
> it in the future, if we start to see webcams with file names or other things
> like that.

I did not follow all the thread, but I was wondering about an other
solution: what about offering both USB mass storage and webcam accesses?

When a dual-mode webcam is plugged in, the driver creates two devices,
the video device /dev/videox and the volume /dev/sdx. When the webcam is
opened, the volume cannot be mounted. When the volume is mounted, the
webcam cannot be opened. There is no need for a specific API. As Mauro
said:

> For those, we may eventually need some sort of locking between
> the USB storage and V4L.

That's all. By where am I wrong?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
