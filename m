Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f182.google.com ([209.85.220.182]:50538 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbaDAOHX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 10:07:23 -0400
Received: by mail-vc0-f182.google.com with SMTP id ks9so9641532vcb.41
        for <linux-media@vger.kernel.org>; Tue, 01 Apr 2014 07:07:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533AC435.8040604@cisco.com>
References: <1396359906-6311-1-git-send-email-prabhakar.csengg@gmail.com> <533AC435.8040604@cisco.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Tue, 1 Apr 2014 19:36:52 +0530
Message-ID: <CA+V-a8vcXgMW8EURZn25rfOrmyRMb4MNVbb5FuGn2J-pumSXGg@mail.gmail.com>
Subject: Re: [PATCH] v4l2-compliance: fix function pointer prototype
To: Hans Verkuil <hansverk@cisco.com>
Cc: LMML <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Tue, Apr 1, 2014 at 7:20 PM, Hans Verkuil <hansverk@cisco.com> wrote:
> Hi Prabhakar,
>
> On 04/01/14 15:45, Lad, Prabhakar wrote:
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> There was a conflict between the mmap function pointer prototype of
>> struct v4l_fd and the actual function used. Make sure it is in sync
>> with the prototype of v4l2_mmap.
>
> The prototype of v4l2_mmap uses int64_t, so I don't understand this
> patch.
>
Actual prototype of mmap is,

  void *mmap(void *addr, size_t length, int prot, int flags, int fd,
off_t offset);

But where as the prototype in v4l_fd mmap the last parameter type is int64_t
but that should have been off_t and same applies with test_mmap().

Thanks,
--Prabhakar Lad
