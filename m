Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53868 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2IONlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Sep 2012 09:41:15 -0400
Received: by iahk25 with SMTP id k25so4243471iah.19
        for <linux-media@vger.kernel.org>; Sat, 15 Sep 2012 06:41:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1347554436.2429.609.camel@pizza.hi.pengutronix.de>
References: <1347554436.2429.609.camel@pizza.hi.pengutronix.de>
Date: Sat, 15 Sep 2012 10:41:14 -0300
Message-ID: <CALF0-+X5S-TXBX05HiB8X_GfgAY4gvmTO+-CDJNZMn_Bzxf5Sw@mail.gmail.com>
Subject: Re: [GIT PULL] Initial i.MX5/CODA7 support for the CODA driver
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Javier Martin <javier.martin@vista-silicon.com>,
	Richard Zhao <richard.zhao@freescale.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

On Thu, Sep 13, 2012 at 1:40 PM, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> Hi Mauro,
>
> please pull the following patches that fix a few issues in the coda driver and
> add initial firmware loading and encoding support for the CODA7 series VPU
> contained in i.MX51 and i.MX53 SoCs.
>
>
> The following changes since commit 79e8c7bebb467bbc3f2514d75bba669a3f354324:
>
>   Merge tag 'v3.6-rc3' into staging/for_v3.7 (2012-08-24 11:25:10 -0300)
>
> are available in the git repository at:
>
>
>   http://git.pengutronix.de/git/pza/linux.git coda/for_v3.7
>
> for you to fetch changes up to b50252c494ad56b88904811b1ac2d4fee1972446:
>
>   media: coda: set up buffers to be sized as negotiated with s_fmt (2012-09-13 17:14:36 +0200)
>
> ----------------------------------------------------------------
> Ezequiel Garcia (1):
>       coda: Remove unneeded struct vb2_queue clear on queue_init()
>
> Ezequiel García (1):
>       coda: Don't check vb2_queue_init() return value
>

This commit shouldn't be commited. See the recent discussion:
https://patchwork.kernel.org/patch/1372951/

Thanks,
Ezequiel.
