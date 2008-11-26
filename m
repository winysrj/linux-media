Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAQK0rDn032423
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:00:53 -0500
Received: from mail.ki.iif.hu (mail.ki.iif.hu [193.6.222.241])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAQK0cKk020570
	for <video4linux-list@redhat.com>; Wed, 26 Nov 2008 15:00:39 -0500
Date: Wed, 26 Nov 2008 21:00:34 +0100 (CET)
From: "Kiss Gabor (Bitman)" <kissg@ssg.ki.iif.hu>
To: Devin Heitmueller <devin.heitmueller@gmail.com>
In-Reply-To: <412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0811262054050.10867@bakacsin.ki.iif.hu>
References: <412bdbff0811161506j3566ad4dsae09a3e1d7559e3@mail.gmail.com>
	<alpine.DEB.1.10.0811172119370.855@bakacsin.ki.iif.hu>
	<412bdbff0811171254s5e732ce4p839168f22d3a387@mail.gmail.com>
	<alpine.DEB.1.10.0811192133380.32523@bakacsin.ki.iif.hu>
	<412bdbff0811191305y320d6620vfe28c0577709ea66@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: [video4linux] Attention em28xx users
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

> Hello Gabor,
> 
> Playing with the "card=" argument is probably not such a good idea.
> I should consider taking that functionality out, since setting to the
> wrong card number can damage the device (by setting the wrong GPIOs).
> 
> If somebody can get me a USB trace of the device starting up under
> Windows, I can probably make this card work.

Dear Devin,

We could get two USB traces (some 2-4 GB each uncompressed).
File http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-tv.rar shows
what happened during setup and the first few seconds of scanning
for TV channels. (Unfortunately we had no good antenna signal.)
http://bakacsin.ki.iif.hu/~kissg/tmp/UsbSnoop-svideo.rar is recorded
during setup and  shor use of S-video input.

And http://bakacsin.ki.iif.hu/~kissg/tmp/connect-UsbSnoop.log.txt
is the log of USB connection.

I hope this can provide you enough information.

Device is ADS Tech "Instant TV USB"
http://www.adstech.com/Support/ProductSupport.asp?productId=USBAV-704&productName=Instant%20TV

Regards

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
