Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n22Jm0mx015806
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 14:48:00 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n22Jlhut020179
	for <video4linux-list@redhat.com>; Mon, 2 Mar 2009 14:47:43 -0500
Date: Mon, 2 Mar 2009 16:47:14 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Vitaly Wool <vital@embeddedalley.com>
Message-ID: <20090302164714.28d0e39f@pedra.chehab.org>
In-Reply-To: <49ABF746.8000506@embeddedalley.com>
References: <49ABF746.8000506@embeddedalley.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

On Mon, 02 Mar 2009 18:12:06 +0300
Vitaly Wool <vital@embeddedalley.com> wrote:

> Hello Mauro,
> 
> below is the patch that removes the subaddr check against ARRAY_SIZE(chip->shadow.bytes).
> Regardless of anything, the 'bytes' array is 64 bytes large so this check disables 
> easy standard programming (TDA9874A_ESP) which has a number of 255 which is hardly the
> intended behavior.
> 
> As a matter of fact, we can think of separate check for this case like
> 	if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes) ||
> 	    subaddr != 0xFF) {
> 		... /* weird register, refuse */
> 	}
> but I'm not sure if there are no other special cases so for now I suggest to just disable
> it.

This patch is wrong, since it will allow the access of an inexistent position at the shadow array:

	chip->shadow.bytes[subaddr+1] = val;

The proper fix is to increase the size of the shadow.bytes array to properly
handle the subaddr = 0xff. Something like:

-#define MAXREGS 64
+#define MAXREGS 256

Except for allocating a few more bytes, such patch won't have any other drawback.

> 
>  drivers/media/video/tvaudio.c |   17 +----------------
>  1 file changed, 1 insertion(+), 16 deletions(-)
> 
> Signed-off-by: Vitaly Wool <vital@embeddedalley.com> 
> 
> Index: linux-next/drivers/media/video/tvaudio.c
> ===================================================================
> --- linux-next.orig/drivers/media/video/tvaudio.c	2009-03-02 17:50:40.000000000 +0300
> +++ linux-next/drivers/media/video/tvaudio.c	2009-03-02 18:08:08.000000000 +0300
> @@ -169,13 +169,6 @@
>  			return -1;
>  		}
>  	} else {
> -		if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
> -			v4l2_info(sd,
> -				"Tried to access a non-existent register: %d\n",
> -				subaddr);
> -			return -EINVAL;
> -		}
> -
>  		v4l2_dbg(1, debug, sd, "chip_write: reg%d=0x%x\n",
>  			subaddr, val);
>  		chip->shadow.bytes[subaddr+1] = val;
> @@ -198,16 +191,8 @@
>  	if (mask != 0) {
>  		if (subaddr < 0) {
>  			val = (chip->shadow.bytes[1] & ~mask) | (val & mask);
> -		} else {
> -			if (subaddr + 1 >= ARRAY_SIZE(chip->shadow.bytes)) {
> -				v4l2_info(sd,
> -					"Tried to access a non-existent register: %d\n",
> -					subaddr);
> -				return -EINVAL;
> -			}
> -
> +		} else
>  			val = (chip->shadow.bytes[subaddr+1] & ~mask) | (val & mask);
> -		}
>  	}
>  	return chip_write(chip, subaddr, val);
>  }
> 
> 




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
