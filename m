Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7587 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab2AAUMw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Jan 2012 15:12:52 -0500
Message-ID: <4F00BE3F.5060107@redhat.com>
Date: Sun, 01 Jan 2012 18:12:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sylwester Nawrocki <snjw23@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCHv2 00/94] Only use DVBv5 internally on frontend drivers
References: <1325257711-12274-1-git-send-email-mchehab@redhat.com> <4EFDE8A6.5080903@gmail.com> <4EFDEA8E.4070603@redhat.com> <4F007A64.80807@gmail.com>
In-Reply-To: <4F007A64.80807@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01-01-2012 13:23, Sylwester Nawrocki wrote:
> On 12/30/2011 05:45 PM, Mauro Carvalho Chehab wrote:
>> On 30-12-2011 14:36, Sylwester Nawrocki wrote:
>>> Hi Mauro,
>>>
>>> On 12/30/2011 04:06 PM, Mauro Carvalho Chehab wrote:
>>>> This patch series comes after the previous series of 47 patches.
>>>> Basically, changes all DVB frontend drivers to work directly with
>>>> the DVBv5 structure. This warrants that all drivers will be
>>>
>>> Is there any git tree available with all these patches ? It would be easier
>>> to pull rather than applying almost 150 patches. :) I know I don't need
>>> them all, but just to be sure I have all the relevant changes in place for
>>> testing.
>>
>> Forgot to mention, and to update them on my tree. The latest version are at
>> the branch "DVB_v5_v5" on my experimental tree:
>> 	http://git.linuxtv.org/mchehab/experimental.git/shortlog/refs/heads/DVB_v5_v5
>>
>> (yeah, I know: the name become weird... It were "DVB_v5", meaning DVB API v5,
>>  then, for each rebase, I added a new branch there)
> 
> Just for the record, I've tested it with as102 driver (pctv74e usb stick) and
> MeTV and didn't notice any runtime problems.

Thank you for testing it, Sylvester!

I wrote yet another set of patches (this is a shorter one) meant to finish
the DVB cleanup. 

The new series addresses some issues inside dvb_frontend.c. It is at:

	git://linuxtv.org/mchehab/experimental.git DVBv5-v7

Thanks!
Mauro


