Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mALJXXOY017586
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:33:33 -0500
Received: from tomts23-srv.bellnexxia.net (tomts23-srv.bellnexxia.net
	[209.226.175.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mALJXF7g026744
	for <video4linux-list@redhat.com>; Fri, 21 Nov 2008 14:33:15 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: "'Kiss Gabor (Bitman)'" <kissg@ssg.ki.iif.hu>, Devin Heitmueller
	<devin.heitmueller@gmail.com>
Date: Fri, 21 Nov 2008 14:33:01 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C85C823@Colmatec004.COLMATEC.INT>
In-Reply-To: <alpine.DEB.1.10.0811212015070.29615@bakacsin.ki.iif.hu>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: V4L <video4linux-list@redhat.com>
Subject: RE: [video4linux] Attention em28xx users
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

You have to put 200-300 mb of sniff log

Whats your windows machine

Prefer use wxp but if it's a old machine u could try W2000 less memory usage

Remove max services, applications running with msconfig or taskmgr.

Its normal usbsniff freeze your pc, it focus on I/O northbrigde chipset interruption operations witch have priority on cpu usage


Make your tv app or usbsniff priority process in taskmgr under normal priority , ( try this after)

Or if u got a dua lcopre set affinity of both process ( tv and usb sniff) each on different core

IF nothing better comeback to me, im busy right now

-----Original Message-----
From: video4linux-list-bounces@redhat.com [mailto:video4linux-list-bounces@redhat.com] On Behalf Of Kiss Gabor (Bitman)
Sent: 21 novembre 2008 14:21
To: Devin Heitmueller
Cc: V4L
Subject: Re: [video4linux] Attention em28xx users

Dear Devin,

> The action item for the thread you referenced was for the user to
> capture a USB trace on a Windows system so we can compare the register
> operations.  If you want to pick up where the original user left off,
> please use SniffUSB to get a capture after plugging in the device and
> starting a capture session.
>
> http://www.pcausa.com/Utilities/UsbSnoop/default.htm
>
> If you can provide a USB capture, I can fix the code so this device
> starts working.

Uhm.... every time I tried to snoop USB traffic windows machine
got frozen or slowed veeeeeeeeeeery down.
So I could not run TV software bundled with device.
A very short (182 kB) capture about device connection is here:

http://bakacsin.ki.iif.hu/~kissg/tmp/connect-UsbSnoop.log.txt

A question:
Where should I download latest em28xx driver from?
http://linuxtv.org/hg/ or http://mcentral.de/hg/ ?

Regards

Gabor

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list

--

This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com)
www.solulan.com


No virus found in this incoming message.
Checked by AVG - http://www.avg.com
Version: 8.0.175 / Virus Database: 270.9.9/1803 - Release Date: 2008-11-21 09:37

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
