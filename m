Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:47138 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbaIUSxi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 14:53:38 -0400
Received: by mail-we0-f172.google.com with SMTP id p10so1468189wes.17
        for <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 11:53:36 -0700 (PDT)
Message-ID: <541F1144.3050808@cogentembedded.com>
Date: Sun, 21 Sep 2014 21:56:20 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Mikhail Ulyanov <mikhail.ulyanov@cogentembedded.com>,
	horms@verge.net.au, magnus.damm@gmail.com, m.chehab@samsung.com,
	robh+dt@kernel.org, grant.likely@linaro.org
CC: laurent.pinchart@ideasonboard.com, hans.verkuil@cisco.com,
	linux-sh@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/6] V4L2: Add Renesas R-Car JPEG codec driver.
References: <1408452653-14067-2-git-send-email-mikhail.ulyanov@cogentembedded.com> <1408969787-23132-1-git-send-email-mikhail.ulyanov@cogentembedded.com> <53FB2E95.7040505@xs4all.nl> <53FB30E3.2050304@xs4all.nl>
In-Reply-To: <53FB30E3.2050304@xs4all.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 08/25/2014 04:49 PM, Hans Verkuil wrote:

>>> This patch contains driver for Renesas R-Car JPEG codec.

>>> Cnanges since v1:
>>>      - s/g_fmt function simplified
>>>      - default format for queues added
>>>      - dumb vidioc functions added to be in compliance with standard api:
>>>          jpu_s_priority, jpu_g_priority

>> Oops, that's a bug elsewhere. Don't add these empty prio ops, this needs to be
>> solved in the v4l2 core.

>> I'll post a patch for this.

> After some thought I've decided to allow prio handling for m2m devices. It is
> actually useful if some application wants exclusive access to the m2m hardware.

> So I will change v4l2-compliance instead.

    I take it we don't need to change the driver? Asking because the driver 
seems stuck for nearly a months now.
    I'm myself still seeing a place for improvement (register macro naming of 
the top of my head). Perhaps it's time to take this driver into my own hands...

> Regards,
> 	Hans

WBR, Sergei

