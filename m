Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:12520 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab3KFPWT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 10:22:19 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVU003W6LCG7810@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Nov 2013 15:22:17 +0000 (GMT)
Message-id: <527A5EA3.3090302@samsung.com>
Date: Wed, 06 Nov 2013 16:22:11 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5] videobuf2: Add missing lock held on vb2_fop_relase
References: <1383726282-25668-1-git-send-email-ricardo.ribalda@gmail.com>
 <527A06C7.6070207@xs4all.nl> <527A563A.8090805@samsung.com>
 <527A5754.70400@xs4all.nl>
In-reply-to: <527A5754.70400@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/11/13 15:51, Hans Verkuil wrote:
>>>> Rename __vb2_fop_release to vb2_fop_release_unlock and rearrange
>>>> >>> arguments
>>> >>
>>> >> I know I suggested the vb2_fop_release_unlock name, but on second thoughts
>>> >> that's not a good name. I suggest vb2_fop_release_no_lock instead.
>>> >> '_unlock' suggests that there is a _lock version as well, which isn't the
>>> >> case here.
>> > 
>> > Yes. Sorry, but to me vb2_fop_release_no_lock() looks s bit ugly.
>> > Couldn't we just use double underscore prefix instead of _no_lock postfix,
>> > as is commonly done in the kernel ?
> I'm not keen on that since we then end up with a no-prefix version, a '_'
> version and a '__' version. A bit obscure IMHO.
> 
> How about just exporting the _vb2_fop_release function and pass a NULL
> pointer as lock?

Sounds OK to me.

>> > Grep reveals almost no use of "_no_lock" in function names.
>
> Usually the version without prefix doesn't lock, and you have a _lock
> version that does lock. Unfortunately, we couldn't use that here.

Perhaps I'm misunderstanding something, but isn't it the opposite,
e.g. foo() which does lock, and __foo() that doesn't ?

So having a set of functions like:

/* locks */
int vb2_fop_release(struct file *file)

/* locks conditionally */
int _vb2_fop_release(struct file *file, struct mutex *lock)

/* doesn't lock */
int __vb2_fop_release(struct file *file)

would make sense ?

(I hope we end that thread soon :))

--
Regards,
Sylwester
