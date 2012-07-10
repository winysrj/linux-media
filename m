Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33358 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab2GJDQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Jul 2012 23:16:08 -0400
Received: by yhmm54 with SMTP id m54so85475yhm.19
        for <linux-media@vger.kernel.org>; Mon, 09 Jul 2012 20:16:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGoCfiyAOUY8XjnJpvg4Q7sFT=bYL0w-jqQ=80RPJm6dtxyMKw@mail.gmail.com>
References: <CAOkj57_x0CoUTce5t7U-=2YdkjOQV-_tBFKRJj41rZNQrPU+Uw@mail.gmail.com>
	<9c03d233-e0dd-4754-a9c7-53be71ac959a@email.android.com>
	<CAGoCfiyAOUY8XjnJpvg4Q7sFT=bYL0w-jqQ=80RPJm6dtxyMKw@mail.gmail.com>
Date: Mon, 9 Jul 2012 21:16:07 -0600
Message-ID: <CAOkj57-kKxa-QEFqW1CCN6Mdcxv19X29N7JKQeoVKjEsBDRsBg@mail.gmail.com>
Subject: Re: Linux equivalent of Windows VBIScope?
From: Tim Stowell <stowellt@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Andy Walls <awalls@md.metrocast.net>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

osc is perfect, thanks! In my past experience the em28xx driver has
been great, but I'll let you know if there are any issues.


On Mon, Jul 9, 2012 at 3:49 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Jul 9, 2012 at 5:32 PM, Andy Walls <awalls@md.metrocast.net> wrote:
>> Tim Stowell <stowellt@gmail.com> wrote:
>>
>>>Hi all,
>>>
>>>I am using the em28xx driver and have been able to extract captions
>>>using zvbi. I would like to visualize the waveform like the DirectShow
>>>VBIScope filter on windows (unfortunately the Windows driver doesn't
>>>expose any VBI pins). Does anyone know of anythings similar on Linux?
>>>Thanks
>>>--
>>>To unsubscribe from this list: send the line "unsubscribe linux-media"
>>>in
>>>the body of a message to majordomo@vger.kernel.org
>>>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> 'osc' is a test utility that is part of the zvbi source distribution.  It probably does what you need.
>>
>> Regards,
>> Andy
>
> I'll second Andy's endorsement of osc.  It's a very handy little tool.
>
> Also, if you run into any VBI issues with em28xx, please let me know
> (I did the original driver support for it).
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
