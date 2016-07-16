Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:57913 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751685AbcGPQOn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 12:14:43 -0400
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1704928.3gI88ec2Bn@avalon> <f0f50faf-67f6-6614-4ae3-b0f23aa09953@xs4all.nl>
 <13000259.LGWzqn8rdl@avalon>
 <CAPybu_2N+gKU4=qRfxHhEurTvUqT0f8Pup55C8KKTT_jEwf2nw@mail.gmail.com>
 <94f0b9bc-542b-6e19-3ca1-332632c135f7@xs4all.nl>
 <CAPybu_3=j99ThtMGbecNRUjTTNOM1f=MoReGgYV05JsjbRauAg@mail.gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <61de90a6-812d-08d5-919c-669ff33cc836@xs4all.nl>
Date: Sat, 16 Jul 2016 18:14:37 +0200
MIME-Version: 1.0
In-Reply-To: <CAPybu_3=j99ThtMGbecNRUjTTNOM1f=MoReGgYV05JsjbRauAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 05:57 PM, Ricardo Ribalda Delgado wrote:
> Hi Hans
> 
> On Sat, Jul 16, 2016 at 5:28 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> 
>>
>>> +
>>> +enum v4l2_rgb_encoding {
>>> +       V4L2_RGB_ENC_FULL       = 32,
>>> +       V4L2_HSV_ENC_16_235     = 33,
>>> +};
>>
>> No.
> 
> I was trying to fit also Laurent special 16-235 RGB format. I will
> remove it on future versions.
> 
> 
> Can I make this change as 2 new patches on my vivid-hsv patchset?
> 
> 1) Add hsv_encoding
> 2) Add support for vivid hsv_encoding

Yes. I prefer them last in the series, since I am not quite 100% certain yet.

Regards,

	Hans
