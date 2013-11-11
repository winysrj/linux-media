Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:3130 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab3KKM3X (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Nov 2013 07:29:23 -0500
Message-ID: <5280CD93.2020800@xs4all.nl>
Date: Mon, 11 Nov 2013 13:29:07 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Pete Eberlein <pete@sensoray.com>
CC: linux-media <linux-media@vger.kernel.org>, viro@ZenIV.linux.org.uk,
	mchehab@redhat.com
Subject: Re: videobuf mmap deadlock
References: <5273F8F2.5070901@sensoray.com>
In-Reply-To: <5273F8F2.5070901@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Pete,

On 11/01/2013 07:54 PM, Pete Eberlein wrote:
> The patch "videobuf_vm_{open,close} race fixes" 
> https://linuxtv.org/patch/18365/ introduced a deadlock in 3.11.
> 
> My driver uses videobuf_vmalloc initialized with ext_lock set to NULL.

Which driver are we talking about?

> My driver's mmap function calls videobuf_mmap_mapper
> videobuf_mmap_mapper calls videobuf_queue_lock on q
> videobuf_mmap_mapper calls  __videobuf_mmap_mapper
>   __videobuf_mmap_mapper calls videobuf_vm_open
> videobuf_vm_open calls videobuf_queue_lock on q (introduced by above patch)
> deadlocked
> 
> This is not an issue if ext_lock is non-NULL, since videobuf_queue_lock 
> is a no-op in that case.
> 
> Did I do something wrong, or is this a valid regression?

I think this is a valid regression. Using an atomic_t for the count is a better
solution IMHO. Anyone up for writing a patch?

Locking in videobuf is very messy and I recommend moving to videobuf2 which is
much more reliable and much easier to understand as well.

Regards,

	Hans
