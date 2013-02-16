Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:4242 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3BPTeU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Feb 2013 14:34:20 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sekhar Nori <nsekhar@ti.com>
Subject: Re: [RFC PATCH 06/18] davinci: replace V4L2_OUT_CAP_CUSTOM_TIMINGS by V4L2_OUT_CAP_DV_TIMINGS
Date: Sat, 16 Feb 2013 20:33:53 +0100
Cc: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	linux-media@vger.kernel.org,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Scott Jiang <scott.jiang.linux@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	dlos <davinci-linux-open-source@linux.davincidsp.com>,
	LAK <linux-arm-kernel@lists.infradead.org>
References: <a9599acc7829c431d88b547de87c500968ccb86a.1361006882.git.hans.verkuil@cisco.com> <CA+V-a8tH8GLKz50i216S4TFkNjPpn1D1tNaRkuLfvDE_JO9N5g@mail.gmail.com> <511FDCBB.5010507@ti.com>
In-Reply-To: <511FDCBB.5010507@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302162033.53736.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat February 16 2013 20:23:39 Sekhar Nori wrote:
> On 2/16/2013 6:28 PM, Prabhakar Lad wrote:
> > Cc'ed Sekhar, DLOS, LAK.
> > 
> > Sekhar Can you Ack this patch ? Or maybe you can take this patch through
> > your tree ?
> 
> I can take the patch, but I can only send for v3.10 since for v3.9 ARM
> tree is only accepting bug fixes for already accepted code. If you wish
> to take this through media tree for v3.9, feel free to add:

There is no hurry. If you can take this patch for 3.10, then that is fine
by me. This patch series is unlikely to make it in 3.9 anyway, nor does it
need to. Just let me know if you take it, then I can drop it from my patch
series.

Regards,

	Hans

> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>
> 
> Since this appears to be an ARM-only patch, its better to add an 'ARM:'
> prefix to the subject line as is the norm with all other ARM patches.
> 
> Thanks,
> Sekhar
> 
