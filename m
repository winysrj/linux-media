Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2H1P0Y7000785
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:25:00 -0400
Received: from wf-out-1314.google.com (wf-out-1314.google.com [209.85.200.174])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2H1OZ9t024384
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 21:24:36 -0400
Received: by wf-out-1314.google.com with SMTP id 28so4940954wfc.6
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 18:24:35 -0700 (PDT)
Message-ID: <1dea8a6d0803161824u12e639c2kfbd152456e7e82e3@mail.gmail.com>
Date: Mon, 17 Mar 2008 10:24:35 +0900
From: "Ben Caldwell" <benny.caldwell@gmail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
In-Reply-To: <47DDC428.1060306@linuxtv.org>
MIME-Version: 1.0
References: <1dea8a6d0803161804u1eef6c50uc86c0aa7e1dd2da8@mail.gmail.com>
	<47DDC428.1060306@linuxtv.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: V4L <video4linux-list@redhat.com>
Subject: Re: tuner-types.h symlink
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

On Mon, Mar 17, 2008 at 10:06 AM, Michael Krufky <mkrufky@linuxtv.org>
wrote:

>
> Which module's build produced this warning?  Can you show us the warning?
>
> Mike,

Here is the output from make with the symlink removed again:

*make -C /home/mythtv/tuner_card_new/v4l-dvb/v4l
make[1]: Entering directory `/home/mythtv/tuner_card_new/v4l-dvb/v4l'
creating symbolic links...
Kernel build directory is /lib/modules/2.6.24.3-12.fc8/build
make -C /lib/modules/2.6.24.3-12.fc8/build
SUBDIRS=/home/mythtv/tuner_card_new/v4l-dvb/v4l  modules
make[2]: Entering directory `/usr/src/kernels/2.6.24.3-12.fc8-x86_64'
  Building modules, stage 2.
  MODPOST 213 modules
WARNING: "tuners" [/home/mythtv/tuner_card_new/v4l-dvb/v4l/tuner-simple.ko]
undefined!
WARNING: "tuner_count" [/home/mythtv/tuner_card_new/v4l-dvb/v4l/tuner-
simple.ko] undefined!
make[2]: Leaving directory `/usr/src/kernels/2.6.24.3-12.fc8-x86_64'
./scripts/rmmod.pl check
found 213 modules
make[1]: Leaving directory `/home/mythtv/tuner_card_new/v4l-dvb/v4l'
*
I found the definition for tuner_count in tuner-types.h, and saw that
tuner-simple.c had an #include "tuner-types.h" so I added the symlink to see
if that helped.
Neither of the two warnings above came up the next time so I assume it did
help.

I've been having troubles with this card only showing one tuner in mythtv
lately, and came across this in my search for a fix.

Ben
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
