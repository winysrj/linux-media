Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:51865 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3ADWjB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 17:39:01 -0500
Received: by mail-ee0-f54.google.com with SMTP id c13so8137286eek.27
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 14:39:00 -0800 (PST)
Message-ID: <50E75A01.8040409@gmail.com>
Date: Fri, 04 Jan 2013 23:38:57 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL FOR 3.8] vb2 and Exynos SoC driver fixes
References: <50E724DE.1020408@samsung.com>
In-Reply-To: <50E724DE.1020408@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/04/2013 07:52 PM, Sylwester Nawrocki wrote:
> Hi Mauro,
>
> Please pull for 3.8-rc. This includes the vb2 data_offset fix from
> Laurent, which looked fine after I reviewed it more carefully, and
> Exynos SoC/m5mols driver bug fixes.
>
> The following changes since commit d1c3ed669a2d452cacfb48c2d171a1f364dae2ed:
>
>    Linux 3.8-rc2 (2013-01-02 18:13:21 -0800)
>
> are available in the git repository at:
>
>    git://git.infradead.org/users/kmpark/linux-samsung v4l_fixes_for_v3.8
>
> for you to fetch changes up to 5e5b9c5179887e08a3ba4a94f08dc616c69ff49f:
>
>    s5p-mfc: Fix interrupt error handling routine (2013-01-04 11:32:45 +0100)
>
> ----------------------------------------------------------------
> Kamil Debski (1):
>        s5p-mfc: Fix interrupt error handling routine
>
> Laurent Pinchart (1):
>        v4l: vb2: Set data_offset to 0 for single-plane output buffers
>
> Sylwester Nawrocki (2):
>        m5mols: Fix typo in get_fmt callback
>        s5p-fimc: Fix return value of __fimc_md_create_flite_source_links()
>
>   drivers/media/i2c/m5mols/m5mols_core.c         |    2 +-
>   drivers/media/platform/s5p-fimc/fimc-mdevice.c |    2 +-
>   drivers/media/platform/s5p-mfc/s5p_mfc.c       |   88 ++++++++++--------------
>   drivers/media/v4l2-core/videobuf2-core.c       |    4 +-
>   4 files changed, 42 insertions(+), 54 deletions(-)

And here are the patchwork update commands I forgot to include
originally:

pwclient update -s 'accepted' 15968
pwclient update -s 'accepted' 15928
pwclient update -s 'accepted' 16079
pwclient update -s 'accepted' 16082

Sorry for the omission.
