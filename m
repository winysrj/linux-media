Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:41837 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604Ab3JLKG2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Oct 2013 06:06:28 -0400
Message-ID: <52591F20.10506@gmail.com>
Date: Sat, 12 Oct 2013 12:06:24 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
CC: Tomasz Stanislawski <t.stanislaws@samsung.com>, t.figa@samsung.com,
	kyungmin.park@samsung.com, b.zolnierkie@samsung.com,
	s.nawrocki@samsung.com, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/4] media: s5p-tv: Restore vpll clock rate
References: <1379775649-6331-1-git-send-email-m.krawczuk@partner.samsung.com> <1379775649-6331-3-git-send-email-m.krawczuk@partner.samsung.com> <5243055C.7070205@samsung.com>
In-Reply-To: <5243055C.7070205@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/25/2013 05:46 PM, Tomasz Stanislawski wrote:
> Hi,
>
> As you can see sdo, hdmi and mixer are saparate drivers that are
> parts of s5p-tv drivers set. Could you rename commit name to
> 'media: s5p-tv: sdo: Restore vpll clock rate after streamoff'

Patch applied with the above commit summary line and checkpatch error
as below fixed. Please always run scripts/checkpatch.pl before submitting
patches.

$ scripts/checkpatch.pl v5-2-4-media-s5p-tv-Restore-vpll-clock-rate.patch
ERROR: trailing whitespace
#67: FILE: drivers/media/platform/s5p-tv/sdo_drv.c:220:
+^I$

total: 1 errors, 0 warnings, 50 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
       scripts/cleanfile

v5-2-4-media-s5p-tv-Restore-vpll-clock-rate.patch has style problems, 
please review.

If any of these errors are false positives, please report

--
Thanks,
Sylwester
