Return-path: <mchehab@pedra>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59652 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab1FGQM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jun 2011 12:12:56 -0400
Received: by qwk3 with SMTP id 3so2217631qwk.19
        for <linux-media@vger.kernel.org>; Tue, 07 Jun 2011 09:12:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=3eyHgiXCsH2uibPsV0L7Eq79fnw@mail.gmail.com>
References: <BANLkTimFT+D3_vZVj5KMiB7jMvq=088Y7A@mail.gmail.com>
	<BANLkTim9d3yi3OQn4AxfwV6pfv+KY-KseA@mail.gmail.com>
	<BANLkTi=3eyHgiXCsH2uibPsV0L7Eq79fnw@mail.gmail.com>
Date: Tue, 7 Jun 2011 18:12:55 +0200
Message-ID: <BANLkTi=B5NmqnFqt5f90VdTEZUCZ_Tvuew@mail.gmail.com>
Subject: Re: [PATCH] cx231xx: Add support for Hauppauge WinTV USB2-FM
From: Peter Moon <pomoon@gmail.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 10:00 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Mon, Jun 6, 2011 at 3:22 PM, Peter Moon <pomoon@gmail.com> wrote:
>> This patch adds support for the " Hauppauge WinTV USB2-FM" Analog Stick.
>>
>> Signed-off-by: Peter Moon <pomoon@gmail.com>
>
> My only comment is that the func_mode in cx231xx_dif_set_standard()
> should be 0x01, not 0x03.  Change that, resubmit the patch after
> testing, and I will put my Reviewed-By on it.

I will make the change you suggest and retest.

> Also, there is actually another USB ID which is the exact same product
> (but targeted at NTSC by default).  I'll have to lookup the ID though.

According to the Windows driver inf file that I have, the USB ID of
the NTSC version is 2040:b111.

I can add the USB device definition for the NTSC targeted device as well.

Peter Moon
