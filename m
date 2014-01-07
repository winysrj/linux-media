Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:43360 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbaAGOmn (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 09:42:43 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MZ1007UPCV3EH80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 07 Jan 2014 14:42:39 +0000 (GMT)
Message-id: <52CC124B.8060700@samsung.com>
Date: Tue, 07 Jan 2014 15:42:19 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: fimc-lite.c: compile warning indicates bug
References: <52CC01ED.8080002@xs4all.nl>
In-reply-to: <52CC01ED.8080002@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 07/01/14 14:32, Hans Verkuil wrote:
> Hi Sylwester,
> 
> I just did a quick build with the latest set of commits and I found this
> warning:
> 
> .../media-git/drivers/media/platform/exynos4-is/fimc-lite.c: In function 'fimc_lite_probe':
> .../media-git/drivers/media/platform/exynos4-is/fimc-lite.c:1583:1: warning: label 'err_sd' defined but not used [-Wunused-label]
>  err_sd:
>  ^
> 
> As far as I can tell err_sd should certainly be used to do proper cleanup.
> Can you check the code and prepare a patch?

Yes, I also noticed it in the media daily builds. It's a rebase error,
unfortunately the mainline driver is now far behind our internal code.
I will prepare a patch to fix this as soon as possible.

Regards,
Sylwester
