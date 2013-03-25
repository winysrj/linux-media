Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f47.google.com ([74.125.83.47]:42318 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758708Ab3CYVuJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Mar 2013 17:50:09 -0400
Received: by mail-ee0-f47.google.com with SMTP id t10so466402eei.34
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2013 14:50:08 -0700 (PDT)
Message-ID: <5150C68D.80109@gmail.com>
Date: Mon, 25 Mar 2013 22:50:05 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Jarod Wilson <jwilson@redhat.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Ravi Kumar V <kumarrav@codeaurora.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	Antti Palosaari <crope@iki.fi>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Hans Verkuil <hansverk@cisco.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Re: Status of the patches under review at LMML (32 patches)
References: <20130324151111.1b2ca8d4@redhat.com>
In-Reply-To: <20130324151111.1b2ca8d4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/24/2013 07:11 PM, Mauro Carvalho Chehab wrote:
> This is the summary of the patches that are currently under review at
> Linux Media Mailing List<linux-media@vger.kernel.org>.
> Each patch is represented by its submission date, the subject (up to 70
> chars) and the patchwork link (if submitted via email).
>
> P.S.: This email is c/c to the developers where some action is expected.
>        If you were copied, please review the patches, acking/nacking or
>        submitting an update.
>
> It took me a lot of time to handle patches this time. The good news is that
> there's just one patch without an owner.
>
> This patch is there on the pile for a long time. I was actually expecting
> that either Jarod or David could review it, as it can affect existing
> NEC devices:
[...]
> 		== Sylwester Nawrocki <s.nawrocki@samsung.com>  ==
>
> Jan, 6 2013: s5p-tv: mixer: fix handling of VIDIOC_S_FMT
http://patchwork.linuxtv.org/patch/16143  Tomasz 
Stanislawski<t.stanislaws@samsung.com>

 From my side I can't see any applications this patch could cause issues to.
And it actually breaks some applications to not have this patch applied.
Hence we keep it applied internally. I will likely not be able to address
the issue at V4L2 API that some applications rely on drivers returning
-EINVAL on an attempt to set unsupported format. I don't have an idea what
to do with that at the moment :) I would say it is safe to apply this 
patch.
But if you have concerns please ignore it. Or let's leave it in current 
state.

Regards,
Sylwester
