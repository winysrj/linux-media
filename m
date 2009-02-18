Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:53253 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756730AbZBRTTL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 14:19:11 -0500
Date: Wed, 18 Feb 2009 20:17:15 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Thomas Kaiser <v4l@kaiser-linux.li>, stefano.laspina@virgilio.it
Cc: linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
Message-ID: <20090218201715.27531333@free.fr>
In-Reply-To: <499C05D8.10303@kaiser-linux.li>
References: <20090217200928.1ae74819@free.fr>
	<499B1180.6020600@kaiser-linux.li>
	<20090218102553.608e026c@free.fr>
	<499C05D8.10303@kaiser-linux.li>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2009 13:58:00 +0100
Thomas Kaiser <v4l@kaiser-linux.li> wrote:

> Hello Jean-Francois

Hello Thomas and Steve,

> Thanks, for the frame (or frames?).

It is a full image. It is compressed: the images have different sizes,
about 25 Kb.

> What resolution did you use while recording this stream?

I have not the webcam, it is Steve's. Looking at the image size, I think
the resolution should be 640x480, but it maybe 352x288. Steve?

> Can you put your USB trace somewhere on the net where I can download
> it?

	http://moinejf.free.fr/UsbSnoop.zip

> When I was guessing the streams of webcams, I used to get the sensor 
> into saturation -> complete white picture. So you know how the
> decoded picture should look like ;-)
> 
> Actually, it is quite easy to get a webcam sensor into saturation.
> Just remove the lens of the cam an put a light in front of it. Check
> in Windoz if the picture is really complete white and then record a
> stream in Linux. Now, you should get a very homogeneous stream. Look
> at it and ....
> 
> I hope you got the idea?

Very good idea. Steve, may you do such a trace?

Cheers.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
