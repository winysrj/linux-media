Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9DE2cr9007980
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 10:02:39 -0400
Received: from smtp4.int-evry.fr (smtp4.int-evry.fr [157.159.10.71])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9DE2Kg0018385
	for <video4linux-list@redhat.com>; Mon, 13 Oct 2008 10:02:23 -0400
Received: from smtp2.int-evry.fr (smtp2.int-evry.fr [157.159.10.45])
	by smtp4.int-evry.fr (Postfix) with ESMTP id 66B2FFE2E2F
	for <video4linux-list@redhat.com>;
	Mon, 13 Oct 2008 16:02:20 +0200 (CEST)
Received: from smtp-ext.int-evry.fr (smtp-ext.int-evry.fr [157.159.11.17])
	by smtp2.int-evry.fr (Postfix) with ESMTP id 2A61340630D
	for <video4linux-list@redhat.com>;
	Mon, 13 Oct 2008 13:22:21 +0200 (CEST)
Received: from [192.168.0.101]
	(AAubervilliers-152-1-73-170.w86-198.abo.wanadoo.fr [86.198.123.170])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp-ext.int-evry.fr (Postfix) with ESMTP id 01E5190003
	for <video4linux-list@redhat.com>;
	Mon, 13 Oct 2008 13:22:20 +0200 (CEST)
Message-ID: <48F32F6B.7060704@minet.net>
Date: Mon, 13 Oct 2008 13:22:19 +0200
From: Yann Sionneau <yann@minet.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
References: <48EC0FBB.9000300@minet.net>
In-Reply-To: <48EC0FBB.9000300@minet.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: Problem using ov534
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Yann Sionneau wrote:
> Hi everybody !
> 
> i have an usb webcam "Hercules dualpix hd" which ID is 06f8:3003
> 
> I am under ubuntu linux Intrepid, kernel 2.6.27
> 
> When i plug my webcam it makes the little blue light on the webcam blink
> and modprobes automatically the module "ov534" i installed using the
> EasyCam2 project ( http://blognux.free.fr/?p=13 &
> http://forum.ubuntu-fr.org/viewtopic.php?id=16670 sorry it's in French ).
> 
> i get this in the dmesg :
> 
> [  268.452160] usb 5-1: new high speed USB device using ehci_hcd and
> address 2
> [  268.596393] usb 5-1: configuration #1 chosen from 1 choice
> [  269.035481] Linux video capture interface: v2.00
> [  269.089552] ov534: OmniVision OV534 compatible webcam detected
> [  269.089572] ov534: 06f8:3003 Hercules Dualpix HD Webcam found
> [  269.219459] ov534: ov534 controlling video device 0
> [  269.224432] ov534: OmniVision OV534 compatible webcam detected
> [  269.224452] ov534: 06f8:3003 Hercules Dualpix HD Webcam found
> [  269.327940] ov534: ov534 controlling video device 1
> [  269.328853] ov534: OmniVision OV534 compatible webcam detected
> [  269.328862] ov534: 06f8:3003 Hercules Dualpix HD Webcam found
> [  269.424565] ov534: ov534 controlling video device 2
> [  269.425476] usbcore: registered new interface driver ov534
> [  269.427512] ov534: ov534 v0.0.5 module loaded
> [  269.514057] usbcore: registered new interface driver snd-usb-audio
> 
> 
> and this
> 
> fallen@laptop:~$ lsmod | grep ov
> ov534                  27696  0
> videodev               41344  1 ov534
> compat_ioctl32          9344  1 ov534
> videobuf_vmalloc       14852  1 ov534
> videobuf_core          26628  2 ov534,videobuf_vmalloc
> usbcore               148848  7
> snd_usb_audio,snd_usb_lib,ov534,ohci_hcd,uhci_hcd,ehci_hcd
> 
> fallen@laptop:~$ lsmod | grep v4l
> v4l1_compat            22404  1 videodev
> 
> then i try using the webcam with vlc (with v4l or v4l2) and it doesn't
> work, so i try gstreamer-properties and i click on "Video" and i test
> each /dev/video* with v4l2 and it shows some strange green snow things
> but it does make the little blue light switch on on the webcam
> 
> I have nothing more than that, am i doing something wrong ?
> 
> I tried modprobing v4l2-common but it doesn't change anything, same
> thing with the module v4l2-int-device
> 
> 
> ps : when i test my webcam using gstreamer-properties i get this in dmesg :
> [  674.941551] ov534: open called (minor=0)
> [  674.943197] ov534: open called (minor=1)
> [  674.945343] ov534: open called (minor=2)
> [  674.946928] ov534: open called (minor=0)
> [  674.949190] ov534: open called (minor=1)
> [  674.951083] ov534: open called (minor=2)
> [  674.959171] ov534: open called (minor=0)
> [  674.962525] ov534: open called (minor=1)
> [  674.964377] ov534: open called (minor=2)
> [  680.379005] ov534: open called (minor=0)
> 
> looking forward to hearing from you :)
> 


Hi again, since i didn't get any answer i maybe emailing the wrong
mailing list.

Can you give me a way to contact the ov534 dev team ? or maybe i should
open a bug on some v4l bug tracker or ov534 bug tracker ?

If someone can tell me where the better place to report my problem or
get a solution is, it would be pretty cool ;)

thank you in advance !

looking forward to hearing from you.

- --
Yann Sionneau
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQEcBAEBAgAGBQJI8y9rAAoJEBkasY8500ICYVYH/R3mLbAzCaHpACSouh6mVlO3
EbpyxvIzmY6c3XB+QY1fEjVrrNeZKDm0ofB/BxZ++HQcaV62pZKKSIF7sSPfsJq3
fziCez7bzXbylSyrAPUreuZSYN+nwtOTBNwwH10ec40sHg9BPgE1AnKdcY/SfHWf
YcUMq5Y0gPfEaDi1lmnYRJntiAOV1pcTJXU/2QuW4eApGeFZvwrYB8eovUq4jD4l
gufUNTsWLbwBslaanQvIk0u+YPDE5kHCMxP2tIy2t4X30x7xYOlW+ixhAd0P4YN+
Z9wu6dm6G4lXEe33mzSvvJyj12mr/gEro+o7BYY3cgMmXlhwHkneJ1vz2qufXu0=
=DHVR
-----END PGP SIGNATURE-----

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
