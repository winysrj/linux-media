Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:48745 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968086AbcA0U50 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jan 2016 15:57:26 -0500
Subject: Re: [PATCH for v4.5] vb2: fix nasty vb2_thread regression
To: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
References: <56A8B34A.7010606@xs4all.nl>
Cc: Junghak Sung <jh1009.sung@samsung.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <56A92F1C.9080005@gentoo.org>
Date: Wed, 27 Jan 2016 21:57:00 +0100
MIME-Version: 1.0
In-Reply-To: <56A8B34A.7010606@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 27.01.2016 um 13:08 schrieb Hans Verkuil:
> The vb2_thread implementation was made generic and was moved from
> videobuf2-v4l2.c to videobuf2-core.c in commit af3bac1a. Unfortunately
> that clearly was never tested since it broke read() causing NULL address
> references.
> 
> The root cause was confused handling of vb2_buffer vs v4l2_buffer (the pb
> pointer in various core functions).
> 
> The v4l2_buffer no longer exists after moving the code into the core and
> it is no longer needed. However, the vb2_thread code passed a pointer to
> a vb2_buffer to the core functions were a v4l2_buffer pointer was expected
> and vb2_thread expected that the vb2_buffer fields would be filled in
> correctly.
> 
> This is obviously wrong since v4l2_buffer != vb2_buffer. Note that the
> pb pointer is a void pointer, so no type-checking took place.
> 
> This patch fixes this problem:
> 
> 1) allow pb to be NULL for vb2_core_(d)qbuf. The vb2_thread code will use
>    a NULL pointer here since they don't care about v4l2_buffer anyway.
> 2) let vb2_core_dqbuf pass back the index of the received buffer. This is
>    all vb2_thread needs: this index is the index into the q->bufs array
>    and vb2_thread just gets the vb2_buffer from there.
> 3) the fileio->b pointer (that originally contained a v4l2_buffer) is
>    removed altogether since it is no longer needed.
> 
> Tested with vivid and the cobalt driver.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
> Reported-by: Matthias Schwarzott <zzam@gentoo.org>

Hi Hans!

Thank you for this patch.
I gave this patch a try on the latest sources from
git://linuxtv.org/media_tree.git

Compiled for kernel 4.2.8 with media_build.

Now it no longer oopses.
It tunes fine (according to femon), but I still do not get a
picture/dvbtraffic reports nothing.

Regards
Matthias

