Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:56666 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756072Ab3J1MZI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 08:25:08 -0400
Received: by mail-ve0-f170.google.com with SMTP id oy12so2817475veb.29
        for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 05:25:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E55DA.3070007@gtsys.com.hk>
References: <526E55DA.3070007@gtsys.com.hk>
Date: Mon, 28 Oct 2013 10:25:07 -0200
Message-ID: <CAOMZO5A6iMEzyRd81wogoO6NzDH3VqnaU9gH4-eh-SDQQMJ=Ww@mail.gmail.com>
Subject: Re: imx27.dtsi usbotg/usbh2 oops in fsl_usb2_mph_dr_of_probe
From: Fabio Estevam <festevam@gmail.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 28, 2013 at 10:17 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:
> Hi,
>
> when tried to activate the USB-OTG or USBH2 with the FDT the system oops

You should have posted this to the linux-usb list instead :-)


> config: (imx27.dtsi)
>
>             usbotg: usb@10024000 {
>                 compatible = "fsl-usb2-dr";

You should use compatible ="fsl,imx27-usb" so that it uses the
chipidea usb driver.
