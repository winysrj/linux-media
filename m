Return-Path: <SRS0=+Qw+=RE=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E294C43381
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:07:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7A8E2084F
	for <linux-media@archiver.kernel.org>; Fri,  1 Mar 2019 16:07:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pGr/XMaH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388923AbfCAQHj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 1 Mar 2019 11:07:39 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42381 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727952AbfCAQHj (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2019 11:07:39 -0500
Received: by mail-wr1-f65.google.com with SMTP id r5so26429900wrg.9
        for <linux-media@vger.kernel.org>; Fri, 01 Mar 2019 08:07:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=6pGFBwvSuAW7TbPdViVFsz7s1Ui1Sf71K4ZcQ+PlUto=;
        b=pGr/XMaHIXCx6U2k7+GqiUuNYuFxJ+kuro9gY5WyyOZB7htJQrE2zpH38HhRadjHA2
         3zITT84Eob3H1EeM72sAOuPk3dtClOzTzyNLbVn+epI3belUi597tMj/oKuOUAVKuer8
         rEdVgg6q8hfs3imuzMl1hwd/KRVlG08JS0N1RSNeoKxJLQqQLG8XX9VIlQFY5Djl6AgJ
         oiXvi7muTiU5MHkrw8AL16hqMRFXUW0InS6jbhDSSLhqjIX9cwXvSaJsagwEOc6ZEEd/
         tiYPUOtyOcrNGM212thGDrhElxeYVE45piIApvShEkBcJHcyctEIHJNJsFM8f3u5kPWA
         JdNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=6pGFBwvSuAW7TbPdViVFsz7s1Ui1Sf71K4ZcQ+PlUto=;
        b=NEBatTX3ENDM/xIiVu2TCYDDutSWofifR/g/nJwh+bAh83NbUHkDTsuNDY8TNxWVJp
         6vnD4I9KX+xP86uc3MlgXl4IRRY/v6KNynwR9MhPSf575yyQPiJAbLftpgG+dnTNW5RP
         xpG0sND6uzFdM+XEWnWt8r1/yEKYhZlxe4KWJGwk35AKHLQXGO7pcKUyTLpAf8rgYuTU
         fvXb0tWkydk7tY07l2S+Ip6C/WiB9cWV/Yk1jSCuNSuhG/jNJHy7q2qYzUhbc2cOFZYP
         Um95+ICQY9fO09VABIvX6aHNJXOLSn268cLnHEriFEJtfpETuQCU2Re6YpVFP1gP0279
         mg6Q==
X-Gm-Message-State: APjAAAVjIRR5SamTWXQM8CzL4t8Quesqn5W3k6V3PsnBxjOyV4V2WwtV
        Xaa1QZIAukv9ZiDfT2mVsUjax/CTOXM=
X-Google-Smtp-Source: APXvYqyn1Z3K5z3yz4HxChmyO0osk5DzjVUFEIf60OQaciYsuZa4+jZWzQK0kSXr5plJ9tY/z40+Dg==
X-Received: by 2002:a5d:6107:: with SMTP id v7mr4159899wrt.78.1551456456697;
        Fri, 01 Mar 2019 08:07:36 -0800 (PST)
Received: from arch-late (a109-49-46-234.cpe.netcabo.pt. [109.49.46.234])
        by smtp.gmail.com with ESMTPSA id z17sm21411022wrs.75.2019.03.01.08.07.35
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 08:07:36 -0800 (PST)
References: <26b190053ec0db030697e2e19a8f8f13550b9ff7.1551452616.git.mchehab+samsung@kernel.org>
User-agent: mu4e 1.0; emacs 27.0.50
From:   Rui Miguel Silva <rmfrfs@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Andy Walls <awalls@md.metrocast.net>,
        Benoit Parrot <bparrot@ti.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Colin Ian King <colin.king@canonical.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] media: a few more typos at staging, pci, platform, radio and usb
In-reply-to: <26b190053ec0db030697e2e19a8f8f13550b9ff7.1551452616.git.mchehab+samsung@kernel.org>
Date:   Fri, 01 Mar 2019 16:07:34 +0000
Message-ID: <m3d0nay3w9.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Mauro,
On Fri 01 Mar 2019 at 15:03, Mauro Carvalho Chehab wrote:
> Those typos were left over from codespell check, on
> my first pass or belong to code added after the time I
> ran it.
>
> Signed-off-by: Mauro Carvalho Chehab 
> <mchehab+samsung@kernel.org>

For the imx7 part:
Acked-by: Rui Miguel Silva <rmfrfs@gmail.com>

Thanks.
---
Cheers,
	Rui


> ---
>  drivers/media/pci/cx18/cx18-dvb.c          | 2 +-
>  drivers/media/pci/saa7164/saa7164-dvb.c    | 2 +-
>  drivers/media/platform/ti-vpe/vpdma.c      | 2 +-
>  drivers/media/radio/wl128x/fmdrv_common.c  | 2 +-
>  drivers/media/usb/au0828/au0828-dvb.c      | 2 +-
>  drivers/staging/media/imx/imx7-mipi-csis.c | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/media/pci/cx18/cx18-dvb.c 
> b/drivers/media/pci/cx18/cx18-dvb.c
> index 51ecbe350d0e..61452c50a9c3 100644
> --- a/drivers/media/pci/cx18/cx18-dvb.c
> +++ b/drivers/media/pci/cx18/cx18-dvb.c
> @@ -458,7 +458,7 @@ void cx18_dvb_unregister(struct cx18_stream 
> *stream)
>  	dvb_unregister_adapter(dvb_adapter);
>  }
>  
> -/* All the DVB attach calls go here, this function get's 
> modified
> +/* All the DVB attach calls go here, this function gets 
> modified
>   * for each new card. cx18_dvb_start_feed() will also need 
>   changes.
>   */
>  static int dvb_register(struct cx18_stream *stream)
> diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c 
> b/drivers/media/pci/saa7164/saa7164-dvb.c
> index dfb118d7d1ec..3e73cb3c7e88 100644
> --- a/drivers/media/pci/saa7164/saa7164-dvb.c
> +++ b/drivers/media/pci/saa7164/saa7164-dvb.c
> @@ -529,7 +529,7 @@ int saa7164_dvb_unregister(struct 
> saa7164_port *port)
>  	return 0;
>  }
>  
> -/* All the DVB attach calls go here, this function get's 
> modified
> +/* All the DVB attach calls go here, this function gets 
> modified
>   * for each new card.
>   */
>  int saa7164_dvb_register(struct saa7164_port *port)
> diff --git a/drivers/media/platform/ti-vpe/vpdma.c 
> b/drivers/media/platform/ti-vpe/vpdma.c
> index 1da2cb3aaf0c..78d716c93649 100644
> --- a/drivers/media/platform/ti-vpe/vpdma.c
> +++ b/drivers/media/platform/ti-vpe/vpdma.c
> @@ -1008,7 +1008,7 @@ unsigned int vpdma_get_list_mask(struct 
> vpdma_data *vpdma, int irq_num)
>  }
>  EXPORT_SYMBOL(vpdma_get_list_mask);
>  
> -/* clear previously occurred list interupts in the LIST_STAT 
> register */
> +/* clear previously occurred list interrupts in the LIST_STAT 
> register */
>  void vpdma_clear_list_stat(struct vpdma_data *vpdma, int 
>  irq_num,
>  			   int list_num)
>  {
> diff --git a/drivers/media/radio/wl128x/fmdrv_common.c 
> b/drivers/media/radio/wl128x/fmdrv_common.c
> index e1c218b23d9e..3c8987af3772 100644
> --- a/drivers/media/radio/wl128x/fmdrv_common.c
> +++ b/drivers/media/radio/wl128x/fmdrv_common.c
> @@ -1047,7 +1047,7 @@ static void 
> fm_irq_handle_intmsk_cmd_resp(struct fmdev *fmdev)
>  		clear_bit(FM_INTTASK_RUNNING, &fmdev->flag);
>  }
>  
> -/* Returns availability of RDS data in internel buffer */
> +/* Returns availability of RDS data in internal buffer */
>  int fmc_is_rds_data_available(struct fmdev *fmdev, struct file 
>  *file,
>  				struct poll_table_struct *pts)
>  {
> diff --git a/drivers/media/usb/au0828/au0828-dvb.c 
> b/drivers/media/usb/au0828/au0828-dvb.c
> index d9093a3c57c5..6e43028112d1 100644
> --- a/drivers/media/usb/au0828/au0828-dvb.c
> +++ b/drivers/media/usb/au0828/au0828-dvb.c
> @@ -566,7 +566,7 @@ void au0828_dvb_unregister(struct au0828_dev 
> *dev)
>  	dvb->frontend = NULL;
>  }
>  
> -/* All the DVB attach calls go here, this function get's 
> modified
> +/* All the DVB attach calls go here, this function gets 
> modified
>   * for each new card. No other function in this file needs
>   * to change.
>   */
> diff --git a/drivers/staging/media/imx/imx7-mipi-csis.c 
> b/drivers/staging/media/imx/imx7-mipi-csis.c
> index 75b904d36621..2ddcc42ab8ff 100644
> --- a/drivers/staging/media/imx/imx7-mipi-csis.c
> +++ b/drivers/staging/media/imx/imx7-mipi-csis.c
> @@ -822,7 +822,7 @@ static int mipi_csis_parse_dt(struct 
> platform_device *pdev,
>  	if (IS_ERR(state->mrst))
>  		return PTR_ERR(state->mrst);
>  
> -	/* Get MIPI CSI-2 bus configration from the endpoint node. 
> */
> +	/* Get MIPI CSI-2 bus configuration from the endpoint 
> node. */
>  	of_property_read_u32(node, "fsl,csis-hs-settle", 
>  &state->hs_settle);
>  
>  	return 0;

