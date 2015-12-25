Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56042 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698AbbLYL24 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Dec 2015 06:28:56 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 25 Dec 2015 12:28:54 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ran Shalit <ranshalit@gmail.com>
Cc: linux-media@vger.kernel.org, linux-media-owner@vger.kernel.org
Subject: Re: dt3155 as a reference
In-Reply-To: <CAJ2oMh+7tAqD0PzRg=DPKi9BuiMmR_beyfG0EAh6m8AGaa9pmg@mail.gmail.com>
References: <CAJ2oMh+kZ+41eTOzLB9meaKs1sZUZtiUC0=x=Jx9bpWJZKpECA@mail.gmail.com>
 <20453e42cacaaa01c17a6a6fc5d4a3d0@xs4all.nl>
 <CAJ2oMh+7tAqD0PzRg=DPKi9BuiMmR_beyfG0EAh6m8AGaa9pmg@mail.gmail.com>
Message-ID: <d071e851b17fb516e411084be74ac658@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-12-24 21:52, Ran Shalit wrote:
> On Wed, Dec 23, 2015 at 3:09 PM, hverkuil <hverkuil@xs4all.nl> wrote:
>> On 2015-12-23 13:55, Ran Shalit wrote:
>>> 
>>> Hello,
>>> 
>>> I think to use dt3155 as a reference for new pci express driver ,
>>> becuase it is highly simple as a starting point, and contains only
>>> single file :)
>>> The driver I'll develop will eventually be used for multiple video
>>> capture and single video output.
>>> 
>>> I just wanted to ask if you recommend it as a starting point.
>> 
>> 
>> Yeah, that would work.
>> 
>> Regards,
>> 
>>     Hans
>> 
> 
> Hi,
> 
> Is there a chance anyone have the HW reference for dt3155 ?
> I can't  find it anywhere.

It's a saa7116-based device. Google for 'saa7116 datasheet' to download 
the datasheet.

Regards,

     Hans
