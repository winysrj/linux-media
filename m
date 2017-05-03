Return-path: <linux-media-owner@vger.kernel.org>
Received: from bubo.tul.cz ([147.230.16.1]:53432 "EHLO bubo.tul.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751528AbdECFiP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 3 May 2017 01:38:15 -0400
Subject: Re: [PATCH 2/4] [media] pxa_camera: Fix incorrect test in the image
 size generation
To: Robert Jarzmik <robert.jarzmik@free.fr>,
        Hans Verkuil <hverkuil@xs4all.nl>
References: <cover.1493612057.git.petr.cvek@tul.cz>
 <1e599794-36e7-3b26-8bb0-57c5b31d3956@tul.cz> <871ss71fq3.fsf@belgarion.home>
Cc: linux-media@vger.kernel.org
From: Petr Cvek <petr.cvek@tul.cz>
Message-ID: <c9217d55-1344-9c95-cecc-195f0c0012fe@tul.cz>
Date: Wed, 3 May 2017 07:39:26 +0200
MIME-Version: 1.0
In-Reply-To: <871ss71fq3.fsf@belgarion.home>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dne 2.5.2017 v 16:43 Robert Jarzmik napsal(a):
> Petr Cvek <petr.cvek@tul.cz> writes:
> 
>> During the transfer from the soc_camera a test in pxa_mbus_image_size()
>> got removed. Without it any PXA_MBUS_LAYOUT_PACKED format causes either
>> the return of a wrong value (PXA_MBUS_PACKING_2X8_PADHI doubles
>> the correct value) or EINVAL (PXA_MBUS_PACKING_NONE and
>> PXA_MBUS_PACKING_EXTEND16). This was observed in an error from the ffmpeg
>> (for some of the YUYV subvariants).
>>
>> This patch re-adds the same test as in soc_camera version.
>>
>> Signed-off-by: Petr Cvek <petr.cvek@tul.cz>
> Did you test that with YUV422P format ?
> If yes, then you can have my ack.

pxa27x-camera pxa27x-camera.0: s_fmt_vid_cap(pix=320x240:50323234)

And mplayer to framebuffer "somewhat" works (it timeouts after some time but it does regardless on format, ffmpeg is fine).

Anyway the patch does not affect V4L2_PIX_FMT_YUV422P in any way as the .layout field is PXA_MBUS_LAYOUT_PLANAR_2Y_U_V and test is only for "== PXA_MBUS_LAYOUT_PACKED"

> 
> And you should add Hans to the reviewers list, it's his call ultimately, and his
> tree which should carry it on.
> 
> Cheers.
> 
> --
> Robert
> 

Petr
