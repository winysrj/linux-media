Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39290 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751619Ab3HVBIt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Aug 2013 21:08:49 -0400
In-Reply-To: <CALxrGmVfRj_Kc0C29w99pUw3K9c3X2SrO0RNG_G-xiJiSz52fw@mail.gmail.com>
References: <CALxrGmVAtz3x1aCUf5QArvp9J4ioXBObuhBdAL8J-p3yMeyppg@mail.gmail.com> <201308211347.08650.hverkuil@xs4all.nl> <CALxrGmVfRj_Kc0C29w99pUw3K9c3X2SrO0RNG_G-xiJiSz52fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: A false alarm for recursive lock in v4l2_ctrl_add_handler
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 21 Aug 2013 21:08:51 -0400
To: Su Jiaquan <jiaquan.lnx@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>, jqsu@marvell.com,
	tianxf@marvell.com, xzhao10@marvell.com
Message-ID: <e256b5f1-14b2-4ab9-bcf4-4eb3b1fab70e@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Su Jiaquan <jiaquan.lnx@gmail.com> wrote:
>Hi Hans,
>
>On Wed, Aug 21, 2013 at 7:47 PM, Hans Verkuil <hverkuil@xs4all.nl>
>wrote:
>> On Wed 21 August 2013 12:56:21 Su Jiaquan wrote:
>>> Hi Hans,
>>>
>>> Recently when we enable LOCKDEP in our kernel, it detected a
>"possible
>>> recursive locking". As we check the code, we found that it's just a
>>> false alarm, the conceived scenario should never happen. Shell I
>>> submit a patch to suppress it?
>>
>> A patch went in for 3.10 that suppresses this false alarm.
>>
>> Regards,
>>
>>         Hans
>>
>
>Sorry I didn't notice the fix, Is it this one?
>
>commit 6cd247ef22e493e1884e576c066661538b031981
>Author: Andy Walls <awalls@md.metrocast.net>
>Date:   Sat Mar 9 05:55:11 2013 -0300
>
>    [media] v4l2-ctrls: eliminate lockdep false alarms for struct
>v4l2_ctrl_handler.lock


Yes.

Regards,
Andy

>Thanks!
>
>Jiaquan



