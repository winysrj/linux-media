Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m280PSpC014675
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 19:25:28 -0500
Received: from mail-in-04.arcor-online.net (mail-in-04.arcor-online.net
	[151.189.21.44])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m280Os4C015909
	for <video4linux-list@redhat.com>; Fri, 7 Mar 2008 19:24:54 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Hartmut Hackmann <hartmut.hackmann@t-online.de>
In-Reply-To: <1204845694.8410.18.camel@pc08.localdom.local>
References: <1204753679.6717.29.camel@pc08.localdom.local>
	<47D064B2.6010803@t-online.de>
	<1204845694.8410.18.camel@pc08.localdom.local>
Content-Type: text/plain
Date: Sat, 08 Mar 2008 01:17:16 +0100
Message-Id: <1204935436.5376.37.camel@pc08.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] saa7134: Asus Tiger revision 1.0, subsys 1043:4857
	improvements
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

Hi Hartmut,

Am Freitag, den 07.03.2008, 00:21 +0100 schrieb hermann pitton:
> Am Donnerstag, den 06.03.2008, 22:40 +0100 schrieb Hartmut Hackmann:

[...]
> > >                                                             
> > <snip>
> > 
> > I guess you checked the entire eepron content ;-)
> > According to the documentation i have, there is no config byte describing the
> > assignment of antenna sockets. The document says that this byte is a checksum!!!
> > I will try to get some information.
> > I found one discrepancy:
> > The Tiger uses LINE1 for the audio baseband inputs while the ASUS uses LINE2.
> > Can you cross check this?
> > 
> > Best regards
> >   Hartmut
> > 
> 
> Hi Hartmut,
> 
> that was just some fallout in between and I`m sure to have the proper
> testings already. That checksum game is interesting, but whatsoever is
> such hidden something good for, except to cheat.
> 
> What gives me more to worry about recently is, that it is hard for me to
> "illuminate" some last working status of the saa7134-empress in some
> variant I have currently. (I'm down to bit specific operations)
> 
> If pioneers like Geert, Greg or Mans could provide me with some
> saa7134_i2c debug on _start_ last known state and setting the fmt
> successfully, might help.
> 

the mpeg encoder stuff (CTX946) I post on the video4linux-list when I
have some ground, recent ioctl2 stuff oopses on VIDIOC_QUERYCAP and also
with ext_ctrls it fails already on VIDIOC_G_STD. Analog and DVB-T
support could be already added, it behaves here like the md7134 with
FMD1216ME.

Your doubts about the analog audio input pairs on the Asus Tiger Rev.1.0
are correct, but turns out that sound is routed to both (!) from the
break out connectors. We might let it on LINE2 then, assuming this is
tested on the internal panel connection too ...

Also the composite over s-video is functional, which the Tiger seems not
to have.

Concerning the eeprom dump, thought we have now all bytes, at least
prior "eeprom" dumps did not return more. Also currently with the driver
loaded a read attempt returns -EBUSY, else there is no i2c-dev. Might
have forgotten something here, but let me know what you like to see in
case it could become useful.

Cheers,
Hermann







--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
