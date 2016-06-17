Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud3.xs4all.net ([194.109.24.22]:39441 "EHLO
	lb1-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754936AbcFQIGh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jun 2016 04:06:37 -0400
Subject: Re: [PATCHv16 10/13] cec: adv7842: add cec support
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
References: <1461937948-22936-1-git-send-email-hverkuil@xs4all.nl>
 <1461937948-22936-11-git-send-email-hverkuil@xs4all.nl>
 <20160616182228.1bd755d5@recife.lan>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-samsung-soc@vger.kernel.org, linux-input@vger.kernel.org,
	lars@opdenkamp.eu, linux@arm.linux.org.uk,
	Hans Verkuil <hans.verkuil@cisco.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <5763AF87.2030700@xs4all.nl>
Date: Fri, 17 Jun 2016 10:06:31 +0200
MIME-Version: 1.0
In-Reply-To: <20160616182228.1bd755d5@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2016 11:22 PM, Mauro Carvalho Chehab wrote:
> Em Fri, 29 Apr 2016 15:52:25 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Add CEC support to the adv7842 driver.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Won't review patches 10-13, as the same reviews I made for patch 9
> very likely applies.
> 
> As this series is causing non-staging drivers to be dependent of a
> staging driver, I'll wait for the next version that should be
> solving this issue.
> 
> For the new 9-13 patches, please be sure that checkpatch will be
> happy. For the staging stuff, the checkpatch issues can be solved
> later, as I'll re-check against checkpatch when it moves from staging
> to mainstream.

I have to make changes anyway so I'll make a new pull request later
today fixing all the comments and replacing unsigned with unsigned int
(which is a majority of all the checkpatch warnings).

Did I mention yet how much I hate this new checkpatch warning? In almost all
cases I agree with the checkpatch rules, but this one is just stupid IMHO.

Oh well, I'll make the change. Perhaps it will grow on me over time.

Regards,

	Hans
