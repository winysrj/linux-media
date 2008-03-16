Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m2GGP5wL008381
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 12:25:05 -0400
Received: from moutng.kundenserver.de (moutng.kundenserver.de
	[212.227.126.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m2GGOWUJ009156
	for <video4linux-list@redhat.com>; Sun, 16 Mar 2008 12:24:33 -0400
From: Peter Missel <peter.missel@onlinehome.de>
To: Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>,
	video4linux-list@redhat.com
Date: Sun, 16 Mar 2008 17:24:20 +0100
References: <20050806200358.12455.qmail@web60322.mail.yahoo.com>
	<200803161254.28025.peter.missel@onlinehome.de>
	<cfbe4ae12b756df6c951bdb8218917aa@gimpelevich.san-francisco.ca.us>
In-Reply-To: <cfbe4ae12b756df6c951bdb8218917aa@gimpelevich.san-francisco.ca.us>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Disposition: inline
Message-Id: <200803161724.20459.peter.missel@onlinehome.de>
Content-Transfer-Encoding: 8bit
Cc: 
Subject: Re: [PATCH] Re: LifeVideo To-Go Cardbus, tuner problems
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

Hi Daniel!

> Card: LifeView® LifeVideo To-Go

> Rather than paste dmesg and/or lspci output, I have made a patch and
> attached it.

Enthusiasm appreciated ... but now that I'm seeing the details of the card, I 
also see that your patch isn't quite appropriate.

As a long time LifeView vs. Linux contributer, let me introduce you to how I 
think this should be approached.

Step 1: Find out what design family it belongs to - by its PCI ID.

The card's ID is 1502h, which identifies it as a member of the X502 aka 
FlyDVB-T Cardbus series. Other members include the DVB-T, the DVB-T Duo, and 
the DVB-T Hybrid. They're all just permutations of the same feature set.

So your first attempt should be using the card number of the 0x0502 and see 
what happens ...

Step 2: See whether the existing code covers the new model.

The 1502 possibly "just works" using the card definition of the 0502 - if the 
rest of the code detects the absence of the DVB-T tuner gracefully. You can 
check that by using the card=N parameter with the card number for the DVB-T 
Duo.

And while you're doing that, please check whether the video inputs (SVideo, 
Composite, and Composite-on-SVideo) are operational as well. (This is where 
using the "Mini" card's description screws up - yours has separate SVideo and 
Composite inputs like all the Cardbus cards do.)

If it's all OK, then you create a new PCI ID as a patch. Please stick with the 
33/35 chip, no Cardbus versions have been seen using the 30 or 34 chip 
versions. But do add a 2nd entry using subsystem vendor 4E42h, just in case 
the next guy has an OEM version of this card, not a LifeView branded one.

Step 3: Roll your own.

If the code for the 0502 doesn't work well with the DVB-T tuner gone missing, 
you copy the card description, remove the DVB-T tuner part, and point your 
pair of new PCI ID entries to this new card definition.


Good luck, and if you need some help with any of the above, do post back.

regards,
Peter

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
