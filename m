Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:41703 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818Ab3BISws (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 13:52:48 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Alexander Nestorov <alexandernst@gmail.com>,
	Juergen Beisert <jbe@pengutronix.de>,
	oselas@community.pengutronix.de,
	linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
	Andrey Gusakov <dron0gus@gmail.com>,
	Kukjin Kim <kgene.kim@samsung.com>,
	LMML <linux-media@vger.kernel.org>
Subject: Re: [oselas] Audio support on Mini6410 board
Date: Sat, 09 Feb 2013 19:52:43 +0100
Message-ID: <9072709.Au7dcGPusH@flatron>
In-Reply-To: <511693AC.5010604@gmail.com>
References: <CACuz9s2w28eVG8qS9FXkUYAggXn7y2deHi2fPGizcURu_Bp4wg@mail.gmail.com> <CACuz9s0kscbt5Z87mOX6C=9vKg2wrU-T69RS6NQmeSRqP_8K4w@mail.gmail.com> <511693AC.5010604@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Saturday 09 of February 2013 19:21:32 Sylwester Nawrocki wrote:
> Hi,
> 
> On 01/20/2013 09:46 PM, Alexander Nestorov wrote:
> > I have been playing for a week with the board. Both audio and video
> > work correctly, but I haven't
> > been able to set the mic settings in alsamixer (so I can't test the
> > mic). The touchscreen isn't working, so I'll try to make it working
> > and send you some patches.
> > 
> > Anyways, now there's another question/problem that I have. Video
> > playback is really slow because
> > I'm not using the device's cpu-decoder but rather doing everything in
> > software mode.
> > 
> > Is there support for hardware acceleration in the kernel for this
> > device? Also, after talking with
> 
> No, there is still no video codec (MFC) driver for s3c6410 upstream.
> Now, when there is support for the hardware video codec available in
> newer SoC (Exynos4/5) and some V4L2 infrastructure added together with
> the s5p-mfc driver, it should be much easier to write a driver for the
> s3c64xx MFC. Still it is relatively huge task and I didn't see any
> volunteers willing to add support upstream for the s3c64xx MFC, except
> Andrey who replied in this thread. I could provide some help, but
> I will likely won't find time to do any development work or testing.
> 
> Also please note there is no support for the mem-to-mem features (color
> space conversion, scaling, rotation/flip) in the s3c-camif driver.
> It should be relatively simple to add it though. I'm not really sure
> if it is needed to run the codec on s3c64xx, but the plugin [1] uses
> FIMC (CAMIF) as a video post-processor. This plugin sets up processing
> pipeline like:
> 
> memory (compressed data) -> MFC -> (YCbCr tiled) memory -> FIMC ->
> memory (display)

AFAIK the MFC (like rest of the media processing peripherals) on S3C6410 
does not support tiled buffers. It uses the standard planar Y + Cb + Cr 
format.

In addition, the MFC of S3C6410 supports built-in rotation and mirroring 
of decoded video.

For scaling, there is a video post-processor block. There is no upstreamed 
driver for it, but the hardware is reasonably simple, so it wouldn't be 
too hard to write a driver for it. (I might be able to do it, although 
don't count on me, as I have also much other work to do, part of which is 
also related to S3C64xx).

Best regards,
Tomasz

> > some people from #gstreamer they pointed me to a component[1] in
> > gstreamer, but I'm not really
> > sure how to I use it. Any ideas/experience with that?
> 
> This component uses multi-planar V4L2 API [2], which also use the
> s5p-mfc and s5p-fimc driver. The s3c-camif driver uses the
> single-planar API at the camera capture video node. So if this existing
> plugin was to be used with the s3c64xx hardware, the drivers for it
> would have to support the multi-planar API, which I believe is not
> needed on s3c64xx hardware.
> The best is probably to make the drivers only single-plane API aware
> and adapt the plugin. The required changes at the plugin wouldn't be
> significant.
> 
> Anyway, a real problem here is lack of the s3c64xx MFC driver. So
> first we need the codec driver, which could be tested with modified
> test application [3], or directly with modified plugin [1].
> 
> > Regards!
> > 
> > [1] http://cgit.freedesktop.org/gstreamer/gst-plugins-bad/tree/sys/mfc
> 
> [2] http://linuxtv.org/downloads/v4l-dvb-apis/planar-apis.html
> [3]
> http://git.infradead.org/users/kmpark/public-apps/tree/9c057b001e8873861
> a70f7025214003837a0860b
> 
> --
> 
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-samsung-soc" in the body of a message to
> majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
