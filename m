Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:4386 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbaAGNcq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jan 2014 08:32:46 -0500
Message-ID: <52CC01ED.8080002@xs4all.nl>
Date: Tue, 07 Jan 2014 14:32:29 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: fimc-lite.c: compile warning indicates bug
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

I just did a quick build with the latest set of commits and I found this
warning:

.../media-git/drivers/media/platform/exynos4-is/fimc-lite.c: In function 'fimc_lite_probe':
.../media-git/drivers/media/platform/exynos4-is/fimc-lite.c:1583:1: warning: label 'err_sd' defined but not used [-Wunused-label]
 err_sd:
 ^

As far as I can tell err_sd should certainly be used to do proper cleanup.
Can you check the code and prepare a patch?

Thanks!

	Hans
