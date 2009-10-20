Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx05.extmail.prod.ext.phx2.redhat.com
	[10.5.110.9])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n9K8MVCe010878
	for <video4linux-list@redhat.com>; Tue, 20 Oct 2009 04:22:31 -0400
Received: from mail-fx0-f217.google.com (mail-fx0-f217.google.com
	[209.85.220.217])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n9K8MEMk020709
	for <video4linux-list@redhat.com>; Tue, 20 Oct 2009 04:22:15 -0400
Received: by fxm17 with SMTP id 17so1056153fxm.3
	for <video4linux-list@redhat.com>; Tue, 20 Oct 2009 01:22:13 -0700 (PDT)
Message-ID: <4ADD7333.4040309@lfarkas.org>
Date: Tue, 20 Oct 2009 10:22:11 +0200
From: Farkas Levente <lfarkas@lfarkas.org>
MIME-Version: 1.0
To: Oleksandr Naumenko <o.naumenko@gmx.de>
References: <20091019235613.7680@gmx.net>
In-Reply-To: <20091019235613.7680@gmx.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: AverTV GO 007 FM Plus
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

On 10/20/2009 01:56 AM, Oleksandr Naumenko wrote:
> Hello,
> 
> I recently installed Linux and am currently trying to make my tv tunner (AverTV GO 007 FM Plus) work. Had real problems with autodetection so i just did as discribed on
> http://www.ubuntuhcl.org/browse/product+AVerMedia_AVerTV_GO_007_FM_Plus_M15C?id=804
> 
> but i still don't have sound even tho i can see video now.
> 
> If i use "cat /dev/dsp1 | aplay -r 32000" I can hear sound, but its like compressed and totaly not understandable.
> 
> I tried to do as postet in 
> http://www.archivum.info/video4linux-list@redhat.com/2005-03/00107/Re:_Philips_SILICON_tuner_starts_working_-_was_-_Re:_asus_tvfm-7135
> 
> but if i try to apply the patch, i'm asked which file i want to patch...
> the problem is i have no clue which one it should be. Maybe someone could give me a small (a big one is very welcome as well) hint which file it is or what to do.

add to modprobe.conf:
---------------------------
options snd cards_limit=8
alias snd-card-0 snd-hda-intel
options snd-card-0 index=0
options snd-hda-intel index=0
alias snd-card-1 saa7134-alsa
options saa7134 card=57 tuner=54 alsa=1
install saa7134 /sbin/modprobe --ignore-install saa7134; /sbin/modprobe
saa7134-alsa
options saa7134-alsa index=1
---------------------------
and play with:
gst-launch-0.10 alsasrc device=hw:1,0 ! capsfilter
"caps=audio/x-raw-int,rate=32000" ! alsasink
or:
sox -r 32000 -w -t alsa hw:1,0 -t alsa hw:0,0 2>/dev/null
or:
arecord -D hw:1,0 -r 32000 -c 2 -f S16_LE | aplay -

-- 
  Levente                               "Si vis pacem para bellum!"

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
