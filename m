Return-Path: <SRS0=Jwgu=RR=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A786EC43381
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 10:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 698652186A
	for <linux-media@archiver.kernel.org>; Thu, 14 Mar 2019 10:18:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MET8aMZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbfCNKR6 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 14 Mar 2019 06:17:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42409 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726736AbfCNKR5 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Mar 2019 06:17:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so1084326wrr.9;
        Thu, 14 Mar 2019 03:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=ycODFwQlLZjbetO+LWi5L4TBJGCo56tWZhs5w6WEz4Y=;
        b=MET8aMZea4G4KF2uOFJ9x8FJYvSksZmghJtHGzdzOuh/LycLfll/li6m23kQD/jzup
         onTV+KwbSfK9GUAUCdrUXJifHMW4/Dl7H4D8msEvBb9uee4xckU6fgMx7vKDY7xVrQXT
         Ihw7MG9jCUzd5aHIg2vy3LjKqss+MpkFGx09fjsaAb8Qqme+NQAQbRlD1ir5vfHG42df
         oq6HvsMlU4ize+/b6jC8JlixPqw+gMiPv/DF2cMVZOfUNMXvKTJtC7TElOCvK6JnWAYB
         Aa8CrUGV3g0DV/mxNOfhMiUuJnnEuCrYevGjN/aucuZMIkJnrwGkLjBXLmHGhkvasJB6
         wGkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=ycODFwQlLZjbetO+LWi5L4TBJGCo56tWZhs5w6WEz4Y=;
        b=SEly61b60R8/OgOUSQan76nQO6OWQ9uje0d8/YhYLfgSehBRElrOnH4Ybs+X3/X2mj
         2hSVI8X0gIXC+tEdzvRXP+BQzNhK8+CJ0t+33UWrfFhaEje0Buj1AtD/daTWc0fSXrtm
         UBffVIgTwZN4fczK0UmSgjvGs9HHYDnTTFfr8KJokrb1e0FP/Rr/Wvxslifo75H2ivIf
         ftp6vNlr2jiDRmByMkdp56/PJZoM6T3sLIE6ZknwARJbt6WLWAnCz6LYLpi4mwkYgj/W
         i5aRt4+4NwQNs2xwMbY0Jj6kti5gqavnwdQxVlGmNNaY86oeAsKH2ZP6FN5PSAoHeryb
         To8Q==
X-Gm-Message-State: APjAAAWCzLswNKNWkFgNJzWOxQf+kPeCZP1Td4ooqDkLCK31/QNpn0+Y
        Ek6t+QldKPDG5euXs8SFpOmQQCeTskkdHw==
X-Google-Smtp-Source: APXvYqz9dfnzXpD6DCVrnlCwrgbpOMjTjFSJFVbBI5R/NbTxXcDyFBJP2oGd/cvo4SrPRtkHfFsBGA==
X-Received: by 2002:adf:ebc3:: with SMTP id v3mr3740150wrn.35.1552558675377;
        Thu, 14 Mar 2019 03:17:55 -0700 (PDT)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id 6sm1821873wmf.6.2019.03.14.03.17.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 03:17:54 -0700 (PDT)
References: <20190313211748.534491-1-arnd@arndb.de>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: media: imx7-mipi-csis: fix debugfs compilation
In-reply-to: <20190313211748.534491-1-arnd@arndb.de>
Date:   Thu, 14 Mar 2019 10:17:51 +0000
Message-ID: <m3r2b9ep4g.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Arnd,
Thanks for the patch.
On Wed 13 Mar 2019 at 21:17, Arnd Bergmann wrote:
> When CONFIG_DEBUGFS is enabled, we get a warning about an
> incorrect section annotation that can lead to undefined
> behavior:
>
> WARNING: vmlinux.o(.text+0xd3c7c4): Section mismatch in 
> reference from the function mipi_csis_probe() to the function 
> .init.text:mipi_csis_debugfs_init()
> The function mipi_csis_probe() references
> the function __init mipi_csis_debugfs_init().
> This is often because mipi_csis_probe lacks a __init
> annotation or the annotation of mipi_csis_debugfs_init is wrong.
>
> The same function for an unknown reason has a different
> version for !CONFIG_DEBUGFS, which does not have this problem,
> but behaves the same way otherwise (it does nothing when debugfs
> is disabled).
> Consolidate the two versions, using the correct section from
> one version, and the implementation from the other.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Rui Miguel Silva <rmfrfs@gmail.com>

---
Cheers,
	Rui

> ---
>  drivers/staging/media/imx/imx7-mipi-csis.c | 16 
>  ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c 
> b/drivers/staging/media/imx/imx7-mipi-csis.c
> index 2ddcc42ab8ff..001ce369ec45 100644
> --- a/drivers/staging/media/imx/imx7-mipi-csis.c
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/debugfs.h>
>  #include <linux/delay.h>
>  #include <linux/errno.h>
>  #include <linux/interrupt.h>
> @@ -889,8 +890,6 @@ static int mipi_csis_subdev_init(struct 
> v4l2_subdev *mipi_sd,
>  	return ret;
>  }
>  
> -#ifdef CONFIG_DEBUG_FS
> -#include <linux/debugfs.h>
>  
>  static int mipi_csis_dump_regs_show(struct seq_file *m, void 
>  *private)
>  {
> @@ -900,7 +899,7 @@ static int mipi_csis_dump_regs_show(struct 
> seq_file *m, void *private)
>  }
>  DEFINE_SHOW_ATTRIBUTE(mipi_csis_dump_regs);
>  
> -static int __init_or_module mipi_csis_debugfs_init(struct 
> csi_state *state)
> +static int mipi_csis_debugfs_init(struct csi_state *state)
>  {
>  	struct dentry *d;
>  
> @@ -934,17 +933,6 @@ static void mipi_csis_debugfs_exit(struct 
> csi_state *state)
>  	debugfs_remove_recursive(state->debugfs_root);
>  }
>  
> -#else
> -static int mipi_csis_debugfs_init(struct csi_state *state 
> __maybe_unused)
> -{
> -	return 0;
> -}
> -
> -static void mipi_csis_debugfs_exit(struct csi_state *state 
> __maybe_unused)
> -{
> -}
> -#endif
> -
>  static int mipi_csis_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;

