Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:42253 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932843AbcAKQTZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 11:19:25 -0500
Subject: Re: vivid - add support for YUV420
To: Ran Shalit <ranshalit@gmail.com>
References: <CAJ2oMhJVjKrfXEKx6xnGQkEpcSWBywabrDwy9biJkhjmnZ7Kbg@mail.gmail.com>
 <5693930C.9050001@xs4all.nl>
 <CAJ2oMhKH7LM2o0ppmJx5BK_3e3iT8sEixg2AMHN9ueBMjB9AKA@mail.gmail.com>
 <CAJ2oMhLP5F=6JBi9S4SsuZ=L1GecuV694md7mgqfKR2uEGTr2A@mail.gmail.com>
Cc: linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5693D606.1080801@xs4all.nl>
Date: Mon, 11 Jan 2016 17:19:18 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMhLP5F=6JBi9S4SsuZ=L1GecuV694md7mgqfKR2uEGTr2A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/11/2016 04:55 PM, Ran Shalit wrote:
> On Mon, Jan 11, 2016 at 1:58 PM, Ran Shalit <ranshalit@gmail.com> wrote:
>> On Mon, Jan 11, 2016 at 1:33 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
>>> On 01/09/2016 10:58 AM, Ran Shalit wrote:
>>>> Hello,
>>>>
>>>> I've been doing some tests with capturing video from virtual driver (vivid).
>>>> I've tried to force it to YUV420, but it ignores that, becuase it does
>>>> not support this format.
>>>
>>> Yes, it does. What kernel are you using? Something old? Support for 4:2:0 was
>>> added to vivid in March 2015.
>>>
>>>> I would please like to ask if there is some way I can output YUV420
>>>> format with vivi.
>>>
>>> Upgrade your kernel :-)
>>
>> Right.
>> The kernel in Cent0S 7.2 (last release) is 3.10.0.
>> I am not sure I can update CentOS with kernel.org last release because
>> of probably many dependencies ( Is it possible ?)
>> Anyway, vivid , is life saving tool for newcomers. Absolutely.
>>
>> Regards,
>> Ran
>>
> 
> 
> Hi,
> 
> Do you think it worth trying to upgrade vivid package only from 3.10
> (vivi) to 3.18 (vivid),
> or is it too complex to try and depend on many other files ?
> 
> Thanks,
> Ran
> 

A quick google gave me this:

http://linoxide.com/linux-how-to/upgrade-linux-kernel-stable-3-18-4-centos/

Most distros can be upgraded to newer kernels if you look around a bit.

Regards,

	Hans
