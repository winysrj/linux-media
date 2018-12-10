Return-Path: <SRS0=Hr0N=OT=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2816C65BAF
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 03:20:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87A3720831
	for <linux-media@archiver.kernel.org>; Mon, 10 Dec 2018 03:20:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ckyAsw7R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87A3720831
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbeLJDUZ (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Sun, 9 Dec 2018 22:20:25 -0500
Received: from mail-yb1-f195.google.com ([209.85.219.195]:34211 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbeLJDUZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 9 Dec 2018 22:20:25 -0500
Received: by mail-yb1-f195.google.com with SMTP id k136so1007896ybk.1
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 19:20:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UI6wO+eLFCBHOe4696NxtbdBKBil/NyvmFE0lXryLA4=;
        b=ckyAsw7R3uziZc/UVFJsD3LLkPxGi2+SflWuC2lkBLNxcJ1/sHBBWui9Q8qXw0G8Pn
         UA/aDbJjqkNWhdxEVOystMHs+XIg3yVbU1m0U3DGydkxSyVd/1rHtobU9Mk2IkNoSPgD
         GRXVegC+FCueRUxg3sxC7rZxIO9ZjNzUK61iQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UI6wO+eLFCBHOe4696NxtbdBKBil/NyvmFE0lXryLA4=;
        b=grZDcaMFx3nHGc00ekZGOQZp2VQB2oRkrN1lsao4rTIbXTHdmBUWfeMYJYKXwpwL3R
         Ce0B3KQfTV1CuQJCoTYWr0aCQ3B/T7t6BTu/oNIeW60CUF8rGMTDvJcKBTNhSKya7TQT
         CM0tM3WEHZtyCRgqxRMDhYFBr9yDVA6LKBG0t6/WX6jpE9lZZEEGlKHO5Aa/tLLRO6gG
         ALQAbFzWtJNyl+1maGC9eCliHYUO2uhAYrpVmZC1BH2JpApOdq+3JQf9KGSriTieHpQb
         aXCp5cwyz4PEP+P6KFqeK4lnyx40olzYtuMVvdDV7gul/akz2Q5OxseXhu/YChe0k/B/
         Z65Q==
X-Gm-Message-State: AA+aEWYOwYVGGUD+itzWAh93PLbR++Y2jbJPKyRraHHLnKe5iP1B3Jfv
        +x9Yr//xpuVKvyXlcF/O3HOW3lSoyYW7NA==
X-Google-Smtp-Source: AFSGD/Vb9NmGPchARIZgGOjFyC23pXh+qv7hqqa/pUfIpxrA+FAWUDiXyFeJQqA2g0ZchJYagFum8Q==
X-Received: by 2002:a25:86cc:: with SMTP id y12mr10638446ybm.92.1544412024247;
        Sun, 09 Dec 2018 19:20:24 -0800 (PST)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id j134sm4767676ywb.91.2018.12.09.19.20.23
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Dec 2018 19:20:23 -0800 (PST)
Received: by mail-yb1-f173.google.com with SMTP id f9so1128416ybm.13
        for <linux-media@vger.kernel.org>; Sun, 09 Dec 2018 19:20:23 -0800 (PST)
X-Received: by 2002:a25:9907:: with SMTP id z7mr834483ybn.114.1544412023187;
 Sun, 09 Dec 2018 19:20:23 -0800 (PST)
MIME-Version: 1.0
References: <20181206194639.13472-1-ezequiel@collabora.com>
In-Reply-To: <20181206194639.13472-1-ezequiel@collabora.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Mon, 10 Dec 2018 12:20:12 +0900
X-Gmail-Original-Message-ID: <CAAFQd5BA15tPoWNd=AKEnMXu8B9nYGEGxzh=XgZj50S3Uofy-Q@mail.gmail.com>
Message-ID: <CAAFQd5BA15tPoWNd=AKEnMXu8B9nYGEGxzh=XgZj50S3Uofy-Q@mail.gmail.com>
Subject: Re: [PATCH v3] v4l2-ioctl: Zero v4l2_plane_pix_format reserved fields
To:     Ezequiel Garcia <ezequiel@collabora.com>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, kernel@collabora.com,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Ezequiel,

On Fri, Dec 7, 2018 at 4:46 AM Ezequiel Garcia <ezequiel@collabora.com> wrote:
>
> Make the core set the reserved fields to zero in
> vv4l2_pix_format_mplane.4l2_plane_pix_format,
> for _MPLANE queue types.
>
> Moving this to the core avoids having to do so in each
> and every driver.
>
> Suggested-by: Tomasz Figa <tfiga@chromium.org>
> Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> --
> v3:
>   * s/int/unsigned int, suggested by Sakari
>
> v2:
>   * Drop unneeded clear in g_fmt.
>     The sturct was already being cleared here.
>   * Only zero plane_fmt reserved fields.
>   * Use CLEAR_FIELD_MACRO.
>
>  drivers/media/v4l2-core/v4l2-ioctl.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>

Thanks for the patch.

Reviewed-by: Tomasz Figa <tfiga@chromium.org>

Best regards,
Tomasz
