Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5DL9JvH009806
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 17:09:20 -0400
Received: from smtp3-g19.free.fr (smtp3-g19.free.fr [212.27.42.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5DL98Ix010352
	for <video4linux-list@redhat.com>; Fri, 13 Jun 2008 17:09:08 -0400
Message-ID: <4852E1F1.4040900@users.sourceforge.net>
Date: Fri, 13 Jun 2008 23:09:05 +0200
From: =?ISO-8859-1?Q?Andr=E9_AUZI?= <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
References: <20080207002224.e26d6bb1.hrabosh@t-email.cz>
	<20080613151843.240a62cb@gaivota>
In-Reply-To: <20080613151843.240a62cb@gaivota>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, nicolas <nicolas@nikoland.homelinux.org>,
	Nicolas Marot <nicolas.marot@gmail.com>, linux-kernel@vger.kernel.org,
	Zbynek Hrabovsky <hrabosh@t-email.cz>, Michel Lespinasse <walken@zoy.org>
Subject: Re: [PATCH][RESEND] New type of DTV2000H TV Card
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

Hi all,

forgive me if I jump in the conversation without invitation but I've got 
the same board and basically started the same task as you, Zbynek.

I'm still stuck with the radio support and your patch seems more 
advanced on the mpeg side.

Therefore, would you mind if I ask a question about what's proposed in 
the cx88-mpeg.c file?

> diff -r 04ddbe145932 linux/drivers/media/video/cx88/cx88-mpeg.c
> --- a/linux/drivers/media/video/cx88/cx88-mpeg.c	Tue Jun 10 15:27:29 2008 -0300
> +++ b/linux/drivers/media/video/cx88/cx88-mpeg.c	Fri Jun 13 15:07:34 2008 -0300
> @@ -148,6 +148,12 @@
>  			cx_write(TS_SOP_STAT, 0);
>  			cx_write(TS_VALERR_CNTRL, 0);
>  			udelay(100);
> +			break;
> +		case CX88_BOARD_WINFAST_DTV2000H_2:
> +			/* switch signal input to antena */
> +			cx_write(MO_GP0_IO, 0x00017300);
> +
> +			cx_write(TS_SOP_STAT, 0x00);
>  			break;
>  		default:
>  			cx_write(TS_SOP_STAT, 0x00);
>   

Correct me if I'm wrong but this change doesn't it prevent from 
processing data coming from the cable input?

Cheers,
André

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
