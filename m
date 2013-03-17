Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f52.google.com ([74.125.83.52]:52710 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755911Ab3CQLrI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Mar 2013 07:47:08 -0400
Received: by mail-ee0-f52.google.com with SMTP id b15so2058482eek.25
        for <linux-media@vger.kernel.org>; Sun, 17 Mar 2013 04:47:07 -0700 (PDT)
Message-ID: <5145AD38.3050206@gmail.com>
Date: Sun, 17 Mar 2013 12:47:04 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.9] Samsung media driver fixes
References: <513A4A6C.3090408@gmail.com>
In-Reply-To: <513A4A6C.3090408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/08/2013 09:30 PM, Sylwester Nawrocki wrote:
> Hi Mauro,
>
> The following changes since commit
> 9f225788cc047fb7c2ef2326eb4f86dee890e2ef:
>
> Merge branch 'merge' of
> git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2013-03-05
> 18:56:22 -0800)
>
> are available in the git repository at:
>
> git://linuxtv.org/snawrocki/samsung.git v3.9-fixes
>
> Andrzej Hajda (1):
> m5mols: Fix bug in stream on handler
>
> Arun Kumar K (2):
> s5p-mfc: Fix frame skip bug
> s5p-mfc: Fix encoder control 15 issue
>
> Shaik Ameer Basha (4):
> fimc-lite: Initialize 'step' field in fimc_lite_ctrl structure
> fimc-lite: Fix the variable type to avoid possible crash
> exynos-gsc: send valid m2m ctx to gsc_m2m_job_finish
> s5p-fimc: send valid m2m ctx to fimc_m2m_job_finish
>
> Sylwester Nawrocki (1):
> s5p-fimc: Do not attempt to disable not enabled media pipeline

I've found an issue in one of these patches thus I'm cancelling
this pull request. I'll send an updated version in a minute.

Nacked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>


