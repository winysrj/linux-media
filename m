Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m81KkB30014301
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 16:46:11 -0400
Received: from web35603.mail.mud.yahoo.com (web35603.mail.mud.yahoo.com
	[66.163.179.142])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m81KjMTq030559
	for <video4linux-list@redhat.com>; Mon, 1 Sep 2008 16:45:54 -0400
Date: Mon, 1 Sep 2008 13:45:21 -0700 (PDT)
From: Sam Logen <starz909@yahoo.com>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <176100.66247.qm@web35603.mail.mud.yahoo.com>
Subject: cx88 and Dvico hdtv card - card loses IR functionality
Reply-To: starz909@yahoo.com
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

Hi,

For some time I've been updating my drivers to V4L's tip repository, and I've consistently had some problems with my HDTV card.  It's a Dvico FusionHDTV 5 RT Gold card, and specifically the problems have to do with the remote control.  For awhile the drivers have supported the IR receiver of the card, but it has never been stable.

  For instance, after the machine is soft-powered off for some time, then turned on, the remote will no longer generate IR events.  The device node is there, but I cannot ircat any events when I use the remote, and programs such as mythtv will not respond to the remote - until I power off the machine, unplug it to flush the memory in the card, then re-connect the power and turn the machine back on.  Then the remote acts as it should.

  Second, the card has two system power-on functionalities.  The card can generate a PME wake event that will return the system on from a soft-off state through the bios.  Or the card can be plugged into the power button pins on the mainboard, and a signal from the remote will be perceived by the mainboard as if the power button was pushed.

  I am using the second option, since the bios has difficulties determining what is a PME event, and what is not.  The problem is that the second option only works after the memory of the card is flushed - if the machine has been unplugged for some time.  If I just soft-off the machine, the remote cannot be used to power the machine back on.

  I'm forced to hypothesize that the cx88 modules are affecting the memory in the card in such a way that certain functions are no longer performed properly.  If there's anything I can do to fix this, or any more information I can provide, please let me know.

Thanks,
Sam

lspci -vnnm

Device: 04:08.0
Class:  Multimedia video controller [0400]
Vendor: Conexant [14f1]
Device: CX23880/1/2/3 PCI Video and Audio Decoder [8800]
SVendor:        DViCO Corporation [18ac]
SDevice:        FusionHDTV 5 Gold [d500]
Rev:    05

Device: 04:08.1
Class:  Multimedia controller [0480]
Vendor: Conexant [14f1]
Device: CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] [8811]
SVendor:        DViCO Corporation [18ac]
SDevice:        DViCO FusionHDTV5 Gold [d500]
Rev:    05

Device: 04:08.2
Class:  Multimedia controller [0480]
Vendor: Conexant [14f1]
Device: CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] [8802]
SVendor:        DViCO Corporation [18ac]
SDevice:        DViCO FusionHDTV5 Gold [d500]
Rev:    05 


      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
