Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:48318 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751197AbdIOXqu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Sep 2017 19:46:50 -0400
Received: by mail-oi0-f47.google.com with SMTP id v66so322684oig.5
        for <linux-media@vger.kernel.org>; Fri, 15 Sep 2017 16:46:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <421dbf8f-6574-7d3b-8842-ffe4c0c6da78@gmail.com>
References: <CAJ+vNU3DPFEc6YnEfcYAv1=beJ96W5PSt=eBfoxCXqKnbNqfMg@mail.gmail.com>
 <67ab090e-955d-9399-e182-cca049a66f1a@gmail.com> <CAJ+vNU3srz1u4x2wku4JKAOWGH8Gc8Wh0eo5aTEhACqoNeE1ow@mail.gmail.com>
 <421dbf8f-6574-7d3b-8842-ffe4c0c6da78@gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Fri, 15 Sep 2017 20:46:49 -0300
Message-ID: <CAOMZO5CJ3=Yd=-=Bvj9pwW62D7eCDAf-uXe6Ri_X_yM+VYfBYw@mail.gmail.com>
Subject: Re: IMX6 ADV7180 no /dev/media
To: Steve Longerbeam <slongerbeam@gmail.com>
Cc: Tim Harvey <tharvey@gateworks.com>,
        linux-media <linux-media@vger.kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Stephan Bauroth <der_steffi@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Steve,

On Fri, Sep 15, 2017 at 8:39 PM, Steve Longerbeam <slongerbeam@gmail.com> wrote:

> Agreed, but I notice now that CONFIG_MEDIA_CONTROLLER and
> CONFIG_VIDEO_V4L2_SUBDEV_API are not enabled there anymore.

I do see them enabled in mainline with imx_v6_v7_defconfig.

Tim,

Care to send the patch enabling CONFIG_VIDEO_MUX?

Thanks
