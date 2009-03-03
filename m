Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n23DX3Ht011639
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 08:33:03 -0500
Received: from smtp107.biz.mail.re2.yahoo.com (smtp107.biz.mail.re2.yahoo.com
	[206.190.52.176])
	by mx1.redhat.com (8.13.8/8.13.8) with SMTP id n23DWkMt030467
	for <video4linux-list@redhat.com>; Tue, 3 Mar 2009 08:32:46 -0500
Message-ID: <49AD2FBF.4000009@embeddedalley.com>
Date: Tue, 03 Mar 2009 16:25:19 +0300
From: Vitaly Wool <vital@embeddedalley.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <49ABF746.8000506@embeddedalley.com>
	<20090302164714.28d0e39f@pedra.chehab.org>
In-Reply-To: <20090302164714.28d0e39f@pedra.chehab.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] tvaudio: remove bogus check
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

Hello Mauro,


Mauro Carvalho Chehab wrote:

> This patch is wrong, since it will allow the access of an inexistent position at the shadow array:
>
> 	chip->shadow.bytes[subaddr+1] = val;
>
> The proper fix is to increase the size of the shadow.bytes array to properly
> handle the subaddr = 0xff. Something like:
>
> -#define MAXREGS 64
> +#define MAXREGS 256
>
> Except for allocating a few more bytes, such patch won't have any other drawback.
agreed. Here's the update:

 tvaudio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Signed-off-by: Vitaly Wool <vital@embeddedalley.com>

Index: linux-next/drivers/media/video/tvaudio.c
===================================================================
--- linux-next.orig/drivers/media/video/tvaudio.c	2009-03-02 17:50:40.000000000 +0300
+++ linux-next/drivers/media/video/tvaudio.c	2009-03-03 10:35:10.000000000 +0300
@@ -54,7 +54,7 @@
 /* ---------------------------------------------------------------------- */
 /* our structs                                                            */
 
-#define MAXREGS 64
+#define MAXREGS 256
 
 struct CHIPSTATE;
 typedef int  (*getvalue)(int);


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
