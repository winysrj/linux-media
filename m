Return-Path: <SRS0=WMbR=RY=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58598C43381
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 12:17:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2132B218D8
	for <linux-media@archiver.kernel.org>; Thu, 21 Mar 2019 12:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553170662;
	bh=9X5MSwnllC6bIGJdyhDnLpBMdGsHTivJLSlqw7NZG3k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=XKoNJYwdy6fDy+rcfrUuy+VcznTvMW0XTxtL1f9zceDQ1UAifUoCTFDRg/9CYRgAd
	 e4424oulXbStqNXWa10v8gFQXDhkAlCn3/fAlIzNMBwawMyQfW3JbjLBC1tHOzmm/j
	 ySRoO35SU98fImOwKdxghcvdiONX7v71xmmtTG3k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfCUMRl (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:17:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:52380 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbfCUMRl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 21 Mar 2019 08:17:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=HUt2yYzlg2cWXTuxjYAtIUMoN501Y0PRGNgz60VX7Do=; b=OD+zufmIi7PksHuygirQjBwDjM
        pw1OMBmIv2kwFkHgc2uD7tY4Tq40e2FgTNWF++aPutsI548V4W1mmDUhWgucz/qAL5b/1ofp3SgSS
        ZGtwkuCRzsEwfA7l8G3VvGgM7WU/DhdJDNJ47O2B5kLYgolKzEdRXPlHxjFrYXZQ1kmSwE8jjPpf+
        KD/qC/+7bN7zVtd3aBAvmxafRi325tXjJcGol3oI6vv4Sjw5B+NoxviKm/E7m/vATmD1HveyovDlX
        qfg81wpXjlayI42CWGlouBgdXIyn8hnkJNysKNCgPZQfMnH4aHVSwHlRKSVtfEPxjz11J8oI3Vmk0
        +hVMpH3w==;
Received: from [179.95.24.146] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h6wdb-0002XX-S2; Thu, 21 Mar 2019 12:17:36 +0000
Date:   Thu, 21 Mar 2019 09:17:31 -0300
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 1/7] Input: document meanings of KEY_SCREEN and KEY_ZOOM
Message-ID: <20190321091731.7b34fc63@coco.lan>
In-Reply-To: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
References: <20190118233037.87318-1-dmitry.torokhov@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Em Fri, 18 Jan 2019 15:30:31 -0800
Dmitry Torokhov <dmitry.torokhov@gmail.com> escreveu:

> It is hard to say what KEY_SCREEN and KEY_ZOOM mean, but historically DVB
> folks have used them to indicate switch to full screen mode. Later, they
> converged on using KEY_ZOOM to switch into full screen mode and KEY)SCREEN
> to control aspect ratio (see Documentation/media/uapi/rc/rc-tables.rst).
> 
> Let's commit to these uses, and define:
> 
> - KEY_FULL_SCREEN (and make KEY_ZOOM its alias)
> - KEY_ASPECT_RATIO (and make KEY_SCREEN its alias)
> 
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Feel free to apply via your tree.

Acked-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

> ---
> 
> Please let me know how we want merge this. Some of patches can be applied
> independently and I tried marking them as such, but some require new key
> names from input.h
> 
>  include/uapi/linux/input-event-codes.h | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/input-event-codes.h b/include/uapi/linux/input-event-codes.h
> index ae366b87426a..bc5054e51bef 100644
> --- a/include/uapi/linux/input-event-codes.h
> +++ b/include/uapi/linux/input-event-codes.h
> @@ -439,10 +439,12 @@
>  #define KEY_TITLE		0x171
>  #define KEY_SUBTITLE		0x172
>  #define KEY_ANGLE		0x173
> -#define KEY_ZOOM		0x174
> +#define KEY_FULL_SCREEN		0x174	/* AC View Toggle */
> +#define KEY_ZOOM		KEY_FULL_SCREEN
>  #define KEY_MODE		0x175
>  #define KEY_KEYBOARD		0x176
> -#define KEY_SCREEN		0x177
> +#define KEY_ASPECT_RATIO	0x177	/* HUTRR37: Aspect */
> +#define KEY_SCREEN		KEY_ASPECT_RATIO
>  #define KEY_PC			0x178	/* Media Select Computer */
>  #define KEY_TV			0x179	/* Media Select TV */
>  #define KEY_TV2			0x17a	/* Media Select Cable */



Thanks,
Mauro
