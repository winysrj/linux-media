Return-path: <mchehab@pedra>
Received: from omr-d33.mx.aol.com ([205.188.249.131]:41274 "EHLO
	omr-d33.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab1EBB6Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 May 2011 21:58:16 -0400
Message-ID: <4DBE0F74.80602@netscape.net>
Date: Sun, 01 May 2011 22:57:08 -0300
From: =?windows-1252?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: Help to make a driver. ISDB-Tb
References: <4DBC422F.10102@netscape.net> <4DBCB4EF.5070104@redhat.com>
In-Reply-To: <4DBCB4EF.5070104@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

Thank you very much for your time and answer

El 30/04/11 22:18, Mauro Carvalho Chehab escribió:
>> drivers/media/video/cx23885/cx23885-cards.c:240:3: error: ‘CX23885_BOARD_MYGICA_X8507’ undeclared here (not in a function)
> You forgot to declare this constant somewhere with #define.
I found it. I had written CX23885_BOARD_MYGICA_X507 rather than 
CX23885_BOARD_MYGICA_X8507 in cx23885.h

> It is not that simple. You need to setup the GPIO pins of your device, and
> set the DVB frontend according to how this is wired inside the board,
> and providing the information about the used frontend. I think that your
> device is based on mb86a20s demod.
Yes.
If I compare to the X8506 images taken from 
http://www.mingo-hmw.com/forum/viewthread.php?tid=85682 and 
http://www.dcfever.com/trading/view.php?itemID=436551, with the X8507 
taken from 
http://www.linuxtv.org/wiki/index.php/File:MyGica_X8507_1.png; I see 
that the difference is on the plate added to the main board. Best viewed 
with the image of the X8507 and corresponds to the frontend.
For this last reason is that I risk trying to do something.

> It requires you some knowledge about Engineering
At this point I have no problems, but still need to read a lot.
> , as well as C programming
> experience.
At this point yes. The last time I programmed anything was more than 
twenty years and was in pascal or qbasic, I do not remember.

I modify the following files: cx23885-cards.c, cx23885-dvb.c, 
cx23885-video.c, cx23885.h

Then compile and install. The result when loading was as follows:


[ 10.461192] cx23885 driver version 0.0.2 loaded
[ 10.461288] cx23885 0000:02:00.0: PCI INT A -> GSI 19 (level, low) -> 
IRQ 19
[ 10.461487] CORE cx23885[0]: subsystem: 14f1:8502, board: Mygica X8507 
[card=30,insmod option]
[ 11.027607] cx25840 5-0044: cx23885 A/V decoder found @ 0x88 (cx23885[0])
[ 12.193826] cx25840 5-0044: loaded v4l-cx23885-avcore-01.fw firmware 
(16382 bytes)
[ 12.202863] tuner 4-0061: chip found @ 0xc2 (cx23885[0])
[ 12.235023] xc5000 4-0061: creating new instance
[ 12.235719] xc5000: Successfully identified at address 0x61
[ 12.235721] xc5000: Firmware has not been loaded previously
[ 12.235802] cx23885[0]/0: registered device video1 [v4l2]
[ 12.241230] xc5000: waiting for firmware upload 
(dvb-fe-xc5000-1.6.114.fw)...
[ 12.262115] xc5000: firmware read 12401 bytes.
[ 12.262117] xc5000: firmware uploading...
[ 13.637009] xc5000: firmware upload complete...
[ 14.250077] cx23885_dvb_register() allocating 1 frontend(s)
[ 14.250081] cx23885[0]: cx23885 based dvb card
[ 14.288344] mb86a20s: mb86a20s_attach:
[ 14.288626] Frontend revision 255 is unknown - aborting.
[ 14.288705] cx23885[0]: frontend initialization failed
[ 14.288710] cx23885_dvb_register() dvb_register failed err = -1
[ 14.288714] cx23885_dev_setup() Failed to register dvb adapters on VID_B
[ 14.288721] cx23885_dev_checkrevision() Hardware revision = 0xb0
[ 14.288729] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 19, 
latency: 0, mmio: 0xfd600000
[ 14.288737] cx23885 0000:02:00.0: setting latency timer to 64
[ 14.288828] cx23885 0000:02:00.0: irq 44 for MSI/MSI-X

I guess the error is in this part of the module mb86a20s.c

/* Check if it is a mb86a20s frontend */
rev = mb86a20s_readreg(state, 0);
if (rev == 0x13) {
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

printk(KERN_INFO "Detected a Fujitsu mb86a20s frontend\n");
} else {
printk(KERN_ERR "Frontend revision %d is unknown - aborting.\n",
rev);
goto error;
}

I reiterate my gratitude,

Alfredo

-- 
Dona tu voz
http://www.voxforge.org/es

