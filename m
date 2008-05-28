Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4SKdk3H023487
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 16:39:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id m4SKcqN1028548
	for <video4linux-list@redhat.com>; Wed, 28 May 2008 16:38:52 -0400
Date: Wed, 28 May 2008 17:37:55 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Carl Karsten <carl@personnelware.com>
Message-ID: <20080528173755.594ea08b@gaivota>
In-Reply-To: <483DBD67.8090508@personnelware.com>
References: <47C8A0C9.4020107@personnelware.com>
	<20080304112519.6f4c748c@gaivota>
	<483DBD67.8090508@personnelware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] vivi: registered as /dev/video%d
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

On Wed, 28 May 2008 15:15:35 -0500
Carl Karsten <carl@personnelware.com> wrote:

> I posted a week ago and haven't heard anything.

I was on vacations last week.

>  How long should I wait before 
> posting this? :)

There are a few issues on your patch:

> -		else
> +            printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME,
> dev->vfd->minor);

Your patch got word wrapped. So, it didn't apply.

> +        }
> +		else {

CodingStyle is wrong. It should be:
	} else {

(at the same line)

Also, on some places, you used space, instead of tabs.

Please, check your patch with checkpatch.pl (or, inside Mercurial, make
checkpatch) before sending it.

Also, be sure that your emailer won't add line breaks at the wrong places.
>   	} else
>   		printk(KERN_INFO "Video Technology Magazine Virtual Video "
> -				 "Capture Board successfully loaded.\n");
> +                 "Capture Board ver %u.%u.%u successfully loaded.\n",
> +        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION &
> 0xFF);

The indentation is very weird here.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
