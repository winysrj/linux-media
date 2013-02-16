Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59471 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037Ab3BPTXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 14:23:55 -0500
Message-ID: <511FDCBB.5010507@ti.com>
Date: Sun, 17 Feb 2013 00:53:39 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 06/18] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS
 by V4L2_OUT_CAP_DV_TIMINGS
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com> <1361006901-16103-1-git-send-email-hverkuil@xs4all.nl> <697f2939eac3755e4b5d74433d160d44672ab7ca.1361006882.git.hans.verkuil@cisco.com> <CA+V-a8tH8GLKz50i216S4TFkNjPpn1D1tNaRkuLfvDE_JO9N5g@mail.gmail.com>
In-Reply-To: <CA+V-a8tH8GLKz50i216S4TFkNjPpn1D1tNaRkuLfvDE_JO9N5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2/16/2013 6:28 PM, Prabhakar Lad wrote:
> Cc'ed Sekhar, DLOS, LAK.
> 
> Sekhar Can you Ack this patch ? Or maybe you can take this patch through
> your tree ?

I can take the patch, but I can only send for v3.10 since for v3.9 ARM
tree is only accepting bug fixes for already accepted code. If you wish
to take this through media tree for v3.9, feel free to add:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Since this appears to be an ARM-only patch, its better to add an 'ARM:'
prefix to the subject line as is the norm with all other ARM patches.

Thanks,
Sekhar
