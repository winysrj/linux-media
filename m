Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:4130 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134Ab3KFOwD (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 Nov 2013 09:52:03 -0500
Message-ID: <527A5754.70400@xs4all.nl>
Date: Wed, 06 Nov 2013 15:51:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"open list:SAMSUNG S5P/EXYNO..." <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5] videobuf2: Add missing lock held on vb2_fop_relase
References: <1383726282-25668-1-git-send-email-ricardo.ribalda@gmail.com> <527A06C7.6070207@xs4all.nl> <527A563A.8090805@samsung.com>
In-Reply-To: <527A563A.8090805@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/06/13 15:46, Sylwester Nawrocki wrote:
> Hello,
> 
> (dropping some unrelated e-mail addresses from Cc)
> 
> On 06/11/13 10:07, Hans Verkuil wrote:
>> On 11/06/13 09:24, Ricardo Ribalda Delgado wrote:
>>> From: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>>
>>> vb2_fop_relase does not held the lock although it is modifying the
>>
>> Small typo: _relase -> _release
>>
>>> queue->owner field.
>>>
> [...]
>>>
>>> Signed-off-by: Ricardo Ribalda <ricardo.ribalda@gmail.com>
>>> ---
>>>
>>> v2: Comments by Sylvester Nawrocki
>>>
>>> fimc-capture and fimc-lite where calling vb2_fop_release with the lock held.
>>> Therefore a new __vb2_fop_release function has been created to be used by
>>> drivers that overload the release function.
>>>
>>> v3: Comments by Sylvester Nawrocki and Mauro Carvalho Chehab
>>>
>>> Use vb2_fop_release_locked instead of __vb2_fop_release
>>>
>>> v4: Comments by Sylvester Nawrocki
>>>
>>> Rename vb2_fop_release_locked to __vb2_fop_release and fix patch format
>>>
>>> v5: Comments by Sylvester Nawrocki and Hans Verkuil
>>>
>>> Rename __vb2_fop_release to vb2_fop_release_unlock and rearrange
>>> arguments
>>
>> I know I suggested the vb2_fop_release_unlock name, but on second thoughts
>> that's not a good name. I suggest vb2_fop_release_no_lock instead.
>> '_unlock' suggests that there is a _lock version as well, which isn't the
>> case here.
> 
> Yes. Sorry, but to me vb2_fop_release_no_lock() looks s bit ugly.
> Couldn't we just use double underscore prefix instead of _no_lock postfix,
> as is commonly done in the kernel ?

I'm not keen on that since we then end up with a no-prefix version, a '_'
version and a '__' version. A bit obscure IMHO.

How about just exporting the _vb2_fop_release function and pass a NULL
pointer as lock?

> Grep reveals almost no use of "_no_lock" in function names.

Usually the version without prefix doesn't lock, and you have a _lock
version that does lock. Unfortunately, we couldn't use that here.

Regards,

	Hans
