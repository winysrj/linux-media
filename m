Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr15.xs4all.nl ([194.109.24.35]:2873 "EHLO
	smtp-vbr15.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAOnv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 10:43:51 -0400
Message-ID: <533AD055.2040700@xs4all.nl>
Date: Tue, 01 Apr 2014 16:42:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans Verkuil <hansverk@cisco.com>
CC: Prabhakar Lad <prabhakar.csengg@gmail.com>,
	LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH] v4l2-compliance: fix function pointer prototype
References: <1396359906-6311-1-git-send-email-prabhakar.csengg@gmail.com> <533AC435.8040604@cisco.com> <CA+V-a8vcXgMW8EURZn25rfOrmyRMb4MNVbb5FuGn2J-pumSXGg@mail.gmail.com> <533ACC78.8000102@cisco.com>
In-Reply-To: <533ACC78.8000102@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/01/14 16:26, Hans Verkuil wrote:
> 
> 
> On 04/01/14 16:06, Prabhakar Lad wrote:
>> Hi Hans,
>>
>> On Tue, Apr 1, 2014 at 7:20 PM, Hans Verkuil <hansverk@cisco.com> wrote:
>>> Hi Prabhakar,
>>>
>>> On 04/01/14 15:45, Lad, Prabhakar wrote:
>>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>>
>>>> There was a conflict between the mmap function pointer prototype of
>>>> struct v4l_fd and the actual function used. Make sure it is in sync
>>>> with the prototype of v4l2_mmap.
>>>
>>> The prototype of v4l2_mmap uses int64_t, so I don't understand this
>>> patch.
>>>
>> Actual prototype of mmap is,
>>
>>   void *mmap(void *addr, size_t length, int prot, int flags, int fd,
>> off_t offset);
>>
>> But where as the prototype in v4l_fd mmap the last parameter type is int64_t
>> but that should have been off_t and same applies with test_mmap().
> 
> The problem is that v4l2_mmap (in lib/include/libv4l2.h) uses int64_t.
> So the function pointer uses int64_t as well as does test_mmap.
> 
> I don't see how the current v4l-utils tree can cause a compile error.
> 
> For the record, I know you can't assign mmap to fd->mmap, you would
> have to make a wrapper. Unfortunately mmap and v4l2_mmap do not have
> the same prototype and I had to pick one (I'm not sure why they don't
> use the same prototype).
> 
> Most applications would typically have to use v4l2_mmap, so I went with
> that one.
> 

I missed that mmap is assigned to v4l_fd_init(). Since mmap and v4l2_mmap
have different prototypes the only solution is to make a wrapper.

Does this work?

diff --git a/utils/v4l2-compliance/v4l-helpers.h b/utils/v4l2-compliance/v4l-helpers.h
index 48ea602..e718a24 100644
--- a/utils/v4l2-compliance/v4l-helpers.h
+++ b/utils/v4l2-compliance/v4l-helpers.h
@@ -14,11 +14,21 @@ struct v4l_fd {
 	int (*munmap)(void *addr, size_t length);
 };
 
+/*
+ * mmap has a different prototype compared to v4l2_mmap. Because of
+ * this we have to make a wrapper for it.
+ */
+static inline void *v4l_fd_mmap(void *addr, size_t length, int prot, int flags,
+		                      int fd, int64_t offset)
+{
+	return mmap(addr, length, prot, flags, fd, offset);
+}
+
 static inline void v4l_fd_init(struct v4l_fd *f, int fd)
 {
 	f->fd = fd;
 	f->ioctl = ioctl;
-	f->mmap = mmap;
+	f->mmap = v4l_fd_mmap;
 	f->munmap = munmap;
 }
 

On a 64-bit system the types are the same, it's only on a 32-bit system that
this will fail.

Regards,

	Hans
