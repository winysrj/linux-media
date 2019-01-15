Return-Path: <SRS0=Ztfs=PX=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9F0C43612
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72AE120645
	for <linux-media@archiver.kernel.org>; Tue, 15 Jan 2019 16:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gateworks-com.20150623.gappssmtp.com header.i=@gateworks-com.20150623.gappssmtp.com header.b="PH3HuJAP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732990AbfAOQm3 (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 15 Jan 2019 11:42:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36994 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732985AbfAOQm2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Jan 2019 11:42:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id s12so3738949wrt.4
        for <linux-media@vger.kernel.org>; Tue, 15 Jan 2019 08:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3fJX75J9GW9rKEmOmn/is1vgo4CtwedDgzrHmHX09I8=;
        b=PH3HuJAPK9Qm2GbjmDMtJUlJIKU36lUwpGkGX+xk9uOHjq8S28BlKj6hnOPHmhkEsa
         ZTGRUaLcpj+OuOCSDUNZ88N5ZZsoOurTLBmWPpYQB9u12Vm9h3SWQCPe3UjXUTDlhIdQ
         jjtJzvVhuzJlbfjq9opRmOVZCm+5OJUdHjC/AYjO1yL8mY7KVMXAH/j5h/+lmrXgnzDj
         jO/r2l2Vfq+zeaavR6ngZKclSj50DFwCQaGKfrxvwdlOSAPgXgAas87Z4c7oMWL5pXi+
         x93AvMstRqC9wzhPYnjm9guvQkaYRBdfinu7WGohedJyzGF2Ky6EdUufxxuF3ONqukHJ
         a9DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3fJX75J9GW9rKEmOmn/is1vgo4CtwedDgzrHmHX09I8=;
        b=jIVDFmjlA0BiOgCpRu4AMRB62d2+4EkleHq8aDBnvdLDg8AQxX5MRsGm3qi/eL3+jX
         ogIJsFozklvZ9HmWNGNxKdKHUvziZ+dWNEokRpIsAB+8B/ywH+GTfXzfdX+ezik9APl6
         Yn296svDntZolYCSSwd+Rt9JpLGDdlwps3ErVDTfMa8M5y9Ugv1oRgvZ+MwZ4+VxW1z7
         rwISp99Ligolb7F4RiD5Bx1zwk/WIFVhN6RGoHb3Po668tcMJuNKCvjbck0chVSRlBuS
         F6V+WW7swcN39XvUkH8FyGaYL+vItBET4tEzSk80x3f5jdJ/pJwAek2hbvQhAsjDSbYK
         M2Dg==
X-Gm-Message-State: AJcUukdD3ga0bsB98BkJjwn+GcTiEGeHI0bQMw9HE7iQdzn8CTzdvnrj
        F7ZBsGkwNJqeC7CcZcWrwMj8wiFbcjpSpNun/H4yDg==
X-Google-Smtp-Source: ALg8bN4lO0vQujOg5R5l76QCne3sXfTWGN5rDdvjHZUJnHcPLHrhZDwgGCoMFy1oQdRIERawaI9zHgTOeGwLMITMm8E=
X-Received: by 2002:adf:ef0d:: with SMTP id e13mr3837579wro.29.1547570545654;
 Tue, 15 Jan 2019 08:42:25 -0800 (PST)
MIME-Version: 1.0
References: <20190109183448.20923-1-slongerbeam@gmail.com>
In-Reply-To: <20190109183448.20923-1-slongerbeam@gmail.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Tue, 15 Jan 2019 08:42:14 -0800
Message-ID: <CAJ+vNU1dByOE8QM4Y0R0z9sSgvb6_73_xTyRiOZL4LXb9BgR3w@mail.gmail.com>
Subject: Re: [PATCH] media: imx-csi: Input connections to CSI should be optional
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, Jan 9, 2019 at 10:34 AM Steve Longerbeam <slongerbeam@gmail.com> wrote:
>
> Some imx platforms do not have fwnode connections to all CSI input
> ports, and should not be treated as an error. This includes the
> imx6q SabreAuto, which has no connections to ipu1_csi1 and ipu2_csi0.
> Return -ENOTCONN in imx_csi_parse_endpoint() so that v4l2-fwnode
> endpoint parsing will not treat an unconnected CSI input port as
> an error.
>
> Fixes: c893500a16baf ("media: imx: csi: Register a subdev notifier")
>
> Signed-off-by: Steve Longerbeam <slongerbeam@gmail.com>
> ---
>  drivers/staging/media/imx/imx-media-csi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/media/imx/imx-media-csi.c b/drivers/staging/media/imx/imx-media-csi.c
> index 4223f8d418ae..30b1717982ae 100644
> --- a/drivers/staging/media/imx/imx-media-csi.c
> +++ b/drivers/staging/media/imx/imx-media-csi.c
> @@ -1787,7 +1787,7 @@ static int imx_csi_parse_endpoint(struct device *dev,
>                                   struct v4l2_fwnode_endpoint *vep,
>                                   struct v4l2_async_subdev *asd)
>  {
> -       return fwnode_device_is_available(asd->match.fwnode) ? 0 : -EINVAL;
> +       return fwnode_device_is_available(asd->match.fwnode) ? 0 : -ENOTCONN;
>  }
>
>  static int imx_csi_async_register(struct csi_priv *priv)
> --
> 2.17.1
>

Steve,

Thanks, this fixes adv7180 the capture regression on the Gateworks
Ventana boards as well. This should go to stable to fix 4.20 so please
add a 'Cc: stable@vger.kernel.org' if you re-submit (else we can send
it to stable@vger.kernel.org later).

Acked-by: Tim Harvey <tharvey@gateworks.com>

Tim
