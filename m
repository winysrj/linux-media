Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:61314 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3J1Moy (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 08:44:54 -0400
Received: by mail-vc0-f176.google.com with SMTP id ia6so2014856vcb.21
        for <linux-media@vger.kernel.org>; Mon, 28 Oct 2013 05:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <526E5BA0.2030300@gtsys.com.hk>
References: <526E55DA.3070007@gtsys.com.hk>
	<CAOMZO5A6iMEzyRd81wogoO6NzDH3VqnaU9gH4-eh-SDQQMJ=Ww@mail.gmail.com>
	<526E5BA0.2030300@gtsys.com.hk>
Date: Mon, 28 Oct 2013 10:44:54 -0200
Message-ID: <CAOMZO5AuFjMshe0QDz0VdaFdBMHw3_tqimmJjFa8KW3AtUmDFg@mail.gmail.com>
Subject: Re: imx27.dtsi usbotg/usbh2 oops in fsl_usb2_mph_dr_of_probe
From: Fabio Estevam <festevam@gmail.com>
To: Chris Ruehl <chris.ruehl@gtsys.com.hk>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 28, 2013 at 10:42 AM, Chris Ruehl <chris.ruehl@gtsys.com.hk> wrote:

> I didn't get USB detected with
>
> compatible ="fsl,imx27-usb"
>
> nothing happen.

You probably need a mx27 entry into drivers/usb/chipidea/usbmisc_imx.c.

Again, this is offtopic to this list, so please start a new thread at linux-usb,
