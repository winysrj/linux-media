Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65217 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756439Ab2BGU2w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2012 15:28:52 -0500
Received: by vbjk17 with SMTP id k17so4898398vbj.19
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2012 12:28:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F31690A.1050509@gmail.com>
References: <4F2AC7BF.4040006@ukfsn.org>
	<4F313BDC.1000100@ukfsn.org>
	<4F31690A.1050509@gmail.com>
Date: Tue, 7 Feb 2012 15:28:51 -0500
Message-ID: <CAGoCfixvcBpS-+EZ-K7xV2MPEMsW7YmpYC6WFnqL+m8nmsTV4g@mail.gmail.com>
Subject: Re: PCTV 290e page allocation failure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: gennarone@gmail.com
Cc: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Feb 7, 2012 at 1:10 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
> Il 07/02/2012 15:57, Andy Furniss ha scritto:
>
>> It will still fail if it has already failed and not been replugged.
>>
>> It's not failing to allocate - it's just not trying to allocate AFAICT ,
>> which I guess counts as a bug?
>
> For what is worth, on the MIPS STB I can't even rmmod the em28xx module
> and reload it, as rmmod gets stuck.
> The only solution to get the PCTV working again is a reboot.

Which kernel are you running.  There were fixes for problems related
to rmmod em28xx not working, which were only fixed recently.  You
would have to check the linux-media ML archives for the actual details
in terms of what release the work was committed to.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
