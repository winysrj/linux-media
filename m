Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp10.smtpout.orange.fr ([80.12.242.132]:40597 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbdEBO5k (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 2 May 2017 10:57:40 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Petr Cvek <petr.cvek@tul.cz>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Subject: Re: [RFC] [PATCH 0/4] [media] pxa_camera: Fixing bugs and missing colorformats
References: <19820fae-fae3-9579-8f37-5b515e0edb66@tul.cz>
        <34b6ce27-7567-a654-4276-ae522b44f781@tul.cz>
Date: Tue, 02 May 2017 16:57:38 +0200
In-Reply-To: <34b6ce27-7567-a654-4276-ae522b44f781@tul.cz> (Petr Cvek's
        message of "Mon, 1 May 2017 06:39:42 +0200")
Message-ID: <87o9vbz4pp.fsf@belgarion.home>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Petr Cvek <petr.cvek@tul.cz> writes:

> Dne 1.5.2017 v 06:20 Petr Cvek napsal(a):
>> This patchset is just a grouping of a few bugfixes I've found during
>> the ov9640 sensor support re-adding. 
>
> P.S. I've manually calculated every format variant for the image size
> calculation functions, but still these functions are not too robust (for every
> hypothetical bps/packing/layout combination). For example:
>
> MEDIA_BUS_FMT_Y8_1X8
> 	.name			= "Grey",
> 	.bits_per_sample	= 8,
> 	.packing		= PXA_MBUS_PACKING_NONE,
> 	.order			= PXA_MBUS_ORDER_LE,
> 	.layout			= PXA_MBUS_LAYOUT_PACKED,
>
> seems to me as a little bit misleading. The better solution would be to have something like bytes_per_line and image_size coefficients. Is my idea worth a try?
>
> Anyway the .order field seems to be unused (it is a pxa_camera defined structure). I'm for removing it (I can create a patch and test it on the real hardware). Unless there are plans for it.
>
> The pxa_camera_get_formats() could be probably simplified even up to the point
> of a removal of the soc_camera_format_xlate structure. If no one works on it (in
> like 2 months) I can try to simplify it.

Yes, simplifing get soc_camera_format_xlate struct would be great. And yeah,
nobody will be working on it in the next 2 monthes. Besides, Hans had expressed
interest in having it removed.

On my side, as long as the format translation happens, ie. pxa_camera provides a
list of formats which is a _superset_ of the sensor formats as today (especially
YUV422P, YUYV and its permutations, RGBxxxx), I'll be totally fine with it, even
if it was my idea several years ago to have a translation...

Let's see what new ideas can provide, new blood etc ...

Cheers.

-- 
Robert
