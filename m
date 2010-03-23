Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:62753 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab0CWUqd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Mar 2010 16:46:33 -0400
Message-ID: <4BA91A44.4090709@oracle.com>
Date: Tue, 23 Mar 2010 12:45:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
To: Ricardo Maraschini <xrmarsx@gmail.com>
CC: linux-media@vger.kernel.org, doug <dougsland@gmail.com>,
	mchehab@redhat.com
Subject: Re: [PATCH] Fix Warning ISO C90 forbids mixed declarations and code
 - 	cx88-dvb
References: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
In-Reply-To: <499b283a1003231342h6fcbe74di2aa67eb91b18cf0c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ricardo Maraschini wrote:
> --- a/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 16:17:11 2010 -0300
> +++ b/linux/drivers/media/video/cx88/cx88-dvb.c Tue Mar 23 17:29:29 2010 -0300
> @@ -1401,7 +1401,8 @@
>        case CX88_BOARD_SAMSUNG_SMT_7020:
>                dev->ts_gen_cntrl = 0x08;
> 
> -               struct cx88_core *core = dev->core;
> +               struct cx88_core *core;
> +               core = dev->core;
> 
>                cx_set(MO_GP0_IO, 0x0101);
> 
> 
> 
> Signed-off-by: Ricardo Maraschini <ricardo.maraschini@gmail.com>
> 
> 
> For any comments, please CC me in the message. I am waiting moderator
> approval to subscribe to this mailing list
> --

Hi,

Did you test this patch (by building this driver)?
I think not.

Also, the Signed-off-by: line should be before the patch, not after it.

~Randy
