Return-path: <video4linux-list-bounces@redhat.com>
Date: Tue, 8 Jul 2008 21:30:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Message-ID: <20080708183019.GA11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net>
	<20080708170044.262684000@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080708170044.262684000@sipsolutions.net>
Cc: video4linux-list@redhat.com, linux-ppp@vger.kernel.org,
	Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>, dm-devel@redhat.com,
	David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC 04/11] remove CONFIG_KMOD from drivers
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

On Tue, Jul 08, 2008 at 07:00:19PM +0200, Johannes Berg wrote:
>...
> --- everything.orig/drivers/md/md.c	2008-07-08 18:46:21.000000000 +0200
> +++ everything/drivers/md/md.c	2008-07-08 18:49:10.000000000 +0200
>...
> @@ -3410,7 +3405,7 @@ static int do_md_run(mddev_t * mddev)
>  		}
>  	}
>  
> -#ifdef CONFIG_KMOD
> +#ifdef CONFIG_MODULES
>  	if (mddev->level != LEVEL_NONE)
>  		request_module("md-level-%d", mddev->level);
>  	else if (mddev->clevel[0])
>...

You can remove the #ifdef

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
