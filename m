Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5H9jfVu030595
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:45:41 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m5H9jTxZ019999
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 05:45:30 -0400
Date: Tue, 17 Jun 2008 11:45:10 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Veda N <veda74@gmail.com>
Message-ID: <20080617094510.GA726@daniel.bse>
References: <a5eaedfa0806170205r12eed4edl30e2653a918e4cad@mail.gmail.com>
	<20080617092439.GA631@daniel.bse>
	<a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5eaedfa0806170239ye9951acv1cc9361b1d43abbe@mail.gmail.com>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2_pix_format doubts
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

On Tue, Jun 17, 2008 at 03:09:04PM +0530, Veda N wrote:
>   As i understand, my camera has a image processor inside it. what i
> want to say is it is
>   not a plain raw sensor.

So this image processor converts RGB to YUV?

>   For every pixel clock a pixel is fetched from the device and is
> placed in memory
>   Once a entire frame is captured. it is returned to the application.

And if you look at this data in memory, what does it look like?

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
