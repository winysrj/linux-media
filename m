Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:42485 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab3L2DqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Dec 2013 22:46:16 -0500
Received: from uscpsbgm2.samsung.com
 (u115.gpu85.samsung.co.kr [203.254.195.115]) by usmailout4.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MYJ00EJAUH32660@usmailout4.samsung.com> for
 linux-media@vger.kernel.org; Sat, 28 Dec 2013 22:46:15 -0500 (EST)
Date: Sun, 29 Dec 2013 01:44:51 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: =?UTF-8?B?QW5kcsOp?= Roth <neolynx@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 12/13] libdvbv5: fix missing includes
Message-id: <20131229014451.190ad75e.m.chehab@samsung.com>
In-reply-to: <1388245561-8751-12-git-send-email-neolynx@gmail.com>
References: <1388245561-8751-1-git-send-email-neolynx@gmail.com>
 <1388245561-8751-12-git-send-email-neolynx@gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 28 Dec 2013 16:46:00 +0100
André Roth <neolynx@gmail.com> escreveu:

> Signed-off-by: André Roth <neolynx@gmail.com>
> ---
>  lib/libdvbv5/dvb-file.c     | 1 +
>  lib/libdvbv5/dvb-sat.c      | 1 +
>  lib/libdvbv5/dvb-scan.c     | 1 +
>  lib/libdvbv5/parse_string.c | 1 +
>  4 files changed, 4 insertions(+)
> 
> diff --git a/lib/libdvbv5/dvb-file.c b/lib/libdvbv5/dvb-file.c
> index 9abb1f7..d5b00e2 100644
> --- a/lib/libdvbv5/dvb-file.c
> +++ b/lib/libdvbv5/dvb-file.c
> @@ -21,6 +21,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <strings.h> // strcasecmp
>  #include <unistd.h>
>  
>  #include "dvb-file.h"
> diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
> index 3cbcf03..c35e3d7 100644
> --- a/lib/libdvbv5/dvb-sat.c
> +++ b/lib/libdvbv5/dvb-sat.c
> @@ -21,6 +21,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
> +#include <strings.h> // strcasecmp
>  
>  #include "dvb-fe.h"
>  #include "dvb-v5-std.h"
> diff --git a/lib/libdvbv5/dvb-scan.c b/lib/libdvbv5/dvb-scan.c
> index 6f3def6..d0f0b39 100644
> --- a/lib/libdvbv5/dvb-scan.c
> +++ b/lib/libdvbv5/dvb-scan.c
> @@ -35,6 +35,7 @@
>  #include <sys/stat.h>
>  #include <sys/types.h>
>  #include <stdlib.h>
> +#include <sys/time.h>
>  
>  #include "dvb-scan.h"
>  #include "dvb-frontend.h"
> diff --git a/lib/libdvbv5/parse_string.c b/lib/libdvbv5/parse_string.c
> index f7b745e..8bd56f3 100644
> --- a/lib/libdvbv5/parse_string.c
> +++ b/lib/libdvbv5/parse_string.c
> @@ -27,6 +27,7 @@
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> +#include <strings.h> // strcasecmp

Don't use C99 comments.
>  
>  #include "parse_string.h"
>  #include "dvb-log.h"


-- 

Cheers,
Mauro
