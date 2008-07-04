Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m64HXpit028180
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 13:33:51 -0400
Received: from smtp2-g19.free.fr (smtp2-g19.free.fr [212.27.42.28])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m64HXbMf019305
	for <video4linux-list@redhat.com>; Fri, 4 Jul 2008 13:33:38 -0400
Message-ID: <486E5F68.80201@free.fr>
Date: Fri, 04 Jul 2008 19:35:36 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Gregor Jasny <jasny@vidsoft.de>
References: <20080704144036.GJ18818@vidsoft.de>
In-Reply-To: <20080704144036.GJ18818@vidsoft.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2-library@linuxtv.org
Subject: Re: PATCH: libv4l-fix-idct-inline-assembly.diff
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Gregor Jasny a écrit :
> Hi,
>
> This patch fixes the input constraint for the sar instruction. It allows only an
> immediate or cl as shift width.
>
> Thanks,
> Gregor
>
> Signed-off-by: Gregor Jasny <jasny@vidsoft.de>
>
> diff -r 61deeffda900 v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c
> --- a/v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c	Fri Jul 04 07:21:55 2008 +0200
> +++ b/v4l2-apps/lib/libv4l/libv4lconvert/jidctflt.c	Fri Jul 04 16:24:33 2008 +0200
> @@ -92,7 +92,7 @@ static inline unsigned char descale_and_
>        "\tcmpl %4,%1\n"
>        "\tcmovg %4,%1\n"
>        : "=r"(x)
> -      : "0"(x), "Ir"(shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)
> +      : "0"(x), "Ic"((unsigned char)shift), "ir"(1UL<<(shift-1)), "r" (0xff), "r" (0)
>        );
>    return x;
>  }
>
>   
Applied on http://www.linuxtv.org/hg/~tmerle/v4l2-library

Thanks,

Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
