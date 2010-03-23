Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:33080 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0CWUsY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 16:48:24 -0400
Received: by bwz1 with SMTP id 1so2261174bwz.21
        for <linux-media@vger.kernel.org>; Tue, 23 Mar 2010 13:48:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
Date: Tue, 23 Mar 2010 16:48:22 -0400
Message-ID: <829197381003231348h5c09c76av1adfbf7f13df10a1@mail.gmail.com>
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code -
	cx88-dvb
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ricardo Maraschini <xrmarsx@gmail.com>
Cc: linux-media@vger.kernel.org, doug <dougsland@gmail.com>,
	mchehab@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 23, 2010 at 4:42 PM, Ricardo Maraschini <xrmarsx@gmail.com> wrote:
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 16:17:11 2010 -0300
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:29:29 2010 -0300
> @@ -1401,7 +1401,8 @@
>       case CX88_BOARD_SAMSUNG_SMT_7020:
>               dev->ts_gen_cntrl = 0x08;
>
> -               struct cx88_core *core = dev->core;
> +               struct cx88_core *core;
> +               core = dev->core;
>
>               cx_set(MO_GP0_IO, 0x0101);
>
>
>
> Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>

How do you think this actually addresses the warning in question?  You
still have the declaration of the variable in the middle of the switch
statement.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
