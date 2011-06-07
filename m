Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61006 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab1FGQRu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 12:17:50 -0400
Received: by ewy4 with SMTP id 4so1790609ewy.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 09:17:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=B5NmqnFqt5f90VdTEZUCZ_Tvuew@mail.gmail.com>
References: <BANLkTimFT+D3_vZVj5KMiB7jMvq=088Y7A@mail.gmail.com>
	<BANLkTim9d3yi3OQn4AxfwV6pfv+KY-KseA@mail.gmail.com>
	<BANLkTi=3eyHgiXCsH2uibPsV0L7Eq79fnw@mail.gmail.com>
	<BANLkTi=B5NmqnFqt5f90VdTEZUCZ_Tvuew@mail.gmail.com>
Date: Tue, 7 Jun 2011 12:17:49 -0400
Message-ID: <BANLkTi=0grHNHHzn2a0V2ApnabCaB2=5pg@mail.gmail.com>
Subject: Re: [PATCH] cx231xx: Add support for Hauppauge WinTV USB2-FM
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Peter Moon <pomoon@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Jun 7, 2011 at 12:12 PM, Peter Moon <pomoon@gmail.com> wrote:
> According to the Windows driver inf file that I have, the USB ID of
> the NTSC version is 2040:b111.

Correct.  The PAL defaulted device is b110.  The NTSC defaulted device is B111.

> I can add the USB device definition for the NTSC targeted device as well.

You can do this either one of two ways:  you can add just the USB ID
and point them both to the same card profile.  Or you can create two
card profiles that are identical in every way except for the default
standard.  The second approach is probably a better end-user
experience (since the default standard would match the user's
expectations), but the first approach is less code.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
