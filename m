Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:41914 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZDER5f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 5 Apr 2009 13:57:35 -0400
Date: Sun, 5 Apr 2009 19:52:19 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Erik =?ISO-8859-1?Q?Andr=E9n?= <erik.andren@gmail.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: libv4l: Possibility of changing the current pixelformat on the
 fly
Message-ID: <20090405195219.08e63cea@free.fr>
In-Reply-To: <49D7C17B.80708@gmail.com>
References: <49D7C17B.80708@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 04 Apr 2009 22:22:19 +0200
Erik Andrén <erik.andren@gmail.com> wrote:
	[snip]
> When flipping the image horizontally, vertically or both, the sensor
> pixel ordering changes. In the m5602 driver I was able to compensate
> for this in the bridge code. In the stv06xx I don't have this
> option. One way of solving this problem is by changing the
> pixelformat on the fly, i. e V4L2_PIX_FMT_SGRB8 is the normal
> format. When a vertical flip is required, change the format to
> V4L2_SBGGR8.
> 
> My current understanding of libv4l is that it probes the pixelformat
>   upon device open. In order for this to work we would need either
> poll the current pixelformat regularly or implement some kind of
> notification mechanism upon a flipping request.
> 
> What do you think is this the right way to go or is there another
> alternative.

Hi Erik,

I saw such a problem in some other webcams. When doing a flip, the
sensor scans the pixels in the reverse order. So,
	R G R G
	G B G B
becomes
	B G B G
	G R G R

The solution is to start the scan one line lower or higher for VFLIP
and one pixel on the left or on the right for HFLIP.

May you do this with all the sensors of the stv06xx?

Cheers.

-- 
Ken ar c'hentan	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
