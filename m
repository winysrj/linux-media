Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (ext-mx01.extmail.prod.ext.phx2.redhat.com
	[10.5.110.5])
	by int-mx03.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id o2NJjoUx030112
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 15:45:50 -0400
Received: from mail-ew0-f213.google.com (mail-ew0-f213.google.com
	[209.85.219.213])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id o2NJjcLG030916
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 15:45:39 -0400
Received: by ewy5 with SMTP id 5so962670ewy.30
	for <video4linux-list@redhat.com>; Tue, 23 Mar 2010 12:45:38 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 23 Mar 2010 14:45:37 -0500
Message-ID: <dfbf38831003231245o5b501793h8d22320e60ab98ba@mail.gmail.com>
Subject: Which of my 3 video capture devices will work best with my PC?
From: Serge Pontejos <jeepster.goons@gmail.com>
To: video4linux-list@redhat.com
List-Unsubscribe: <https://www.redhat.com/mailman/options/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Greetings all...

I'm interested in doing video transfer from VCR to PC and want to know which
of the 3 capture devices I have has the best chance of working with my
setup? I have 3 different symptoms happening with each.

My PC setup:
Ubuntu Karmic 9.10/2.6.31-20 generic
Socket 754 AMD Sempron 3000+ with passive cooling (non AMD64)
Biostar MB with Nforce3 250Gb chipset
NV31 GPU (Geforce FX5600 Ultra 128MB) using Nvidia 196 driver
1GB PC3200 DDR RAM
34GB SCSI coupled to a Adaptec 19160 card
Soundblaster Audigy
dvd+-R floppy etc etc.

The devices in question:

USB: Dazzle Digital Photo Maker, using a USBvision driver recognized as a
Global Village GV-7000)

--This one recognizes and I can display video but if I try to record in
either xawtv or Kdenlive the program crashes.

PCI: Hauppauge WinTV model 38101
--When installed it shows /dev/video0 when I do an ls, but I don't get a
signal with either composite or coax input.   I tried following steps from
this link http://howtoubuntu.org/?p=20 but it didn't change a thing...

PCI: Aurora Systems Fuse previously used on a Mac
--This card picks up the ZR36067 driver, but it's saying it can't initialize
the i2c bus. Thus, no /dev/video* shows

Let me know which I should focus on and then I'll show the query dumps.

Any help on this would be greatly appreciated.



~Serge
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
