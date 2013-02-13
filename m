Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:38653 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3BMCi0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Feb 2013 21:38:26 -0500
Received: by mail-ee0-f43.google.com with SMTP id c50so390212eek.16
        for <linux-media@vger.kernel.org>; Tue, 12 Feb 2013 18:38:25 -0800 (PST)
Message-ID: <511AFC9E.5060408@gmail.com>
Date: Wed, 13 Feb 2013 03:38:22 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: joe@perches.com
Subject: Re: [PATCH] MAINTAINERS: Remove Jarod Wilson and orphan LIRC drivers
References: <1360704036.22660.5.camel@joe-AO722>
In-Reply-To: <1360704036.22660.5.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12.02.2013 22:20, Joe Perches wrote:
> His email bounces and he hasn't done work on
> these sections in a couple of years.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   MAINTAINERS | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1d0651e..8d47b3a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7523,7 +7523,6 @@ F:	drivers/staging/comedi/
>
>   STAGING - CRYSTAL HD VIDEO DECODER
>   M:	Naren Sankar <nsankar@broadcom.com>
> -M:	Jarod Wilson <jarod@wilsonet.com>
>   M:	Scott Davilla <davilla@4pi.com>
>   M:	Manu Abraham <abraham.manu@gmail.com>
>   S:	Odd Fixes
> @@ -7557,9 +7556,8 @@ S:	Odd Fixes
>   F:	drivers/staging/iio/


Not bouncing:

  -> RCPT TO:<jarod@redhat.com>
<-  250 2.0.0 r1D2CGt8016879 Message accepted for delivery
  -> RCPT TO:<davilla@4pi.com>
<-  250 OK id=1U5S5A-0001hr-O7
  -> RCPT TO:<nsankar@broadcom.com>
<-  250 OK - Data received

but noreply on 5+ tries, as for

amejia@debian.org (Broadcom crystalhd LGPL code repository @ Debian & Debian maintainer)

No reply to confirmed critical BUG with emergency patches in tracker:
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=699470
http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=682252
http://bugs.debian.org/cgi-bin/pkgreport.cgi?src=crystalhd

y
tom

