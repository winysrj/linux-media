Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52801 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab2CUR51 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 13:57:27 -0400
Received: by bkcik5 with SMTP id ik5so1127215bkc.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 10:57:26 -0700 (PDT)
Message-ID: <4F6A168B.4090804@googlemail.com>
Date: Wed, 21 Mar 2012 18:57:31 +0100
From: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: moinejf@free.fr
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] [RFT/RFC] Add gspca subdriver for Speedlink VAD Laplace
 (EM2765+OV2640)
References: <1331936145-11839-1-git-send-email-fschaefer.oss@googlemail.com> <20120317141125.25774742@tele>
In-Reply-To: <20120317141125.25774742@tele>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 17.03.2012 14:11, schrieb Jean-Francois Moine:
> On Fri, 16 Mar 2012 23:15:45 +0100
> Frank Schäfer <fschaefer.oss@googlemail.com> wrote:
>
>> Anyway, I would be glad to get some feedback concerning form and content of the code, becausse I'm still a newbie to kernel programming.
> Hi Frank,
>
> I agree that writing a new gspca subdriver is easier than extending some
> other video driver...
>
> Here are some remarks:
>
> - you should not start the workqueue button_check immediately because
>   the webcam hardware is not fully initialized in sd_config().
>   Instead, you may check gspca_dev->present or have a greater delay
>   (1s) in sd_config(). This also avoids to patch the gspca main.
>
> - usually, the sensor reset ('12 80' for Omnivision - 2nd item in
>   ov2640_init) asks for some time. So, a little delay (200 ms) is
>   welcome.
>
> - I am not sure that looping on usb_control_msg() on read or write error
>   does help.
>
> - the debug flags D_USBI and D_USBO are no more available. It is easier
>   to use usbmon to trace the exchanges.
>
> - using the new control mechanism removes a lot of code (see stk014.c).
>
> - using the gspca variable 'usb_err' avoids testing each USB write
>   (during probe, you may use a flag to skip printing error messages).
>
> - in the form:
>
> 	- you must use
>
> 		module_usb_driver(sd_driver);
>
> 	  to replace the module stuff.
>
> 	- don't use C++ comments
>
> - the code may be optimized, as replacing the sequences of
>   write_prop_single() calls by a loop and a table.
>
> Best regards.
>

Hi Jean-Francois,

thanks for your remarks !
I will incoorporate them in case that a decision for a gspca subdriver
is made.

Regards,
Frank
