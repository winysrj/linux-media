Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.fpasia.hk ([202.130.89.98]:33914 "EHLO fpa01n0.fpasia.hk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab3J2HnI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Oct 2013 03:43:08 -0400
Message-ID: <526F6755.90609@gtsys.com.hk>
Date: Tue, 29 Oct 2013 15:44:21 +0800
From: Chris Ruehl <chris.ruehl@gtsys.com.hk>
MIME-Version: 1.0
To: Fabio Estevam <festevam@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: imx27.dtsi usbotg/usbh2 oops in fsl_usb2_mph_dr_of_probe
References: <526E55DA.3070007@gtsys.com.hk> <CAOMZO5A6iMEzyRd81wogoO6NzDH3VqnaU9gH4-eh-SDQQMJ=Ww@mail.gmail.com> <526E5BA0.2030300@gtsys.com.hk>
In-Reply-To: <526E5BA0.2030300@gtsys.com.hk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday, October 28, 2013 08:42 PM, Chris Ruehl wrote:
> On Monday, October 28, 2013 08:25 PM, Fabio Estevam wrote:
>> On Mon, Oct 28, 2013 at 10:17 AM, Chris Ruehl 
>> <chris.ruehl@gtsys.com.hk> wrote:
>>> Hi,
>>>
>>> when tried to activate the USB-OTG or USBH2 with the FDT the system 
>>> oops
>> You should have posted this to the linux-usb list instead :-)
>>
>>
>>> config: (imx27.dtsi)
>>>
>>>              usbotg: usb@10024000 {
>>>                  compatible = "fsl-usb2-dr";
>> You should use compatible ="fsl,imx27-usb" so that it uses the
>> chipidea usb driver.
> I didn't get USB detected with
>
> compatible ="fsl,imx27-usb"
>
> nothing happen.
>
The ChipIdea was not selected in the .config  and this is why nothing 
come out.
(only if someone read the thread and wondering why)

>> -- 
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

