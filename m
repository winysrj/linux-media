Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAENTmsj015083
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 18:29:48 -0500
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.168])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAENTTcp007856
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 18:29:29 -0500
Received: by wf-out-1314.google.com with SMTP id 25so1594970wfc.6
	for <video4linux-list@redhat.com>; Fri, 14 Nov 2008 15:29:28 -0800 (PST)
Message-ID: <d7e40be30811141529r51a06a2cyba004588bd10a4f4@mail.gmail.com>
Date: Sat, 15 Nov 2008 10:29:28 +1100
From: "Ben Klein" <shacklein@gmail.com>
To: "Jonathan Lafontaine" <jlafontaine@ctecworld.com>,
	video4linux-list@redhat.com
In-Reply-To: <09CD2F1A09A6ED498A24D850EB101208165C85C81B@Colmatec004.COLMATEC.INT>
MIME-Version: 1.0
References: <d9def9db0811140750s15969a1fh1272402de897944d@mail.gmail.com>
	<09CD2F1A09A6ED498A24D850EB101208165C85C81B@Colmatec004.COLMATEC.INT>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: 
Subject: Re: MODRPOBE RMMOD
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

You can't unload a module if it's in use without forcing it (if your kernel
supports this, and if the driver doesn't mind, and if the wind's blowing the
right way). But forcing module unloads is a *BAD* idea.

The main reason is that most (all?) hardware devices have some state that
they would not be able to recover from if the driver suddenly disappeared.
The worst case would be harddrives, where a file would suddenly stop being
read or written to, stuffing up both the filesystem and the application at
the same time.

Another reason is that applications tend to assume that if it works once it
will keep on working while it's needed. Take the example of X; can you
imagine what would happen if you started up X and then suddenly your video
driver dissappeared from memory? (This is particularly pertinent for the
nvidia and ati/amd drivers that have kernel modules.) It's not just X that
would explode, but all the applications running under X.

2008/11/15 Jonathan Lafontaine <jlafontaine@ctecworld.com>

> How to disable  a module (em28xx) that is in use and if possible without
> wait params...
>
> Like on the fly, live!! Without reboot...
>
> -command line solution?
>
> -refind file descriptor  and close device with v4l2 ???
>
> -----Original Message-----
> From: video4linux-list-bounces@redhat.com [mailto:
> video4linux-list-bounces@redhat.com] On Behalf Of Markus Rechberger
> Sent: 14 novembre 2008 10:50
> To: Keith Lawson
> Cc: video4linux-list@redhat.com
> Subject: Re: USB Capture device
>
> On Fri, Nov 14, 2008 at 4:37 PM, Keith Lawson <lawsonk@lawson-tech.com>
> wrote:
> >
> >
> > On Thu, 13 Nov 2008, Markus Rechberger wrote:
> > <snip>
> >>
> >> are you sure this device is tm6000 based? I just remember the same
> >> product package used for em2820 based devices.
> >>
> >> http://mcentral.de/wiki/index.php5/Em2880#Devices
> >
> > It's a TM5600 device. I've been able to capture video from it using the
> > tm5600/tm6000/tm6010 module from Mauro's mercurial repository
> > but I'm having an issue with green flickering a the top of the video, I'm
> > not sure if that's a driver issue or an mplayer issue.
> >
> > Are you aware of a em2820 based USB "dongle" device? I don't require a
> > tuner, I'm just trying to capture input from S-video and composite (RCA).
> >
>
> I just had a rough look right now, the prices vary alot between
> different manufacturers.
> I haven't seen a price advantage for devices without tuner actually.
> You might pick a few devices from that site and compare.
>
> br,
> Markus
>
> >>
> >> br,
> >> Markus
> >>
> >>> Thanks,
> >>> Keith.
> >>>
> >>> On Fri, 7 Nov 2008, Keith Lawson wrote:
> >>>
> >>>> Hello,
> >>>>
> >>>> Can anyone suggest a good USB catpure device that has S-Video input
> and
> >>>> a
> >>>> stable kernel driver? I've been playing with this device:
> >>>>
> >>>> http://www.diamondmm.com/VC500.php
> >>>>
> >>>> using the development drivers from
> >>>> http://linuxtv.org/hg/~mchehab/tm6010/<http://linuxtv.org/hg/%7Emchehab/tm6010/>
> >>>> but I haven't had any luck with S-Video (only composite).
> >>>>
> >>>> Can anyone suggest a device with stable drivers in 2.6.27.5?
> >>>>
> >>>> Thanks, Keith.
> >>>>
> >>>> --
> >>>> video4linux-list mailing list
> >>>> Unsubscribe
> >>>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >>>> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>>>
> >>>
> >>> --
> >>> video4linux-list mailing list
> >>> Unsubscribe
> >>> mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> >>> https://www.redhat.com/mailman/listinfo/video4linux-list
> >>>
> >>
> >
> > --
> > video4linux-list mailing list
> > Unsubscribe mailto:video4linux-list-request@redhat.com
> ?subject=unsubscribe
> > https://www.redhat.com/mailman/listinfo/video4linux-list
> >
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>
> --
>
> This message has been verified by LastSpam (http://www.lastspam.com) eMail
> security service, provided by SoluLAN
> Ce courriel a ete verifie par le service de securite pour courriels
> LastSpam (http://www.lastspam.com), fourni par SoluLAN (
> http://www.solulan.com)
> www.solulan.com
>
>
> No virus found in this incoming message.
> Checked by AVG - http://www.avg.com
> Version: 8.0.175 / Virus Database: 270.9.2/1785 - Release Date: 2008-11-14
> 08:32
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
