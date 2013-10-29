Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:52966 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab3J2Akh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Oct 2013 20:40:37 -0400
Message-ID: <526F03FA.3080604@gtsys.com.hk>
Date: Tue, 29 Oct 2013 08:40:26 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: imx27.dtsi usbotg/usbh2 oops in fsl_usb2_mph_dr_of_probe
References: <526E55DA.3070007@gtsys.com.hk>	<CAOMZO5A6iMEzyRd81wogoO6NzDH3VqnaU9gH4-eh-SDQQMJ=Ww@mail.gmail.com>	<526E5BA0.2030300@gtsys.com.hk> <CAOMZO5AuFjMshe0QDz0VdaFdBMHw3_tqimmJjFa8KW3AtUmDFg@mail.gmail.com>
In-Reply-To: <CAOMZO5AuFjMshe0QDz0VdaFdBMHw3_tqimmJjFa8KW3AtUmDFg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, October 28, 2013 08:44 PM, Fabio Estevam wrote:
> On Mon, Oct 28, 2013 at 10:42 AM, Chris Ruehl<chris.ruehl@gtsys.com.hk>  wrote:
>
>> I didn't get USB detected with
>>
>> compatible ="fsl,imx27-usb"
>>
>> nothing happen.
>
> You probably need a mx27 entry into drivers/usb/chipidea/usbmisc_imx.c.
>
> Again, this is offtopic to this list, so please start a new thread at linux-usb,

going to sign up for the linux-usb! Thanks


-- 
GTSYS Limited RFID Technology
A01 24/F Gold King Industrial Bld
35-41 Tai Lin Pai Road, Kwai Chung, Hong Kong
Fax (852) 8167 4060 - Tel (852) 3598 9488

Disclaimer: http://www.gtsys.com.hk/email/classified.html
