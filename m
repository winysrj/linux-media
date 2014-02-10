Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:3155 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbaBJJAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Feb 2014 04:00:53 -0500
Message-ID: <52F89523.5030101@xs4all.nl>
Date: Mon, 10 Feb 2014 10:00:19 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: fimc-lite.c: compile warning indicates bug
References: <52CC01ED.8080002@xs4all.nl> <52CC124B.8060700@samsung.com>
In-Reply-To: <52CC124B.8060700@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/07/2014 03:42 PM, Sylwester Nawrocki wrote:
> Hi Hans,
> 
> On 07/01/14 14:32, Hans Verkuil wrote:
>> Hi Sylwester,
>>
>> I just did a quick build with the latest set of commits and I found this
>> warning:
>>
>> .../media-git/drivers/media/platform/exynos4-is/fimc-lite.c: In function 'fimc_lite_probe':
>> .../media-git/drivers/media/platform/exynos4-is/fimc-lite.c:1583:1: warning: label 'err_sd' defined but not used [-Wunused-label]
>>  err_sd:
>>  ^
>>
>> As far as I can tell err_sd should certainly be used to do proper cleanup.
>> Can you check the code and prepare a patch?
> 
> Yes, I also noticed it in the media daily builds. It's a rebase error,
> unfortunately the mainline driver is now far behind our internal code.
> I will prepare a patch to fix this as soon as possible.

This is now the only warning left. Did you post a patch and did I miss it?

Regards,

	Hans
