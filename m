Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:39871 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbcD0KlB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Apr 2016 06:41:01 -0400
Date: Wed, 27 Apr 2016 07:40:55 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
	<linux-media@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] [media] tw686x: off by one bugs in tw686x_fields_map()
Message-ID: <20160427074055.091a90c8@recife.lan>
In-Reply-To: <20160427073159.041490f8@recife.lan>
References: <20160427080928.GC22469@mwanda>
	<20160427073159.041490f8@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 27 Apr 2016 07:31:59 -0300
Mauro Carvalho Chehab <mchehab@osg.samsung.com> escreveu:

> Hi Dan,
> 
> Em Wed, 27 Apr 2016 11:09:28 +0300
> Dan Carpenter <dan.carpenter@oracle.com> escreveu:
> 
> > The > ARRAY_SIZE() should be >= ARRAY_SIZE(). 
> 
> I actually did this fix when I produced the patch, just I forgot to fold
> it when merging. Anyway, this was fixed upstream by this patch:
> 	https://git.linuxtv.org/media_tree.git/commit/?id=45c175c4ae9695d6d2f30a45ab7f3866cfac184b
> 
> > Also this is a slightly
> > unrelated cleanup but I replaced the magic numbers 30 and 25 with
> > ARRAY_SIZE() - 1.
> 
> I don't like magic numbers, but, in this very specific case, setting
> frames per second (fps) var to 25 or 30 makes much more sense. The
> rationale is that:
> 
> The V4L2_STD_525_60 macro is for the Countries where the power line 
> uses 60Hz, and V4L2_STD_625_50 for the Countries where the power line
> is 50Hz.
> 
> The broadcast TV sends frames in half of this frequency, so, for
> V4L2_STD_525_60, fps = 30, while, for V4L2_STD_625_50, fps = 25.
> 
> So, in this very specific case, IMHO, it is better to see 25 or 30 there,
> instead of ARRAY_SIZE().
> 
> That's said, I guess one improvement would be to get rid of those two
> arrays and replacing them by a formula, like:
> 
>                	i = (max_fps / 2 + 15 * fps) / max_fps;
>                 if (i > 14)
>                         i = 0;
> 
> I'll propose such patch for evaluation.

I did some tests to check how that array was determined, using 
the enclosed program.

It seems that the table was generated using this formula:

               	i2 = (adjust + 15 * fps) / max_fps;
                if (fps && !i2)
                       	i2 = 1;
                if (i2 > 14)
                        i2 = 0;

Where adjust is given by:
	adjust = 12; /* actually, any value between 11 and 14 */

Using it, I got these results:


60 Hz
	    fps 0, i1=0, i2=0
	    fps 1, i1=1, i2=1
	    fps 2, i1=1, i2=1
	    fps 3, i1=1, i2=1
	    fps 4, i1=2, i2=2
	    fps 5, i1=2, i2=2
	    fps 6, i1=3, i2=3
	    fps 7, i1=3, i2=3
	    fps 8, i1=4, i2=4
	    fps 9, i1=4, i2=4
	    fps 10, i1=5, i2=5
	    fps 11, i1=5, i2=5
	    fps 12, i1=6, i2=6
	    fps 13, i1=6, i2=6
	    fps 14, i1=7, i2=7
	    fps 15, i1=7, i2=7
	    fps 16, i1=8, i2=8
	    fps 17, i1=8, i2=8
	    fps 18, i1=9, i2=9
	    fps 19, i1=9, i2=9
	    fps 20, i1=10, i2=10
	    fps 21, i1=10, i2=10
	    fps 22, i1=11, i2=11
	    fps 23, i1=11, i2=11
	    fps 24, i1=12, i2=12
	    fps 25, i1=12, i2=12
	    fps 26, i1=13, i2=13
	    fps 27, i1=13, i2=13
	    fps 28, i1=14, i2=14
	NOK fps 29, i1=0, i2=14
	    fps 30, i1=0, i2=0

50 Hz
	    fps 0, i1=0, i2=0
	    fps 1, i1=1, i2=1
	    fps 2, i1=1, i2=1
	    fps 3, i1=2, i2=2
	NOK fps 4, i1=3, i2=2
	    fps 5, i1=3, i2=3
	    fps 6, i1=4, i2=4
	    fps 7, i1=4, i2=4
	    fps 8, i1=5, i2=5
	    fps 9, i1=5, i2=5
	    fps 10, i1=6, i2=6
	    fps 11, i1=7, i2=7
	    fps 12, i1=7, i2=7
	    fps 13, i1=8, i2=8
	    fps 14, i1=8, i2=8
	    fps 15, i1=9, i2=9
	    fps 16, i1=10, i2=10
	    fps 17, i1=10, i2=10
	    fps 18, i1=11, i2=11
	    fps 19, i1=11, i2=11
	    fps 20, i1=12, i2=12
	    fps 21, i1=13, i2=13
	    fps 22, i1=13, i2=13
	    fps 23, i1=14, i2=14
	    fps 24, i1=14, i2=14
	    fps 25, i1=0, i2=0

IMHO, the two values that are different at the table are wrong ;)

I would also round to the closest number, with probably makes more
sense, and fits well at the API requirements.

The small program to test itis enclosed below. I'll send a patch
getting rid of those tables.

Regards,
Mauro

===

#include <stdio.h>

static const unsigned int std_625_50[26] = {
                0, 1, 1, 2,  3,  3,  4,  4,  5,  5,  6,  7,  7,
                   8, 8, 9, 10, 10, 11, 11, 12, 13, 13, 14, 14, 0
};

static const unsigned int std_525_60[31] = {
                0, 1, 1, 1, 2,  2,  3,  3,  4,  4,  5,  5,  6,  6, 7, 7,
                   8, 8, 9, 9, 10, 10, 11, 11, 12, 12, 13, 13, 14, 0, 0
};

void calc_fps(unsigned int max_fps)
{
	unsigned int i1, i2, fps, adjust;

//	adjust = max_fps / 2;
	adjust = 12; /* 11 a 14 */
	for (fps = 0; fps <= max_fps; fps++) {
		if (max_fps == 30)
			i1 = std_525_60[fps];
		else
			i1 = std_625_50[fps];

		i2 = (adjust + 15 * fps) / max_fps;
		if (fps && !i2)
			i2 = 1;
		if (i2 > 14)
			i2 = 0;

//if (i1 != i2)
		printf("\t%s fps %d, i1=%d, i2=%d\n",
			(i1 == i2)? "   " : "NOK",
			fps, i1, i2);
	}
}

void main(void)
{
	printf ("60 Hz\n");
	calc_fps(30);

	printf ("\n50 Hz\n");
	calc_fps(25);
}



-- 
Thanks,
Mauro
