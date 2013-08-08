Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:2186 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757819Ab3HHMul (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 08:50:41 -0400
Message-ID: <5203941A.6010909@xs4all.nl>
Date: Thu, 08 Aug 2013 14:50:34 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: =?UTF-8?B?QsOlcmQgRWlyaWsgV2ludGhlcg==?= <bwinther@cisco.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCHv2 0/9] qv4l2: scaling, pixel aspect ratio and render fixes
References: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
In-Reply-To: <1375965087-16318-1-git-send-email-bwinther@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2013 02:31 PM, Bård Eirik Winther wrote:
> The PATCHv2 only rebases for master pull.

That applies properly, thanks!

	Hans

> 
> This adds scaling and aspect ratio support to the qv4l2 CaptureWin.
> In that regard it fixes a lot of other issues that would otherwise make scaling
> render incorrectly. It also fixes some issues with the original OpenGL patch series,
> as well as adding tweaks and improvements left out in the original patches.
> 
> 
> Some of the changes/improvements:
> - CaptureWin have scaling support for video frames for all renderers
> - CaptureWin support pixel aspect ratio scaling
> - Aspect ratio and scaling can be changed during capture
> - Reset and disable scaling options
> - CaptureWin's setMinimumSize is now resize, which resizes the window to the frame size given
>   and minimum size is set automatically
> - The YUY2 shader programs are rewritten and has the resizing issue fixed
> - The Show Frames option in Capture menu can be toggled during capture
> - Added a hotkey:
>     CTRL + F : (size to video 'F'rame)
>                When either the main window or capture window is selected
>                this will reset the scaling to fit the frame size.
>                This option is also available in the Capture menu.
> 
> Pixel Aspect Ratio Modes:
> - Autodetect (if not supported this assumes square pixels)
> - Square
> - NTSC/PAL-M/PAL-60
> - NTSC/PAL-M/PAL-60, Anamorphic
> - PAL/SECAM
> - PAL/SECAM, Anamorphic
> 
> Perfomance:
>   All tests are done using the 3.10 kernel with OpenGL enabled and desktop effects disabled.
>   Testing was done on an Intel i7-2600S (with Turbo Boost disabled)
>   using the integrated Intel HD 2000 graphics processor. The mothreboard is an ASUS P8H77-I
>   with 2x2GB CL 9-9-9-24 DDR3 RAM. The capture card is a Cisco test card with 4 HDMI
>   inputs connected using PCIe2.0x8. All video input streams used for testing are
>   progressive HD (1920x1080) with 60fps.
> 
>   FPS for every input for a given number of streams
>   (BGR3, YU12 and YV12 are emulated using the CPU):
>         1 STREAM  2 STREAMS  3 STREAMS  4 STREAMS
>   RGB3      60        60         60         60
>   BGR3      60        60         60         58
>   YUYV      60        60         60         60
>   YU12      60        60         60         60
>   YV12      60        60         60         60
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

