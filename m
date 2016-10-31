Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34154 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S947759AbcJaW7X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Oct 2016 18:59:23 -0400
Date: Tue, 1 Nov 2016 00:58:45 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Pavel Machek <pavel@ucw.cz>
Cc: ivo.g.dimitrov.75@gmail.com, sre@kernel.org, pali.rohar@gmail.com,
        linux-media@vger.kernel.org, galak@codeaurora.org,
        mchehab@osg.samsung.com, linux-kernel@vger.kernel.org,
        laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v4] media: Driver for Toshiba et8ek8 5MP sensor
Message-ID: <20161031225845.GC3217@valkosipuli.retiisi.org.uk>
References: <20161023200355.GA5391@amd>
 <20161023201954.GI9460@valkosipuli.retiisi.org.uk>
 <20161023204001.GD6391@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161023204001.GD6391@amd>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pavel,

(Cc Laurent.)

On Sun, Oct 23, 2016 at 10:40:01PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Thanks, this answered half of my questions already. ;-)
> > 
> > Do all the modes work for you currently btw.?
> 
> Aha, went through my notes. This is what it does in 5MP mode, even on
> v4.9:
> 
> pavel@n900:/my/fcam-dev$ ./camera.py
> ['-r']
> ['-l', '"et8ek8 3-003e":0 -> "video-bus-switch":1 [1]']
> ['-l', '"video-bus-switch":0 -> "OMAP3 ISP CCP2":0 [1]']
> ['-l', '"OMAP3 ISP CCP2":1 -> "OMAP3 ISP CCDC":0 [1]']
> ['-l', '"OMAP3 ISP CCDC":1 -> "OMAP3 ISP CCDC output":0 [1]']
> ['-V', '"et8ek8 3-003e":0 [SGRBG10 2592x1968]']
> ['-V', '"OMAP3 ISP CCP2":0 [SGRBG10 2592x1968]']
> ['-V', '"OMAP3 ISP CCP2":1 [SGRBG10 2592x1968]']
> ['-V', '"OMAP3 ISP CCDC":1 [SGRBG10 2592x1968]']
> ['-V', '"OMAP3 ISP CCDC":2 [SGRBG10 2592x1968]']
> Device /dev/video2 opened.
> Device `OMAP3 ISP CCDC output' on `media' is a video capture (without
> mplanes) device.
> Video format set: SGRBG10 (30314142) 2592x1968 (stride 5184) field
> none buffer size 10202112
> Video format: SGRBG10 (30314142) 2592x1968 (stride 5184) field none
> buffer size 10202112
> 4 buffers requested.
> length: 10202112 offset: 0 timestamp type/source: mono/EoF
> Buffer 0/0 mapped at address 0xb63a0000.
> length: 10202112 offset: 10203136 timestamp type/source: mono/EoF
> Buffer 1/0 mapped at address 0xb59e5000.
> length: 10202112 offset: 20406272 timestamp type/source: mono/EoF
> Buffer 2/0 mapped at address 0xb502a000.
> length: 10202112 offset: 30609408 timestamp type/source: mono/EoF
> Buffer 3/0 mapped at address 0xb466f000.
> 0 (0) [E] any 0 10202112 B 0.000000 2792.366987 0.001 fps ts mono/EoF
> Unable to queue buffer: Input/output error (5).
> Unable to requeue buffer: Input/output error (5).
> Unable to release buffers: Device or resource busy (16).
> pavel@n900:/my/fcam-dev$
> 
> (gitlab.com fcam-dev branch good)
> 
> Kernel will say
> 
> [ 2689.598358] stream on success
> [ 2702.426635] Streamon
> [ 2702.426727] check_format checking px 808534338 808534338, h 984
> 984, w 1296 1296, bpline 2592 2592, size 2550528 2550528 field 1 1
> [ 2702.426818] configuring for 1296(2592)x984
> [ 2702.434722] stream on success
> [ 2792.276184] Streamon
> [ 2792.276306] check_format checking px 808534338 808534338, h 1968
> 1968, w 2592 2592, bpline 5184 5184, size 10202112 10202112 field 1 1
> [ 2792.276367] configuring for 2592(5184)x1968
> [ 2792.284240] stream on success
> [ 2792.368164] omap3isp 480bc000.isp: CCDC won't become idle!

This is Bad(tm).

It means that the driver waited for the CCDC to become idle to reprogram it,
but it didn't happen. This could be a problem in the number of lines
configured, or some polarity settings between the CCP2 receiver and the
CCDC. I suspect the latter, but I could be totally wrong here as well since
it was more than five years I worked on these things. :-I

> [ 2793.901550] omap3isp 480bc000.isp: Unable to stop OMAP3 ISP CCDC

And this is probably directly caused by the same problem. :-(

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
