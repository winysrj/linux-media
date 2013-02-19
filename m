Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:43700 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab3BSKr7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Feb 2013 05:47:59 -0500
Message-ID: <5123584A.9060006@ti.com>
Date: Tue, 19 Feb 2013 16:17:38 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	<linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 06/18] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS
 by V4L2_OUT_CAP_DV_TIMINGS
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com> <CA+V-a8tH8GLKz50i216S4TFkNjPpn1D1tNaRkuLfvDE_JO9N5g@mail.gmail.com> <511FDCBB.5010507@ti.com> <201302162033.53736.hverkuil@xs4all.nl>
In-Reply-To: <201302162033.53736.hverkuil@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 2/17/2013 1:03 AM, Hans Verkuil wrote:
> On Sat February 16 2013 20:23:39 Sekhar Nori wrote:
>> On 2/16/2013 6:28 PM, Prabhakar Lad wrote:
>>> Cc'ed Sekhar, DLOS, LAK.
>>>
>>> Sekhar Can you Ack this patch ? Or maybe you can take this patch through
>>> your tree ?
>>
>> I can take the patch, but I can only send for v3.10 since for v3.9 ARM
>> tree is only accepting bug fixes for already accepted code. If you wish
>> to take this through media tree for v3.9, feel free to add:
> 
> There is no hurry. If you can take this patch for 3.10, then that is fine
> by me. This patch series is unlikely to make it in 3.9 anyway, nor does it
> need to. Just let me know if you take it, then I can drop it from my patch
> series.

It appears that it will be simpler if you manage the entire series. I
have already acked this one, so please take it through the media tree.

Thanks,
Sekhar
