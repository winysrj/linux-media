Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42657 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988Ab1ISUNO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Sep 2011 16:13:14 -0400
Received: by fxe4 with SMTP id 4so4311100fxe.19
        for <linux-media@vger.kernel.org>; Mon, 19 Sep 2011 13:13:12 -0700 (PDT)
Message-ID: <4E77A258.3050806@googlemail.com>
Date: Mon, 19 Sep 2011 22:13:12 +0200
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Jean-Francois Moine <moinejf@free.fr>
Subject: Re: Question about USB interface index restriction in gspca
References: <4E6FAB94.2010007@googlemail.com>	<20110914082513.574baac2@tele>	<4E727251.9030308@googlemail.com> <20110916083302.1deb338e@tele>
In-Reply-To: <20110916083302.1deb338e@tele>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 16.09.2011 08:33, schrieb Jean-Francois Moine:
> On Thu, 15 Sep 2011 23:46:57 +0200
> Frank Schäfer<fschaefer.oss@googlemail.com>  wrote:
>
>>> For webcam devices, the interface class is meaningful only when set to
>>> USB_CLASS_VIDEO (UVC). Otherwise, I saw many different values.
>> Does that mean that there are devices out in the wild that report for
>> example USB_CLASS_WIRELESS_CONTROLLER for the video interface ???
>>
>>> For video on a particular interface, the subdriver must call the
>>> function gspca_dev_probe2() as this is done in spca1528 and xirlink_cit.
>> Hmm, sure, that would work...
>> But wouldn't it be better to improve the interface check and merge the
>> two probing functions ?
>> The subdrivers can decide which interfaces are (not) probed and the
>> gspca core does plausability checks (e.g. bulk/isoc endpoint ? usb class ?).
> Generally, the first interface is the video device, and the function
> gspca_dev_probe() works well enough.
>
> The function gspca_dev_probe2() is used by only 2 subdrivers and the
> way to find the correct interface is not easy. For example, the webcam
> 047d:5003 (subdriver spca1528) has 3 interfaces (class vendor specific).
> The 1st one has only one altsetting with only one interrupt endpoint,
> the 2nd one has 8 altsettings, each with only one isochronous endpoint,
> and the last one has one altsetting with 3 endpoints (bulk in, bulk out
> and interrupt). At the first glance, it is easy to know the right
> interface, but writing generic code to handle such webcams seems rather
> complicated.
I didn't want to say that it is easy to know the right interface. It is 
definitely not.
But I think we could do it better than we currently do.

Anyway, it seems there is no interest in such a patch.
Thanks for you explanations.

> So, if your webcam is in the 99.99% which use the interface 0, use
> gspca_dev_probe(), otherwise, YOU know the right interface, so, call
> gspca_dev_probe2().
Isn't it also possible that we don't know the right interface and it is 
not interface 0 ? ;-)

Regards,
Frank

