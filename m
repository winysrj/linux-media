Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gordons.ginandtonic.no ([195.159.29.69])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <anders@ginandtonic.no>) id 1KiWCi-0003cq-O6
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 17:23:03 +0200
Received: from ti0013a380-dhcp0713.bb.online.no ([88.91.64.208]
	helo=anders-imac.lan) by gordons.ginandtonic.no with esmtpsa
	(TLS-1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.63)
	(envelope-from <anders@ginandtonic.no>) id 1KiWCA-00052U-Ku
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 17:22:27 +0200
Message-Id: <953A45C4-975B-4A05-8B41-AE8A486D0CA6@ginandtonic.no>
From: Anders Semb Hermansen <anders@ginandtonic.no>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v929.2)
Date: Wed, 24 Sep 2008 17:22:21 +0200
Subject: [linux-dvb] HVR-4000 and analogue tv
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello all,

I put a HVR-4000 in my mythtv box, I'm only going to use it for  
analogue TV right now.

I have used dvb/v4l drivers from mercirual from yesterday and sfe-8969- 
untested.diff from http://dev.kewl.org/hauppauge/ to get HVR-4000  
support.

The system is Debian GNU/Linux lenny with latest packages and kernel  
updated yesterday. Mythtv and multimedia packages are from debian- 
multimedia.

I also get the same error described below when using dvb/v4l driver  
from http://linuxtv.org/hg/~stoth/s2-mfe

I added it as a v4l capture card in mythtv (/dev/video0 and sound  
from /dev/dsp2) and scanned for channels. Everything OK so far :)

When I use mythtv and go into "Watch TV" I get snow on the screen (and  
some green). If I change channel the picture comes up fine. So I  
always have to change channel after pressing "Watch TV". This will  
make recodings only show snow, because I cannot do the channel change  
"trick".

I got strange audio, but read somewhere else that I needed to change  
audo samplerate to 48000. That fixed that problem.

I get some errors from the kernel.

These come a lot:
Sep 24 16:37:57 xpc kernel: [  656.419808] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 16:37:57 xpc kernel: [  656.419816] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 16:37:57 xpc kernel: [  656.419825] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*

And also this:
Sep 24 16:37:57 xpc kernel: [  656.420004] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 16:37:57 xpc kernel: [  656.420011] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 16:37:57 xpc last message repeated 7 times
Sep 24 16:37:57 xpc kernel: [  656.420011] cx88[0]/1: IRQ loop  
detected, disabling interrupts
Sep 24 16:37:57 xpc kernel: [  656.428111] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 24 16:38:07 xpc kernel: [  666.548868] cx88[0]: irq aud [0x201101]  
dn_risci1* dnf_of dn_sync* mchg_irq
Sep 24 16:38:07 xpc kernel: [  666.588442] cx88[0]: irq aud [0x1101]  
dn_risci1* dnf_of dn_sync*

I also got this (belive this was with s2-mfe driver):
Sep 23 23:07:43 xpc kernel: [   89.399157] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 23 23:07:53 xpc kernel: [   99.528009] cx88[0]: irq aud [0x201101]  
dn_risci1* dnf_of dn_sync* mchg_irq
Sep 23 23:07:53 xpc kernel: [   99.528009] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 23 23:07:53 xpc last message repeated 48 times
Sep 23 23:07:53 xpc kernel: [   99.528009] cx88[0]/1: IRQ loop  
detected, disabling interrupts
Sep 23 23:07:53 xpc kernel: [   99.539066] cx88[0]: irq aud [0x1001]  
dn_risci1* dn_sync*
Sep 23 23:15:34 xpc kernel: [  561.012009] cx88[0]: video y / packed -  
dma channel status dump
Sep 23 23:15:34 xpc kernel: [  561.012022] cx88[0]:   cmds: initial  
risc: 0x12f1c000
Sep 23 23:15:34 xpc kernel: [  561.012027] cx88[0]:   cmds: cdt  
base    : 0x00180440
Sep 23 23:15:34 xpc kernel: [  561.012031] cx88[0]:   cmds: cdt  
size    : 0x0000000c
Sep 23 23:15:34 xpc kernel: [  561.012035] cx88[0]:   cmds: iq  
base     : 0x00180400
Sep 23 23:15:34 xpc kernel: [  561.012039] cx88[0]:   cmds: iq  
size     : 0x00000010
Sep 23 23:15:34 xpc kernel: [  561.012042] cx88[0]:   cmds: risc  
pc     : 0x132aa998
Sep 23 23:15:34 xpc kernel: [  561.012046] cx88[0]:   cmds: iq wr  
ptr   : 0x00000100
Sep 23 23:15:34 xpc kernel: [  561.012050] cx88[0]:   cmds: iq rd  
ptr   : 0x00000104
Sep 23 23:15:34 xpc kernel: [  561.012054] cx88[0]:   cmds: cdt  
current : 0x00000458
Sep 23 23:15:34 xpc kernel: [  561.012058] cx88[0]:   cmds: pci  
target  : 0x132a9b00
Sep 23 23:15:34 xpc kernel: [  561.012061] cx88[0]:   cmds: line /  
byte : 0x00f00000
Sep 23 23:15:34 xpc kernel: [  561.012067] cx88[0]:   risc0:  
0x80008200 [ sync resync count=512 ]
Sep 23 23:15:34 xpc kernel: [  561.012074] cx88[0]:   risc1:  
0x1c000500 [ write sol eol count=1280 ]
Sep 23 23:15:34 xpc kernel: [  561.012080] cx88[0]:   risc2:  
0x12f02500 [ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012084] cx88[0]:   risc3:  
0x18000100 [ write sol count=256 ]
Sep 23 23:15:34 xpc kernel: [  561.012090] cx88[0]:   iq 0: 0x132a9000  
[ write irq2 irq1 21 19 cnt1 resync 12 count=0 ]
Sep 23 23:15:34 xpc kernel: [  561.012099] cx88[0]:   iq 1: 0x1c000500  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012103] cx88[0]:   iq 2: 0x132a9600  
[ write irq2 irq1 21 19 cnt1 resync 12 count=1536 ]
Sep 23 23:15:34 xpc kernel: [  561.012111] cx88[0]:   iq 3: 0x80008200  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012115] cx88[0]:   iq 4: 0x1c000500  
[ write sol eol count=1280 ]
Sep 23 23:15:34 xpc kernel: [  561.012121] cx88[0]:   iq 5: 0x12f02500  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012125] cx88[0]:   iq 6: 0x18000100  
[ write sol count=256 ]
Sep 23 23:15:34 xpc kernel: [  561.012131] cx88[0]:   iq 7: 0x12f02f00  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012134] cx88[0]:   iq 8: 0x14000400  
[ write eol count=1024 ]
Sep 23 23:15:34 xpc kernel: [  561.012140] cx88[0]:   iq 9: 0x12f03000  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012144] cx88[0]:   iq a: 0x1c000500  
[ write sol eol count=1280 ]
Sep 23 23:15:34 xpc kernel: [  561.012150] cx88[0]:   iq b: 0x12f03900  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012154] cx88[0]:   iq c: 0x1c000500  
[ write sol eol count=1280 ]
Sep 23 23:15:34 xpc kernel: [  561.012160] cx88[0]:   iq d: 0x12f04300  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012163] cx88[0]:   iq e: 0x18000300  
[ write sol count=768 ]
Sep 23 23:15:34 xpc kernel: [  561.012169] cx88[0]:   iq f: 0x12f04d00  
[ arg #1 ]
Sep 23 23:15:34 xpc kernel: [  561.012172] cx88[0]: fifo: 0x00180c00 - 
 > 0x183400
Sep 23 23:15:34 xpc kernel: [  561.012175] cx88[0]: ctrl: 0x00180400 - 
 > 0x180460
Sep 23 23:15:34 xpc kernel: [  561.012178] cx88[0]:   ptr1_reg:  
0x00182000
Sep 23 23:15:34 xpc kernel: [  561.012182] cx88[0]:   ptr2_reg:  
0x00180488
Sep 23 23:15:34 xpc kernel: [  561.012185] cx88[0]:   cnt1_reg:  
0x00000004
Sep 23 23:15:34 xpc kernel: [  561.012189] cx88[0]:   cnt2_reg:  
0x00000000
Sep 23 23:15:34 xpc kernel: [  561.012198] cx88[0]/0: [de9049e0/1]  
timeout - dma=0x132aa000
Sep 23 23:15:34 xpc kernel: [  561.012201] cx88[0]/0: [de904320/2]  
timeout - dma=0x13388000
Sep 23 23:15:34 xpc kernel: [  561.012205] cx88[0]/0: [de9043e0/3]  
timeout - dma=0x104fc000
Sep 23 23:15:34 xpc kernel: [  561.012208] cx88[0]/0: [de9044a0/4]  
timeout - dma=0x107ba000
Sep 23 23:15:34 xpc kernel: [  561.012211] cx88[0]/0: [de904920/0]  
timeout - dma=0x12f1c000

Mythtv complains about unable to read:
008-09-24 17:07:02.587 NVR(/dev/video0) Error: Only read -1 bytes of  
4096 bytes from '/dev/dsp2
read audio: Input/output error
strange error flushing buffer ...


Where do I go from here?
Is this an error with the HVR-4000 driver or in mythtv?
It seems to work fine once I have changed channel.


Thanks for any help,
Anders


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
