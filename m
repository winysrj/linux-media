Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:60359 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751160AbdBMIsE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 13 Feb 2017 03:48:04 -0500
Subject: Re: [PATCH v2 1/4] [media] exynos-gsc: Use 576p instead 720p as a
 threshold for colorspaces
To: Russell King - ARM Linux <linux@armlinux.org.uk>,
        Thibault Saunier <thibault.saunier@osg.samsung.com>
References: <20170209200420.3046-1-thibault.saunier@osg.samsung.com>
 <20170209200420.3046-2-thibault.saunier@osg.samsung.com>
 <20170210193850.GN27312@n2100.armlinux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Inki Dae <inki.dae@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>,
        Andi Shyti <andi.shyti@samsung.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Kukjin Kim <kgene@kernel.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Nicolas Dufresne <nicolas.dufresne@collabora.com>,
        linux-samsung-soc@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <baf44c8e-2117-6252-bae0-54446059ecde@xs4all.nl>
Date: Mon, 13 Feb 2017 09:47:55 +0100
MIME-Version: 1.0
In-Reply-To: <20170210193850.GN27312@n2100.armlinux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/10/2017 08:38 PM, Russell King - ARM Linux wrote:
> On Thu, Feb 09, 2017 at 05:04:17PM -0300, Thibault Saunier wrote:
>> From: Javier Martinez Canillas <javier@osg.samsung.com>
>>
>> The media documentation says that the V4L2_COLORSPACE_SMPTE170M colorspace
>> should be used for SDTV and V4L2_COLORSPACE_REC709 for HDTV. But drivers
>> don't agree on the display resolution that should be used as a threshold.
>>
>> Some drivers set V4L2_COLORSPACE_REC709 for 720p and higher while others
>> set V4L2_COLORSPACE_REC709 for anything higher than 576p. Newers drivers
>> use the latter and that also matches what user-space multimedia programs
>> do (i.e: GStreamer), so change the driver logic to be aligned with this.
>>
>> Also, check for the resolution in G_FMT instead unconditionally setting
>> the V4L2_COLORSPACE_REC709 colorspace.
> 
> It would be nice to refer to some specification to justify the change,
> rather than "let's follow what <random-piece-of-software> does".
> 
> EIA CEA 861B talks about colorimetry for various resolutions:
> 
> 5.1 480p, 480i, 576p, 576i, 240p, and 288p
> The color space used by the 480-line, 576-line, 240-line, and 288-line
> formats will likely be based on SMPTE 170M [1].
> 
> 5.2 1080i, 1080p, and 720p
> The color space used by the high definition formats will likely be based
> on ITU-R BT.709-4 [6].
> 
> Notice, however, that it says "will likely be" - it's not a requirement,
> as it's expected that the colorspace will be part of the media metadata
> (eg, contained in the transport stream.)  In other words, it should be
> configurable or ultimately provided by the ultimate source of the image.

Colorspace information is transmitted as part of HDMI/DisplayPort meta-information
(AVI InfoFrames, see CEA/CTA 861).

Compressed video typically encodes the colorspace information as well.

SDTV never had metainformation and you should fall back to SMPTE170M.

Webcams/sensors should give sRGB unless otherwise indicated. If it is a sensor
that expects further processing, then COLORSPACE_RAW can be used.

Anything else is typically sRGB.

Note that sRGB and SMPTE170M can be considered fall-back colorspaces in the
absence of any other information.

Regards,

	Hans
