Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx03.extmail.prod.ext.phx2.redhat.com
	[10.5.110.7])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id nAAEp1FH028262
	for <video4linux-list@redhat.com>; Tue, 10 Nov 2009 09:51:01 -0500
Received: from www.tglx.de (www.tglx.de [62.245.132.106])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nAAEoxE2026041
	for <video4linux-list@redhat.com>; Tue, 10 Nov 2009 09:51:00 -0500
Date: Tue, 10 Nov 2009 15:50:52 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Roland Egli <roland.egli@gmx.net>
Message-ID: <20091110145049.GA3282@bluebox.local>
References: <4AF87D5D.5090205@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF87D5D.5090205@gmx.net>
Cc: video4linux-list@redhat.com
Subject: Re: Terratec Cinergy 600 TV MK3: Problem with Radio/RDS
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

On Mon, Nov 09, 2009 at 09:36:45PM +0100, Roland Egli wrote:
> Hi all
>
> I have the TV card "Terratec Cinergy 600 TV MK3" with SAA7134HL. The  
> tuner is a Philips FM1216ME/H-3 and there is an additional RDS decoder  
> SAA6588T.
>
> For loading the module I use
> $ modprobe saa7134 card=48 tuner=38
>
> TV works fine, but I have a problem with the radio. The sound is very  
> noisy, not stereo and there is as well no RDS reception (saa6588 module  
> is loaded as well).

For RDS reception, you need a strong signal since the RDS carrier's
level is well below the audio carrier level. Your only chance is to
improve reception. What kind of antenna are you using? Are you sure it's
connected to the _radio_ antenna jack and not the TV?

Thanks,
Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
