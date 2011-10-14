Return-path: <linux-media-owner@vger.kernel.org>
Received: from hermes.mlbassoc.com ([64.234.241.98]:39447 "EHLO
	mail.chez-thomas.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab1JNXX4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Oct 2011 19:23:56 -0400
Message-ID: <4E98C48A.6070009@mlbassoc.com>
Date: Fri, 14 Oct 2011 17:23:54 -0600
From: Gary Thomas <gary@mlbassoc.com>
MIME-Version: 1.0
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: OMAP3 ISP - interlaced data incorrect
References: <4E98C09B.2060800@mlbassoc.com>
In-Reply-To: <4E98C09B.2060800@mlbassoc.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2011-10-14 17:07, Gary Thomas wrote:
> For days, I've been chasing ghosts :-) I know they are still there,
> but I think they are more a function of the source than the ISP setup.
> So, I went looking for a better source, NTSC in my case. My choice is
> is a DVD player with known good video (I'm convinced that my cheap NTSC
> camera produces crap, especially when there is a lot of motion in the
> frames). Looking at this on an analogue TV (yes, they still exist!),
> the picture is not bad, so I think it's a good choice, at least when
> trying to understand what's happening with the OMAP3 ISP.
>
> Look at these two pictures:
> http://www.mlbassoc.com/misc/nemo-00001.png
> http://www.mlbassoc.com/misc/nemo-swapped-00001.png
>
> These represent one frame of data captured via my OMAP3 ISP + TVP5150
> from a DVD (sorry, Disney). The first is a raw conversion of the
> frame using ffmpeg. As you can see, there seem to be lines swapped,
> so I wrote a little program to swap the lines even/odd. The second
> (nemo-swapped) shows what this looks like. Obviously, the data is
> not being stored in memory correctly. Does anyone know how to adjust
> the ISP to make this work the right way around? Currently in ispccdc.c, we have:
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>
> I tried this:
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 2);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 0);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 2);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 0);
> but this lead to a kernel panic :-(
>
> Somehow, we need to be storing the data something like this:
> EE EE EE EE ...
> EO EO EO EO ...
> OE OE OE OE ...
> OO OO OO OO ...
> but the current layout is ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, EVENODD, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDEVEN, 1);
> ccdc_config_outlineoffset(ccdc, pix.bytesperline, ODDODD, 1);
>
> EO EO EO EO ...
> EE EE EE EE ...
> OO OO OO OO ...
> OE OE OE OE ...
>
> First, I need to get the data into memory in the correct order :-)
>
> Note: these results are consistent, i.e. if I stop things and do another
> grab, they are incorrect in the same [wrong] order.
>
> Note 2: I think I have explanations for much of the ghosting that has been
> observed:
> * Frame to frame "tearing" results from the fact that the frames are interlaced
> and the actual data changes from one half of the frame to the other. This would
> not be observed with traditional media, e.g. film, where nothing can move from
> one frame to the next because of the speed of shutters. In the purely digital
> capture case, every pixel has the opportunity to change constantly and to find
> some that change with the 33ms (NTSC) window (1 frame) is quite probable.

To be clear, moving from film to video, there would be no change of data
within a single frame between the two interleaved halves.  I'm sure this
was even true of old cameras, which were not digital capture devices being
used to send interleaved analogue data.

> You can see some of this in the [otherwise quite good] sequence of images
> http://www.mlbassoc.com/misc/nemo-swapped-00001.png
> ...
> http://www.mlbassoc.com/misc/nemo-swapped-00062.png
> * Frames being skipped &/or very stale data being reused - I think this is a [user]
> software problem. The ISP driver assumes that it always has an empty buffer to
> move captured data into. Depending on the [user] program which is consuming the
> data, this may or not be true. In the case of ffmpeg, if I capture raw images,
> ffmpeg can almost always keep up and there is always a free buffer. However, if
> I have ffmpeg turn the raw frames into compressed video (mp4), nearly 1/2 of
> the time, the ISP will run dry on buffers. I think I know how to fix this (untested)
> but it shows that some of the issues may be with the userland code we rely on.

In the case of ffmpeg capturing raw data, there were no times that the ISP driver
wanted a buffer and failed to get one, at least when storing the frames in a RAM
disk.  If stored to a physical device like MMC card, this might not be true.

However, when ffmpeg is used to create an MP4 image, even to RAM disk, nearly 1/2
of the time the ISP goes wanting, which certainly can't be good!

> I've not done any recent tests with the gstreamer modules and the TI DSP code,
> but I will shortly. We'll see how well that does.
>
> Note 3: The image viewer found at http://djv.sourceforge.net/ works great for these
> analyses. Just run 'djv_view' and point at the first image in a sequence :-)
> n.b. I'm not associated with that project, but I really like it!
>

-- 
------------------------------------------------------------
Gary Thomas                 |  Consulting for the
MLB Associates              |    Embedded world
------------------------------------------------------------
