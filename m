Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:59481 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751121AbcGOSMm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 14:12:42 -0400
Subject: Re: [PATCH v2 4/6] [media] vivid: code refactor for color
 representation
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1468599199-5902-5-git-send-email-ricardo.ribalda@gmail.com>
 <82287bcf-f71c-07fd-e616-fdca1865f677@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <967ccfea-0e06-5d86-3084-e5879ba73488@xs4all.nl>
Date: Fri, 15 Jul 2016 20:12:37 +0200
MIME-Version: 1.0
In-Reply-To: <82287bcf-f71c-07fd-e616-fdca1865f677@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/15/2016 07:58 PM, Hans Verkuil wrote:
> On 07/15/2016 06:13 PM, Ricardo Ribalda Delgado wrote:
>> Replace is_yuv with color_representation. Which can be used by HSV
>> formats.
>>
>> This change should ease the review of the following patches.
> 
> It's a bit of a mouthful. How about calling this color_enc and TPG_COLOR_ENC_?
> (i.e. color encoding).
> 
> I would also like to have a TPG_COLOR_ENC_LUMA for the greyscale formats.
> This patch is a good opportunity to add that.

Also note that docs-next is older than the master branch w.r.t. the tpg.
You're missing two is_yuv checks is docs-next that are present in the master.

Also:

>> +static const char *tpg_color_representation_str(enum tgp_color_representation
>> +						 color_representation)
>> +{
>> +	switch (color_representation) {
>> +

Drop empty line.

>> +	case TGP_COLOR_REPRESENTATION_YUV:
>> +		return "YCbCr";
>> +	case TGP_COLOR_REPRESENTATION_RGB:
>> +	default:
>> +		return "RGB";
>> +
>> +	}
>> +}

Regards,

	Hans
