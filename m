Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:59535 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0AKJyN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2010 04:54:13 -0500
Date: Mon, 11 Jan 2010 10:55:24 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Problem with gspca and zc3xx
Message-ID: <20100111105524.157ebdbe@tele>
In-Reply-To: <4B4AE349.4000707@redhat.com>
References: <201001090015.31357.jareguero@telefonica.net>
	<20100110093730.14be3d7c@tele>
	<4B4AE349.4000707@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 11 Jan 2010 09:37:29 +0100
Hans de Goede <hdegoede@redhat.com> wrote:

> This is the infamous zc3xx bottom of the image is missing in 320x240
> problem, with several sensors the register settings we took from the
> windows driver will only give you 320x232 (iirc), we tried changing
> them to get 320x240, but then the camera would not stream. Most
> likely some timing issue between bridge and sensor.
> 
> I once had a patch fixing this by actually reporting the broken modes
> as 320x232, but that never got applied as it breaks app which are
> hardcoded to ask for 320x240. libv4l has had the ability to extend
> the 320x232 image to 320x240 for a while now (by adding a few black
> lines at the top + bottom), fixing the hardcoded apps problem.
> 
> So I think such a patch can and should be applied now. This will get
> rid of the jpeg decompression errors reported by libv4l and in case
> if yuv mode the ugly green bar with some random noise in it at the
> bottom.
> 
> I'm afraid my patch is most likely lost, but I can create a new one
> if you want, I have access to quite a few zc3xx camera's, and more
> over what resolution they are actually streaming at can be deducted
> from the register settings in the driver.

Hi Hans,

As you may see in Jose Alberto's message, the problem occurs with
640x480 and, yes, the image bottom is lacking, but also the right side.

I did not lose your patch, but I did not apply it because most of the
time, the webcams work in the best resolution (VGA) and the associated
problem has not found yet a good resolution...

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
