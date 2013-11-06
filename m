Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:39901 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab3KFOq0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:46:26 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MVU00BYPJOIMX10@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 06 Nov 2013 14:46:25 +0000 (GMT)
Message-id: <527A563A.8090805@samsung.com>
Date: Wed, 06 Nov 2013 15:46:18 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5] videobuf2: Add missing lock held on vb2_fop_relase
References: <1383726282-25668-1-git-send-email-ricardo.ribalda@gmail.com>
 <527A06C7.6070207@xs4all.nl>
In-reply-to: <527A06C7.6070207@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

(dropping some unrelated e-mail addresses from Cc)

On 06/11/13 10:07, Hans Verkuil wrote:
> On 11/06/13 09:24, Ricardo Ribalda Delgado wrote:
>> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>
>> vb2_fop_relase does not held the lock although it is modifying the
> 
> Small typo: _relase -> _release
> 
>> queue->owner field.
>>
[...]
>>
>> Signed-off-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>> ---
>>
>> v2: Comments by Sylvester Nawrocki
>>
>> fimc-capture and fimc-lite where calling vb2_fop_release with the lock held.
>> Therefore a new __vb2_fop_release function has been created to be used by
>> drivers that overload the release function.
>>
>> v3: Comments by Sylvester Nawrocki and Mauro Carvalho Chehab
>>
>> Use vb2_fop_release_locked instead of __vb2_fop_release
>>
>> v4: Comments by Sylvester Nawrocki
>>
>> Rename vb2_fop_release_locked to __vb2_fop_release and fix patch format
>>
>> v5: Comments by Sylvester Nawrocki and Hans Verkuil
>>
>> Rename __vb2_fop_release to vb2_fop_release_unlock and rearrange
>> arguments
> 
> I know I suggested the vb2_fop_release_unlock name, but on second thoughts
> that's not a good name. I suggest vb2_fop_release_no_lock instead.
> '_unlock' suggests that there is a _lock version as well, which isn't the
> case here.

Yes. Sorry, but to me vb2_fop_release_no_lock() looks s bit ugly.
Couldn't we just use double underscore prefix instead of _no_lock postfix,
as is commonly done in the kernel ?
Grep reveals almost no use of "_no_lock" in function names.

Thanks,
Sylwester
