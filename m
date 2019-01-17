Return-Path: <SRS0=I7H+=PZ=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487CCC43612
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 21:06:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1444B20855
	for <linux-media@archiver.kernel.org>; Thu, 17 Jan 2019 21:06:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AmzwLMeW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfAQVGk (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 17 Jan 2019 16:06:40 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:38655 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727347AbfAQVGj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 17 Jan 2019 16:06:39 -0500
Received: by mail-oi1-f195.google.com with SMTP id a77so7312375oii.5;
        Thu, 17 Jan 2019 13:06:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bgk/6Ps/xUTQpdibaLyXKx6/iY/tGquGS2LL5V8oQsU=;
        b=AmzwLMeWhsDvhnK7nbduEV1OZmIdoXRBms3nws26ocbwUvIK8wY7kAqwWp8DHmj7z5
         SBir8n6RcCV0wHA+yRzu7bePkbxUGx/x/q8+zooF5x8ZJdnF+kSilEGAgMw+8D6hJwgm
         XUxhKwHHiZkDdxFI1NK4qLVVCyiR+Jaxl8Wu47aqQX6rPB5WvbSXE7eDnyHfnJWG64hh
         DuGUWzHEW7QP/PyaUo1izix/LOeXxhrNKbbqJm0fjxXWQelXUXNC8pIE/K7S4BdF8Xcw
         SUk/dbfs5SFQrEDq2hSt6plSn9F+0nQWj2P3Moh1mU6tPG3cRmpL6rNAdvRjgnfqJx7s
         FxOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bgk/6Ps/xUTQpdibaLyXKx6/iY/tGquGS2LL5V8oQsU=;
        b=mPgVfcbSqpKivjm6Xk1kseNvTf4Ts/ljUE/oqSaFtLT9kCiOPKcyT0Bih9H2AxLKhx
         c49FRLorNy9GjlbVaLov+qbf8Lh2erdF+3wyqMnaBbM4xLeOZ8IkK9ZVc0rBXH76uceE
         Kdes2kSa0nYwy0TH/k14RQl3Eu+h5E9NZ0n9tTUaCBlfWkTLbHlFO/zeU9e64RGUvatf
         IGRXRhLvhJE1WCyH6jO8SYiuvsCaUmKH4YZXWOetQ22UZMywqPqGdofoeY8zYPa/Ai9D
         lFUSqYTjG+4HYXBh/2G5Qhl9YFEyh2Hf0mlMS9sffMu5X2C3ycfGblDK255kTVVVmiSf
         cGbQ==
X-Gm-Message-State: AJcUukfvS0hNWzu82Fmh/wmWEPcWL+IEBisxhb0+LvmvCYCln8IN8UbG
        f6oXu97h7h/7MO1o6MWa0Icgw54xpXzI+8/HTvM=
X-Google-Smtp-Source: ALg8bN6DAIJjbS8g3145YNSD07EWipH+sDQQROtX5Ayq+b5SOJR+dBhP9c8d20/L7XSMcybS4+YFD9q5ylvWqDmxqs4=
X-Received: by 2002:aca:ab53:: with SMTP id u80mr1745841oie.261.1547759198634;
 Thu, 17 Jan 2019 13:06:38 -0800 (PST)
MIME-Version: 1.0
References: <20190117205837.29003-1-slongerbeam@gmail.com>
In-Reply-To: <20190117205837.29003-1-slongerbeam@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 17 Jan 2019 19:06:28 -0200
Message-ID: <CAOMZO5BwAaEirMnuDbPLCw4D5Xb1krMW2WzUeBrAkqinzS_skA@mail.gmail.com>
Subject: Re: [PATCH v2] media: imx-csi: Input connections to CSI should be optional
To:     Steve Longerbeam <slongerbeam@gmail.com>
Cc:     linux-media <linux-media@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Steve,

On Thu, Jan 17, 2019 at 6:59 PM Steve Longerbeam <slongerbeam@gmail.com> wrote:
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
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
> Acked-by: Tim Harvey <tharvey@gateworks.com>
> Cc: stable@vger.kernel.org

Thanks. This fixes the following error messages:

[    3.449564] imx-ipuv3 2400000.ipu: driver could not parse
port@1/endpoint@0 (-22)
[    3.457342] imx-ipuv3-csi: probe of imx-ipuv3-csi.1 failed with error -22
[    3.464498] imx-ipuv3 2800000.ipu: driver could not parse
port@0/endpoint@0 (-22)
[    3.472120] imx-ipuv3-csi: probe of imx-ipuv3-csi.4 failed with error -22

Tested-by: Fabio Estevam <festevam@gmail.com>
