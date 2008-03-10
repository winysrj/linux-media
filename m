Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2ACPMs6015505
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 08:25:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2ACOh9X024585
	for <video4linux-list@redhat.com>; Mon, 10 Mar 2008 08:24:44 -0400
Date: Mon, 10 Mar 2008 09:23:57 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roel Kluin <12o3l@tiscali.nl>
Message-ID: <20080310092357.61020c7e@gaivota>
In-Reply-To: <47CEE9E2.6040303@tiscali.nl>
References: <47CEDE8D.7090707@tiscali.nl> <1204740974.17370.29.camel@localhost>
	<47CEE9E2.6040303@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Joe Perches <joe@perches.com>, v4l-dvb-maintainer@linuxtv.org,
	video4linux-list@redhat.com, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] em28xx-core.c: add missing parentheses in
 em28xx_write_ac97()
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

Roel and Joe,

Thanks for your patches.

I've already received and committed two patches with your proposed changes:

http://linuxtv.org/hg/v4l-dvb/rev/127f67dea087
http://linuxtv.org/hg/v4l-dvb/rev/f83ed13f5bf5

Cheers,
Mauro

On Wed, 05 Mar 2008 19:43:46 +0100
Roel Kluin <12o3l@tiscali.nl> wrote:

> Joe Perches wrote:
> 
> >> -		if (!((u8) ret) & 0x01)
> >> +		if (!(((u8) ret) & 0x01))
> > 
> > I think it'd be clearer without the cast to (u8)
> > which is then implicit cast back to int anyway
> > 
> > 	if (!(ret & 1))
> 
> ok.
> ---
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index 7d1537c..c797472 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -267,7 +267,7 @@ static int em28xx_write_ac97(struct em28xx *dev, u8 reg, u8 *val)
>  	for (i = 0; i < 10; i++) {
>  		if ((ret = em28xx_read_reg(dev, AC97BUSY_REG)) < 0)
>  			return ret;
> -		if (!((u8) ret) & 0x01)
> +		if (!(ret & 1))
>  			return 0;
>  		msleep(5);
>  	}




Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
