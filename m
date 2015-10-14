Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:46424 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750976AbbJNG4b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Oct 2015 02:56:31 -0400
Message-ID: <561DFC28.1030507@xs4all.nl>
Date: Wed, 14 Oct 2015 08:54:32 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	pawel@osciak.com
CC: inki.dae@samsung.com, sw0312.kim@samsung.com,
	nenggun.kim@samsung.com, sangbae90.lee@samsung.com,
	rany.kwon@samsung.com
Subject: Re: [RFC PATCH v6 0/4] Refactoring Videobuf2 for common use
References: <1444124269-1084-1-git-send-email-jh1009.sung@samsung.com> <561BABB9.4010804@xs4all.nl> <561CD063.6010400@samsung.com> <561CDFA2.7070206@xs4all.nl> <561DA431.9070708@samsung.com>
In-Reply-To: <561DA431.9070708@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/14/2015 02:39 AM, Junghak Sung wrote:
> 
> 
> On 10/13/2015 07:40 PM, Hans Verkuil wrote:
>> On 10/13/15 11:35, Junghak Sung wrote:
>>>
>>>
>>> On 10/12/2015 09:46 PM, Hans Verkuil wrote:
>>>> Hi Junghak,
>>>>
>>>> I've accepted this v6 series and made a pull request for Mauro.
>>>>
>>>
>>> Hi Hans & Mauro,
>>>
>>> First of all, thank you for your acceptance.
>>> But, I have received some build warning reports for this
>>> vb2-refactoring patch from kbuild robot. So, I'd like to fix them
>>> firstly with next patch (v7).
>>
>> If this was a missing const in fimc-lite, then I fixed that myself in
>> your patch. If it was for other things as well, then let me know.
> 
> There are two warnings reported from kbuild robot.
> One is related with missing const as you mentioned, and the other is
> format error on dprintk(). (refer to attached email)
> But, I think that format error does not need to be dealt with,
> because it was from original code.

Just make a small patch fixing this on top of v6 and post it as part of the
vb2_thread patch series.

> 
>>
>>> Furthermore, I have tried to find out the way to move things related
>>> with vb2_thread to vb2-core. And then.. finally I can come close to
>>> resolve that.
>>> Please, wait for patch v7 if you don't mind.
>>> I will/can send it by this weekend.
>>
>> OK. Please do this vb2_thread work as a patch on top of the existing series.
>> I would like to get what we have today merged asap (with warnings fixed) and
>> this vb2_thread work can always be added later.
>>
> 
> OK. If so, I will prepare the next patch(v7) including vb2_thread work 
> on v6.

Great!

Thanks,

	Hans

