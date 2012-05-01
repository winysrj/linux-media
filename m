Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61388 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab2EARd5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 May 2012 13:33:57 -0400
Received: by bkcji2 with SMTP id ji2so1081059bkc.19
        for <linux-media@vger.kernel.org>; Tue, 01 May 2012 10:33:56 -0700 (PDT)
Message-ID: <4FA01E81.7000701@gmail.com>
Date: Tue, 01 May 2012 19:33:53 +0200
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	sakari.ailus@iki.fi, g.liakhovetski@gmx.de, hdegoede@redhat.com,
	moinejf@free.fr, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH/RFC v3 04/14] V4L: Add camera wide dynamic range control
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com> <1335536611-4298-5-git-send-email-s.nawrocki@samsung.com> <201204301750.57488.hverkuil@xs4all.nl> <201204301754.07602.hverkuil@xs4all.nl>
In-Reply-To: <201204301754.07602.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/30/2012 05:54 PM, Hans Verkuil wrote:
> On Monday 30 April 2012 17:50:57 Hans Verkuil wrote:
>> On Friday 27 April 2012 16:23:21 Sylwester Nawrocki wrote:
>>> Add V4L2_CID_WIDE_DYNAMIC_RANGE camera class control for camera wide
>>> dynamic range (WDR, HDR) feature. This control has now only menu entries
>>> for enabling and disabling WDR. It can be extended when the wide dynamic
>>> range technique selection is needed.
> 
> Never mind, I get it. It's for future expansion.
> 
> That said, I find it dubious to make this an enum.
> 
> I would go with a boolean control and perhaps make a remark that it might 
> become an enum in the future if more options are needed.

Yes, my intention was to have something that would be easy to expand 
without ABI perturbations. I believe in future there may be more 
detailed control needed, than just WDR enable/disable. 

Thanks for the suggestion, I'll revert this back to a boolean type
and add proper note in the documentation.

--

Regards,
Sylwester
