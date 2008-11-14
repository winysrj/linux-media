Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAEFvu4r007624
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:57:56 -0500
Received: from tomts23-srv.bellnexxia.net (tomts23-srv.bellnexxia.net
	[209.226.175.185])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAEFvfma019938
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 10:57:41 -0500
From: Jonathan Lafontaine <jlafontaine@ctecworld.com>
To: Markus Rechberger <mrechberger@gmail.com>, Keith Lawson
	<lawsonk@lawson-tech.com>
Date: Fri, 14 Nov 2008 10:55:30 -0500
Message-ID: <09CD2F1A09A6ED498A24D850EB101208165C79D395@Colmatec004.COLMATEC.INT>
References: <491339D9.2010504@personnelware.com>
	<30353c3d0811061553h4c1a77e0t597bd394fa0ebdf1@mail.gmail.com>
	<4913E9DB.8040801@hhs.nl> <200811071050.25149.hverkuil@xs4all.nl>
	<20081107161956.c096dd03.ospite@studenti.unina.it>
	<alpine.DEB.1.10.0811071416380.25756@vegas>
	<alpine.DEB.1.10.0811130651170.2643@vegas>
	<d9def9db0811130440t17b05c58q603a14e446e417e5@mail.gmail.com>
	<alpine.DEB.1.10.0811141033000.23321@vegas>,
	<d9def9db0811140750s15969a1fh1272402de897944d@mail.gmail.com>
In-Reply-To: <d9def9db0811140750s15969a1fh1272402de897944d@mail.gmail.com>
Content-Language: fr-CA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: RE : USB Capture device
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

try the kworld usb ( no audio chip inside and using 2860 chipset, I succes use pal/m which is 525 lines like ntsc....)

theres Pinnacle dazzle dvc 100 a lot available on sites. did not succes use pal/m :(

but ac97 sound support. this is a 2820 chip with saa7113h philips v-decoder
________________________________________
De : video4linux-list-bounces@redhat.com [video4linux-list-bounces@redhat.com] de la part de Markus Rechberger [mrechberger@gmail.com]
Date d'envoi : 14 novembre 2008 10:50
À : Keith Lawson
Cc : video4linux-list@redhat.com
Objet : Re: USB Capture device

On Fri, Nov 14, 2008 at 4:37 PM, Keith Lawson <lawsonk@lawson-tech.com> wrote:
>
>
> On Thu, 13 Nov 2008, Markus Rechberger wrote:
> <snip>
>>
>> are you sure this device is tm6000 based? I just remember the same
>> product package used for em2820 based devices.
>>
>> http://mcentral.de/wiki/index.php5/Em2880#Devices
>
> It's a TM5600 device. I've been able to capture video from it using the
> tm5600/tm6000/tm6010 module from Mauro's mercurial repository
> but I'm having an issue with green flickering a the top of the video, I'm
> not sure if that's a driver issue or an mplayer issue.
>
> Are you aware of a em2820 based USB "dongle" device? I don't require a
> tuner, I'm just trying to capture input from S-video and composite (RCA).
>

I just had a rough look right now, the prices vary alot between
different manufacturers.
I haven't seen a price advantage for devices without tuner actually.
You might pick a few devices from that site and compare.

br,
Markus

>>
>> br,
>> Markus
>>
>>> Thanks,
>>> Keith.
>>>
>>> On Fri, 7 Nov 2008, Keith Lawson wrote:
>>>
>>>> Hello,
>>>>
>>>> Can anyone suggest a good USB catpure device that has S-Video input and
>>>> a
>>>> stable kernel driver? I've been playing with this device:
>>>>
>>>> http://www.diamondmm.com/VC500.php
>>>>
>>>> using the development drivers from
>>>> http://linuxtv.org/hg/~mchehab/tm6010/
>>>> but I haven't had any luck with S-Video (only composite).
>>>>
>>>> Can anyone suggest a device with stable drivers in 2.6.27.5?
>>>>
>>>> Thanks, Keith.
>>>>
>>>> --
>>>> video4linux-list mailing list
>>>> Unsubscribe
>>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>>
>>>
>>> --
>>> video4linux-list mailing list
>>> Unsubscribe
>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
>>> https://www.redhat.com/mailman/listinfo/video4linux-list
>>>
>>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

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
Version: 8.0.175 / Virus Database: 270.9.2/1785 - Release Date: 2008-11-14 08:32

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
