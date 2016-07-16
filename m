Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:46786 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751495AbcGPPTY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 11:19:24 -0400
Subject: Re: [PATCH v2 2/6] [media] Documentation: Add HSV format
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1468599199-5902-1-git-send-email-ricardo.ribalda@gmail.com>
 <1704928.3gI88ec2Bn@avalon> <f0f50faf-67f6-6614-4ae3-b0f23aa09953@xs4all.nl>
 <13000259.LGWzqn8rdl@avalon>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Antti Palosaari <crope@iki.fi>,
	Guennadi Liakhovetski <guennadi.liakhovetski@intel.com>,
	Helen Mae Koike Fornazier <helen.koike@collabora.co.uk>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <896b01f9-6df3-6ade-4cce-a19189faccfb@xs4all.nl>
Date: Sat, 16 Jul 2016 17:19:18 +0200
MIME-Version: 1.0
In-Reply-To: <13000259.LGWzqn8rdl@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/16/2016 04:12 PM, Laurent Pinchart wrote:
>> Limited vs full range quantization is handled by the quantization field.
>> It's there already.
> 
> Right. I wonder how we'll deal with that when someone will come up with more 
> than one limited range quantizations, have you thought about it ?

There is just limited and full range. Limited range is basically a left-over
from analog TV.

>> Limited range RGB is needed for HDMI due to a brain-dead spec when dealing
>> with certain kinds of TVs and configurations. Don't ask, it's horrible.
> 
> I'd still like to know about it for my personal information :-)

RGB video over HDMI is limited range for CE timings (i.e. 720p, 1080p, 4k)
unless signaled otherwise through the AVI InfoFrame. And you can only
signal that if the sink supports it in the EDID (and doesn't lie about it).

Typically TVs follow CE timings, so hooking up a PC to a TV may very well
cause problems (and often does).

Regards,

	Hans
