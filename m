Return-path: <video4linux-list-bounces@redhat.com>
Date: Mon, 26 Jan 2009 22:40:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roel Kluin <roel.kluin@gmail.com>
Message-Id: <20090126224039.e43186e1.akpm@linux-foundation.org>
In-Reply-To: <4973BCD3.6080803@gmail.com>
References: <4973BCD3.6080803@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, mchehab@redhat.com,
	lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] DVB: negative internal->sub_range won't get noticed
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

On Mon, 19 Jan 2009 00:35:47 +0100 Roel Kluin <roel.kluin@gmail.com> wrote:

> internal->sub_range is unsigned, a negative won't get noticed.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/drivers/media/dvb/frontends/stb0899_algo.c b/drivers/media/dvb/frontends/stb0899_algo.c
> index 83dc7e1..2ea32da 100644
> --- a/drivers/media/dvb/frontends/stb0899_algo.c
> +++ b/drivers/media/dvb/frontends/stb0899_algo.c
> @@ -464,13 +464,14 @@ static void next_sub_range(struct stb0899_state *state)
>  
>  	if (internal->sub_dir > 0) {
>  		old_sub_range = internal->sub_range;
> -		internal->sub_range = MIN((internal->srch_range / 2) -
> +		if (internal->tuner_offst + internal->sub_range / 2 >=
> +				internal->srch_range / 2)
> +			internal->sub_range = 0;
> +		else
> +			internal->sub_range = MIN((internal->srch_range / 2) -
>  					  (internal->tuner_offst + internal->sub_range / 2),
>  					   internal->sub_range);
>  
> -		if (internal->sub_range < 0)
> -			internal->sub_range = 0;
> -
>  		internal->tuner_offst += (old_sub_range + internal->sub_range) / 2;
>  	}

I hope someone understands that function :(

Do we actually need that test at all?  Perhaps it has never triggered? 
Perhaps values in the 0x80000000 - 0xffffffff are actually OK?

This driver has managed to get itself a secret private version of the
min(), max() and abs() macros.  They're buggy - they reference their
argument multiple times.  The driver should be converted to use the
kernel.h versions.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
