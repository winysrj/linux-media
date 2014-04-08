Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:24502 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756199AbaDHKC1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Apr 2014 06:02:27 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3P005B3IK0BWA0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 08 Apr 2014 11:02:24 +0100 (BST)
Message-id: <5343C92D.2070508@samsung.com>
Date: Tue, 08 Apr 2014 12:02:21 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
MIME-version: 1.0
To: Denis Carikli <denis@eukrea.com>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
	Shawn Guo <shawn.guo@linaro.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Russell King <linux@arm.linux.org.uk>,
	linux-media@vger.kernel.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>
Subject: Re: [PATCH v12][ 07/12] drm: drm_display_mode: add signal polarity
 flags
References: <1396874691-27954-1-git-send-email-denis@eukrea.com>
 <1396874691-27954-7-git-send-email-denis@eukrea.com>
 <534398D5.4090600@samsung.com> <5343AE8A.50803@eukrea.com>
In-reply-to: <5343AE8A.50803@eukrea.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/2014 10:08 AM, Denis Carikli wrote:
> On 04/08/2014 08:36 AM, Andrzej Hajda wrote:
>>
>> Hi Denis,
> Hi,
> 
>>> +#define DRM_MODE_FLAG_POL_PIXDATA_NEGEDGE	BIT(1)
>>> +#define DRM_MODE_FLAG_POL_PIXDATA_POSEDGE	BIT(2)
>>> +#define DRM_MODE_FLAG_POL_PIXDATA_PRESERVE	BIT(3)
>>
>> What is the purpose of DRM_MODE_FLAG_POL_PIXDATA_PRESERVE?
>> If 'preserve' means 'ignore' we can set to zero negedge and posedge bits
>> instead of adding new bit. If it is something different please describe it.
> Yes, it meant 'ignore'.
> 
> The goal was to be able to have a way to keep the old behavior while 
> still being able to set the flags.
> 
> So, with the imx-drm driver, if none of the DRM_MODE_FLAG_POL_PIXDATA 
> were set(that is POSEDGE, NEGEDGE, PRESERVE), then in ipuv3-crtc.c, it 
> went using the old flags settings that were previously hardcoded.
> 
> The same applied for DRM_MODE_FLAG_POL_DE.
> The patch using theses flags is the 08/12 of this same serie.

So as I understand you want to:
- do not change hw polarity settings by using preserve bit,
- keep the old behavior of the driver by setting all bits to zero.

I think this is the issue of the specific driver, and it should not
influence core structs.

I am not familiar with imx but I guess it should not be a problem
to solve the issue in the driver.

> 
>>>   struct drm_display_mode {
> [..]
>>> +	unsigned int pol_flags;
>>
>> Adding field and macros description to the DocBook would be nice.
> So I will have to describe it in the "Connector Helper Operations" 
> section of drm.tmpl, right before the mode_valid synopsis ?

Yes, I think so.

Andrzej

> 
> Denis.
> 

