Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:59886 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756757Ab2AKEYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 10 Jan 2012 23:24:36 -0500
Received: by werm1 with SMTP id m1so224755wer.19
        for <linux-media@vger.kernel.org>; Tue, 10 Jan 2012 20:24:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201081230.42414.laurent.pinchart@ideasonboard.com>
References: <CAOy7-nNSu2v9VS9Bh5O5StvEAvoxA4DqN7KdSGfZZSje1_Fgnw@mail.gmail.com>
	<201201061409.30592.laurent.pinchart@ideasonboard.com>
	<CAOy7-nMBw8Mry9iL0fYKQ1_Bpjp9Pm5hUzPE-SFD9JwGfpv3FA@mail.gmail.com>
	<201201081230.42414.laurent.pinchart@ideasonboard.com>
Date: Wed, 11 Jan 2012 12:24:35 +0800
Message-ID: <CAOy7-nNEYxbH2gqfS=hRuBMJWeX+cbm4ReNvncdoJMsazdQaDQ@mail.gmail.com>
Subject: Re: Using OMAP3 ISP live display and snapshot sample applications
From: James <angweiyang@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On Sun, Jan 8, 2012 at 7:30 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi James,
>
> On Sunday 08 January 2012 02:14:55 James wrote:
>
> [snip]
>
>> BTW, can you send me the defconfig file you used for testing on overo as I
>> couldn‘t compile your branch with mine.
>
> Attached.
>
>> I forgot to mentioned that I'm trying out the application with the MT9V032
>> camera first on both Tobi & Chestnut board. Not with the new monochrome
>> sensor yet.
>
> --
> Regards,
>
> Laurent Pinchart

Thanks for the defconfig.

I'll proceed to try to build a fresh kernel based on your branch
"omap3isp-sensors-board".

I guess this is a better branch or should I try the YUV branch or others?

Test1 with MT9V032 and Test2 with monochrome sensor Y12.

Thanks.

-- 
Regards,
James
