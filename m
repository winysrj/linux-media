Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:58766 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754490AbbHNL6Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Aug 2015 07:58:25 -0400
Message-ID: <55CDD7BF.8070105@xs4all.nl>
Date: Fri, 14 Aug 2015 13:57:51 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Kamil Debski <kamil@wypas.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
CC: Zahari Doychev <zahari.doychev@linux.com>,
	linux-media@vger.kernel.org,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 2/2] [media] m2m: fix bad unlock balance
References: <cover.1436361987.git.zahari.doychev@linux.com> <ccf89324d232ddb3861bde57379d044bc587e5d5.1436361987.git.zahari.doychev@linux.com> <55B74514.6010601@xs4all.nl> <55CB3135.8080706@samsung.com> <CAP3TMiGi=JswcQV=WmjG-Ds0-pTdBgErPsq9SN=2L0ACdYfc_w@mail.gmail.com>
In-Reply-To: <CAP3TMiGi=JswcQV=WmjG-Ds0-pTdBgErPsq9SN=2L0ACdYfc_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/12/2015 05:50 PM, Kamil Debski wrote:
> Hi,
> 
> On 12 August 2015 at 13:42, Marek Szyprowski <m.szyprowski@samsung.com> wrote:
>> Hello Hans,
>>
>> I'm sorry for a delay. Once again I've been busy with some other internal
>> stuff.
>>
>> On 2015-07-28 11:02, Hans Verkuil wrote:
>>>
>>> Kamil, Marek,
>>>
>>> Why does v4l2_m2m_poll unlock and lock in that function?
>>
>>
>> I've checked the code and indeed the poll_wait() function doesn't do
>> anything that
>> should not be done with queue mutex being taken. I don't remember if it was
>> always
>> like that. You are right that the unlock&lock code should be removed.
>>
>>> Zahari is right that the locking is unbalanced, but I don't see the reason
>>> for the unlock/lock sequence in the first place. I'm wondering if that
>>> shouldn't just be removed.
>>>
>>> Am I missing something?
>>>
>>> Instead, I would expect to see a spin_lock_irqsave(&src/dst_q->done_lock,
>>> flags)
>>> around the list_empty(&src/dst_q->done_list) calls.
>>
>>
>> Indeed, that's another thing that should be fixed in this function. I looks
>> that
>> commit c16218402a000bb25c1277c43ae98c11bcb59bd1 ("[media] videobuf2: return
>> -EPIPE
>> from DQBUF after the last buffer") is the root cause of both issues
>> (unballanced
>> locking and lack of spinlock protection), while the unnecessary queue
>> unlock/lock
>> sequence was there from the beginning.
>>
> 
> I am all with Marek on this. Unlock/lock was there from the beginning,
> it is not necessary. I agree also that spin_lock/unlock should be
> added for the list_empty call.

Zahari, will you make a new version of this patch with the suggested changes?

Regards,

	Hans
