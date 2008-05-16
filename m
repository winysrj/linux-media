Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m4GJgJ9l024780
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 15:42:19 -0400
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m4GJg4DY013892
	for <video4linux-list@redhat.com>; Fri, 16 May 2008 15:42:05 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: "pw.marcus" <pw.marcus@laposte.net>
In-Reply-To: <482DBF75.60009@laposte.net>
References: <482D4579.8090203@laposte.net>
	<1210937808.3138.7.camel@pc10.localdom.local>
	<482DBF75.60009@laposte.net>
Content-Type: text/plain
Date: Fri, 16 May 2008 21:41:44 +0200
Message-Id: <1210966904.4735.35.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: My Cinema-P7131 Hybrid (spider cable)
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


Am Freitag, den 16.05.2008, 19:08 +0200 schrieb pw.marcus:
> Hermann thank you for your answer, ok, I see, I should have thought 
> about it before ! so much the worst !
> 
> One second question :
> 
> How are configured the 2 main outputs of the card ?
> 
> Upside output for DVB-T & radio ?
> Downside output for analog TV ?
> 
> Is it right ?
> 
> Cheers
> 

Yes, this is right.

You can force card=81 if you want to have DVB-T and analog TV on the
lower connector and only radio on the upper, but the remote is not
enabled on that card then.

Take care, you might get trouble on analog TV SECAM_L NICAM stereo
detection from 2.6.25 onwards. Mauro disabled valid PAL and SECAM sub
standards, which were introduced to be user selectable for the reason
that audio carrier autodetection is not always successfully, especially
not for SECAM_L NICAM on the second carrier, but also for others.

Until 2.6.24 one could force "secam=L" by an saa7134 insmod option (try
"modinfo saa7134") or select it from the application. On saa7135 and
saa7131e also forcing it with "audio_ddep=0x10" for Secam_L/L' was
possible. This all looks pretty much broken currently, but I can't test
on that known critical stuff and Hartmut, who spent two weekends with a
signal generator to come to viable solutions for all after years, might
be pleased as well ;)

Cheers,
Hermann





--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
