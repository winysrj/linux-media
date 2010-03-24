Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f216.google.com ([209.85.219.216]:60382 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab0CXWph (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Mar 2010 18:45:37 -0400
Received: by ewy8 with SMTP id 8so138537ewy.28
        for <linux-media@vger.kernel.org>; Wed, 24 Mar 2010 15:45:36 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 24 Mar 2010 16:45:35 -0600
Message-ID: <dfbf38831003241545s48e717c6i366599fd705c221c@mail.gmail.com>
Subject: Which of my 3 video capture devices will work best with my PC?
From: Serge Pontejos <jeepster.goons@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Greetings all...

I'm interested in doing video transfer from VCR to PC and want to know
which of the 3 capture devices I have has the best chance of working
with my setup? I have 3 different symptoms happening with each.

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

USB: Dazzle Digital Photo Maker, using a USBvision driver recognized
as a Global Village GV-7000)

--This one recognizes and I can display video but if I try to record
in either xawtv or Kdenlive the program crashes.

PCI: Hauppauge WinTV model 38101
--When installed it shows /dev/video0 when I do an ls, but I don't get
a signal with either composite or coax input.   I tried following
steps from this link http://howtoubuntu.org/?p=20 but it didn't change
a thing...

PCI: Aurora Systems Fuse previously used on a Mac
--This card picks up the ZR36067 driver, but it's saying it can't
initialize the i2c bus. Thus, no /dev/video* shows

Let me know which I should focus on and then I'll show the query dumps.

Any help on this would be greatly appreciated.



~Serge
