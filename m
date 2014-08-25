Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:2957 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaHYMuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Aug 2014 08:50:25 -0400
Message-ID: <53FB30E3.2050304@xs4all.nl>
Date: Mon, 25 Aug 2014 14:49:39 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com, m.chehab@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org
CC: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
References: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com> <1408969787-23132-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <53FB2E95.7040505@xs4all.nl>
In-Reply-To: <53FB2E95.7040505@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/25/2014 02:39 PM, Hans Verkuil wrote:
> On 08/25/2014 02:29 PM, Mikhail Ulyanov wrote:
>> This patch contains driver for Renesas R-Car JPEG codec.
>>
>> Cnanges since v1:
>>     - s/g_fmt function simplified
>>     - default format for queues added
>>     - dumb vidioc functions added to be in compliance with standard api:
>>         jpu_s_priority, jpu_g_priority
> 
> Oops, that's a bug elsewhere. Don't add these empty prio ops, this needs to be
> solved in the v4l2 core.
> 
> I'll post a patch for this.

After some thought I've decided to allow prio handling for m2m devices. It is
actually useful if some application wants exclusive access to the m2m hardware.

So I will change v4l2-compliance instead.

Regards,

	Hans
