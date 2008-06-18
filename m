Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5I2dRcK020595
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 22:39:28 -0400
Received: from outbound.icp-qv1-irony-out2.iinet.net.au
	(outbound.icp-qv1-irony-out2.iinet.net.au [203.59.1.107])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5I2dF7P002706
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 22:39:17 -0400
Message-ID: <4858755C.7090606@iinet.net.au>
Date: Wed, 18 Jun 2008 10:39:24 +0800
From: timf <timf@iinet.net.au>
MIME-Version: 1.0
To: Dan Taylor <dtaylor@startrac.com>
References: <1822849CB0478545ADCFB217EF4A340584E53A@sedah.startrac.com>
In-Reply-To: <1822849CB0478545ADCFB217EF4A340584E53A@sedah.startrac.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] Avermedia A16D composite input
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

Dan Taylor wrote:
> This is a patch against 78442352b885.  It adds composite support for the
> included Composite->S-video adapter that comes with the Avermedia A16D.
> The work that went into DVB support for the card made this much simpler
> than my earlier version.
>
>  
>
> As before, it has been tested with a signal generator and an iPod.
>
>  
>
> I appreciate the DVB work and hope to be testing it early next week.
> Does anyone have a sample mplayer config file for DVB-T?
>
>  
>
> diff -upr linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
> linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
> --- linux-2.6.26-v4l/drivers/media/video/saa7134/saa7134-cards.c
> 2008-06-15 05:33:42.000000000 -0800
> +++ linux-2.6.26-v4lc/drivers/media/video/saa7134/saa7134-cards.c
> 2008-06-17 16:19:14.000000000 -0800
> @@ -4269,6 +4269,10 @@ struct saa7134_board saa7134_boards[] = 
>                   .name = name_svideo,
>                   .vmux = 8,
>                   .amux = LINE1,
> +           }, {
> +                 .name = name_comp,
> +                 .vmux = 0,
> +                 .amux = LINE1,
>             } },
>             .radio = {
>                   .name = name_radio,
>  
>
>  
>
>  
>
>  
>
>   
> ------------------------------------------------------------------------
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
Hi Dan,
Well done!
I just responded to alert you that you will need to send a patch to 
Mauro direct as well.
You will need to run it through various checks before it will happen.
However, excellent, it looks like the card is complete!
Regards,
Timf

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
