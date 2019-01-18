Return-Path: <SRS0=Cp5C=P2=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AFEC43387
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8551520823
	for <linux-media@archiver.kernel.org>; Fri, 18 Jan 2019 16:49:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l/9tdjUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727587AbfARQti (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Fri, 18 Jan 2019 11:49:38 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40634 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfARQti (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 18 Jan 2019 11:49:38 -0500
Received: by mail-ot1-f67.google.com with SMTP id s5so14934945oth.7;
        Fri, 18 Jan 2019 08:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2OQB5nKdnVndWylTWPtP/d0crrdw+TTevIx1jOhqFXY=;
        b=l/9tdjUTbb/o3yN0GBAQEFrKvCXUZUKJ74XxVknvceolW5sCCzxrIepB86yo+3fsCw
         n2bJrAqIPbe0L9dfS718Ve6JEt5GifSNHiQLCrSZ/MHUbMzaiXC7ZFGL7Ny4ZIpBKpqE
         4oXVXt/CHM1JEmYXsNQh6JC32GquQVAM8RPr7hSOu5TPB2CcUwYqBSe+tsMHpk93UBc+
         q15QbmwtXHK00XGJBJSreiThnJGKXKID/5crg4wS3YR7ez4iR/QFWXZASkUGcAJrj2T0
         gr4BVqF/6KrHeuo5IP3OQoR10+m3trgCm2VD1QfSvsjgUEPOtdqJLcbxJ9R82TNJBn3P
         I8BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2OQB5nKdnVndWylTWPtP/d0crrdw+TTevIx1jOhqFXY=;
        b=FUZM2YCZotjGLqRFEySeKN4sJmpVOEAR9HS80ugB4YKlKvqLo2mSMlFmW0TKDT/uah
         Newm/1cGMR3Z7T0G9Qrn9H6q5GM/ZGufj9+ok6gGdEJroQMtuqWbSgSDIvCg4cow9qjK
         GhPpY7cUiSQ//P+X295t/G66f92KbcNs8rYT5VYaG8OmoJrv44/PDEUgg3O7cRPR+jMH
         eakPkT9S0RlyIC1mAJWni2XvsIDNjJiMw+GPXJUpVN/DRmdeJa5aoijhufHcuxfewaO4
         G+2prZQlJ1ZASH3Zrbd3JLQZ7+Q8G7kQtHkkVkmLmxyZqDncEpZl/sjzeRMNjVQSNqVa
         PE1w==
X-Gm-Message-State: AJcUukdYFUGH5r1erkEeIPMsdDwl1nLarNx+QLJSu1A2/zpliZ473EgK
        7FVYrBI7ijbyLBGMI5d9QbrxyRtjPaCz/s23kkg=
X-Google-Smtp-Source: ALg8bN6f6UPQs68wMkNEbz/pQWY/sKziw79+ErpAIK3aAc7ACHDgbfRJRmjR6wW7OhRITNEw4oPCvi2CVyIW9XbTm8s=
X-Received: by 2002:a9d:5d2:: with SMTP id 76mr11932234otd.78.1547830177107;
 Fri, 18 Jan 2019 08:49:37 -0800 (PST)
MIME-Version: 1.0
References: <20181122151834.6194-1-rui.silva@linaro.org> <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl>
In-Reply-To: <757f8c52-7c23-7cf7-32ee-75ddba767ff8@xs4all.nl>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 18 Jan 2019 14:49:26 -0200
Message-ID: <CAOMZO5BCPAmcE=fU0fA9hgwZ89JMEtO5hOb15b7VwtD6i1LwSg@mail.gmail.com>
Subject: Re: [PATCH v9 00/13] media: staging/imx7: add i.MX7 media driver
To:     Hans Verkuil <hverkuil@xs4all.nl>,
        Rui Miguel Silva <rui.silva@linaro.org>
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Rui,

On Fri, Dec 7, 2018 at 10:44 AM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> I got a few checkpatch warnings about coding style:
>
> CHECK: Alignment should match open parenthesis
> #953: FILE: drivers/staging/media/imx/imx7-media-csi.c:911:
> +static struct v4l2_mbus_framefmt *imx7_csi_get_format(struct imx7_csi *csi,
> +                                       struct v4l2_subdev_pad_config *cfg,
>
> CHECK: Alignment should match open parenthesis
> #1341: FILE: drivers/staging/media/imx/imx7-media-csi.c:1299:
> +       ret = v4l2_async_register_fwnode_subdev(&csi->sd,
> +                                       sizeof(struct v4l2_async_subdev),
>
> CHECK: Lines should not end with a '('
> #684: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:669:
> +static struct csis_pix_format const *mipi_csis_try_format(
>
> CHECK: Alignment should match open parenthesis
> #708: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:693:
> +static struct v4l2_mbus_framefmt *mipi_csis_get_format(struct csi_state *state,
> +                                       struct v4l2_subdev_pad_config *cfg,
>
> CHECK: Alignment should match open parenthesis
> #936: FILE: drivers/staging/media/imx/imx7-mipi-csis.c:921:
> +       ret = v4l2_async_register_fwnode_subdev(mipi_sd,
> +                               sizeof(struct v4l2_async_subdev), &sink_port, 1,
>
> Apparently the latest coding style is that alignment is more important than
> line length, although I personally do not agree. But since you need to
> respin in any case due to the wrong SPDX identifier you used you might as
> well take this into account.
>
> I was really hoping I could merge this, but the SPDX license issue killed it.

Do you plan to submit a new version?

Thanks
