Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:33131 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751649AbdB0QnF (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Feb 2017 11:43:05 -0500
Date: Mon, 27 Feb 2017 10:43:03 -0600
From: Rob Herring <robh@kernel.org>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: hverkuil@xs4all.nl, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@armlinux.org.uk,
        krzk@kernel.org, javier@osg.samsung.com, hans.verkuil@cisco.com,
        dri-devel@lists.freedesktop.org, daniel.vetter@intel.com,
        m.szyprowski@samsung.com, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 2/3] stih-cec: add HPD notifier support
Message-ID: <20170227164303.mqhelwmn4vr5nl7a@rob-hp-laptop>
References: <1487328412-8305-1-git-send-email-benjamin.gaignard@linaro.org>
 <1487328412-8305-3-git-send-email-benjamin.gaignard@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1487328412-8305-3-git-send-email-benjamin.gaignard@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Feb 17, 2017 at 11:46:51AM +0100, Benjamin Gaignard wrote:
> By using the HPD notifier framework there is no longer any reason
> to manually set the physical address. This was the one blocking
> issue that prevented this driver from going out of staging, so do
> this move as well.
> 
> Update the bindings documentation the new hdmi phandle.

Should be a separate commit, but it's fine unless you do another spin.

> 
> Signed-off-by: Benjamin Gaignard <benjamin.gaignard@linaro.org>
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> CC: devicetree@vger.kernel.org
> 
> version 3:
> - change hdmi phandle from "st,hdmi-handle" to "hdmi-handle"
> ---
>  .../devicetree/bindings/media/stih-cec.txt         |   2 +

Acked-by: Rob Herring <robh@kernel.org>

>  drivers/media/platform/Kconfig                     |  10 +
>  drivers/media/platform/Makefile                    |   1 +
>  drivers/media/platform/sti/cec/Makefile            |   1 +
>  drivers/media/platform/sti/cec/stih-cec.c          | 404 +++++++++++++++++++++
>  drivers/staging/media/Kconfig                      |   2 -
>  drivers/staging/media/Makefile                     |   1 -
>  drivers/staging/media/st-cec/Kconfig               |   8 -
>  drivers/staging/media/st-cec/Makefile              |   1 -
>  drivers/staging/media/st-cec/TODO                  |   7 -
>  drivers/staging/media/st-cec/stih-cec.c            | 379 -------------------
>  11 files changed, 418 insertions(+), 398 deletions(-)
>  create mode 100644 drivers/media/platform/sti/cec/Makefile
>  create mode 100644 drivers/media/platform/sti/cec/stih-cec.c
>  delete mode 100644 drivers/staging/media/st-cec/Kconfig
>  delete mode 100644 drivers/staging/media/st-cec/Makefile
>  delete mode 100644 drivers/staging/media/st-cec/TODO
>  delete mode 100644 drivers/staging/media/st-cec/stih-cec.c
