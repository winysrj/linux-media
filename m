Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n02Ege4s003503
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 09:42:40 -0500
Received: from qw-out-2122.google.com (qw-out-2122.google.com [74.125.92.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n02EgPcI024375
	for <video4linux-list@redhat.com>; Fri, 2 Jan 2009 09:42:25 -0500
Received: by qw-out-2122.google.com with SMTP id 3so2571237qwe.39
	for <video4linux-list@redhat.com>; Fri, 02 Jan 2009 06:42:24 -0800 (PST)
Message-ID: <412bdbff0901020642n7ef93c7ajff2ffe5e784a2940@mail.gmail.com>
Date: Fri, 2 Jan 2009 09:42:24 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Kuba Irzabek" <vega01@wp.pl>
In-Reply-To: <495DE5A6.8000404@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495DE5A6.8000404@wp.pl>
Cc: video4linux-list@redhat.com
Subject: Re: Pinnacle HDTV Ultimate USB and SAA7136
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

On Fri, Jan 2, 2009 at 5:00 AM, Kuba Irzabek <vega01@wp.pl> wrote:
> Hello,
>
> I found some posts from december last year about work on Pinnacle HDTV
> Ultimate USB being in progress and about SAA7136 documentation. I'm
> interested in getting analog tuner of AverTV Hybrid Volar HX (A827) to work
> under Linux. It also uses SAA7136 part. There were some posts about this
> AverTV card on linix-dvb, but I suppose nobody is currently working on it
> (especially the analog part). I would appreciate any info on the progress of
> work on the driver for SAA7136.
>
> Thank you very much!
> Regards,
>
> Kuba Irzabek

Hello Kuba,

I have the full documentation for the saa7136 and have been actively
working on the driver for the last couple of weeks.  I have the
S-Video and CVBS working, and am now working on the audio support and
the digital IF support required for the tuner.

I hope to release something in the next couple of weeks.

Cheers,

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
