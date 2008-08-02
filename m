Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m72DY9jq019482
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 09:34:09 -0400
Received: from smtp-vbr16.xs4all.nl (smtp-vbr16.xs4all.nl [194.109.24.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m72DXarN021718
	for <video4linux-list@redhat.com>; Sat, 2 Aug 2008 09:33:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com
Date: Sat, 2 Aug 2008 15:30:32 +0200
References: <87myjv1sfo.fsf@free.fr>
In-Reply-To: <87myjv1sfo.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021530.33194.hverkuil@xs4all.nl>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: Allocation of micron MT9M111 chip v42l ident ID
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

On Saturday 02 August 2008 15:02:03 Robert Jarzmik wrote:
> Hello,
>
> I will submit within the next few hours/days a driver for a Micron
> mt9m111 camera chip. I know only one flavor of the MT9M111 chip,
> there are no distinctions like monochrome/color models.
>
> Would that be possible to have a chip ID assigned in
> v4l2-chip-ident.h, eg. something like :
> +	V4L2_IDENT_MT9M111		= ???,
> Is there a procedure for such things ?
>
> I'll wait for an answer before submitting the mt9m111 driver.

Just provide a patch for that header. Usually the number chosen is 
similar to the chip type number. In this case I guess 9111 is a good 
choice.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
