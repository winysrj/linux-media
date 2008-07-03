Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m63IZQ2P000913
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 14:35:26 -0400
Received: from smtp4-g19.free.fr (smtp4-g19.free.fr [212.27.42.30])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m63IZD7I001443
	for <video4linux-list@redhat.com>; Thu, 3 Jul 2008 14:35:13 -0400
Message-ID: <486D1C58.5020301@free.fr>
Date: Thu, 03 Jul 2008 20:37:12 +0200
From: Thierry Merle <thierry.merle@free.fr>
MIME-Version: 1.0
To: Hans de Goede <j.w.r.degoede@hhs.nl>
References: <486CBC99.20303@hhs.nl>
In-Reply-To: <486CBC99.20303@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, v4l2 library <v4l2-library@linuxtv.org>
Subject: Re: PATCH: v4l-dvb-do-not-strip-patch-files.patch
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

Hi Hans,
Hans de Goede a écrit :
> Hi,
>
> While doing make commit of my latest patch I found out that
> strip-whitespace also strips the application patches included in the
> latest libv4l, which is bad, this patch fixes this.
>
> Regards,
>
> Hans
> The libv4l directory contains some bugfix patches / port to libv4l patches
> for various applications, strip-trailing-whitespaces.sh should not
> touch these
> this patch teaches strip-trailing-whitespaces.sh to not touch .patch
> files.
>
> Signed-off-by: Hans de Goede <j.w.r.degoede@hhs.nl>
>
> diff -r 6169e79de2d2 v4l/scripts/strip-trailing-whitespaces.sh
> --- a/v4l/scripts/strip-trailing-whitespaces.sh    Tue Jul 01 21:18:23
> 2008 +0200
> +++ b/v4l/scripts/strip-trailing-whitespaces.sh    Thu Jul 03 13:46:16
> 2008 +0200
> @@ -20,6 +20,12 @@
>  fi
>  
>  for file in `eval $files`; do
> +    case "$file" in
> +        *.patch)
> +            continue
> +            ;;
> +    esac
> +
>      perl -ne '
>      s/[ \t]+$//;
>      s<^ {8}> <\t>;
Applied thanks.
Please post on the v4l2-library too since it targets the interested
people about this v4l userspace library specifically.
Cheers,
Thierry

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
