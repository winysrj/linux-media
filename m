Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mATIP5C8031553
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 13:25:05 -0500
Received: from smtp114.rog.mail.re2.yahoo.com (smtp114.rog.mail.re2.yahoo.com
	[68.142.225.230])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id mATIOjSg024385
	for <video4linux-list@redhat.com>; Sat, 29 Nov 2008 13:24:46 -0500
Message-ID: <493188E6.3020302@rogers.com>
Date: Sat, 29 Nov 2008 13:24:38 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: V4L <video4linux-list@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: RE: Hauppauge WinTV USB Model 566 PAL-I
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

Hi Chris,

 Chris Grove wrote
> it turns
> out that the tuner module has loaded the wrong tuner type. Instead of using
> tuner type 1, a PAL-I tuner which mine is, it selects a PAL-BG tuner. Now
> I've tried using type=1 in the modprobe line but it turns out that, that is
> no longer supported. 
>   

The option has probably been moved into the decoder module; check to see
if it has facilities for such a parameter with: /sbin/modinfo saa7115

> Any ideas please, and if someone has already asked this, sorry but I'm new
> to the list and haven't worked out how to search the archives yet.
I use marc ( http://marc.info/?l=linux-video ) , but there are a few
other ways too (gmane etc etc).

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
