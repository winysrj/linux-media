Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9A0IY97008396
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 20:18:34 -0400
Received: from mho-02-bos.mailhop.org (mho-02-bos.mailhop.org [63.208.196.179])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9A0ILS7008874
	for <video4linux-list@redhat.com>; Thu, 9 Oct 2008 20:18:21 -0400
Message-ID: <48EE9FC0.6080400@edgehp.net>
Date: Thu, 09 Oct 2008 20:20:16 -0400
From: Dale Pontius <DEPontius@edgehp.net>
MIME-Version: 1.0
To: "video4linux-list@redhat.com" <video4linux-list@redhat.com>
References: <1222651357.2640.21.camel@morgan.walls.org>
	<48EC18D7.3070807@edgehp.net>
	<1223501731.2807.9.camel@morgan.walls.org>
In-Reply-To: <1223501731.2807.9.camel@morgan.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: 
Subject: Re: cx18: Fix needs test: more robust solution to get CX23418 based
 cards to work reliably
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

Andy Walls wrote:
> On Tue, 2008-10-07 at 22:20 -0400, Dale Pontius wrote:
>> Andy Walls wrote:
>>> cx18 driver users:
>>>
>>> In this repository:
>>>
>>> http://linuxtv.org/hg/~awalls/cx18-mmio-fixes/
>>>
>> Can't get there from here:
> 
> Yeah, I nuked that repo once Mauro merged the change into the main repo.
> 
> 
>> I've been getting help from you with problems with my HVR-1600, and have
>> a friend with WinXP machines who can likely help me out testing it, but
>> he's been on vacation, and shortly I'll be gone for a bit.
>>
>> In the meantime, since it appears that I've been having i2c problems and
>> the mmio_ndelay gave me marginally better operation, I'd like to give
>> this patch a try.  (Or is it folded into the main repository, already.)
> 
> Yes, it is in the main v4l-dvb repo now.
> 
Just grabbed and built.  No significant change.  Listing for dmesg
follows.  The driver still took practically forever to load, "i2cdetect
-y 7" still takes forever on timeouts full of "--".

My next move, when I can connect with this friend, will be to plug the
card into one of his machines.  Has anyone else gotten one of these
cards and NEVER tried it with Windows?  I'm wondering if there is some
one-time initialization that the Windows drivers do, or it's still
possible that what I really need is an RMA.
> 
> You're welcome.  Have fun testing.
> 
> Regards,
> Andy

Thanks,
Dale
--------------------------------------------------------------------------
cx18:  Start initialization, version 1.0.1
cx18-0: Initializing card #0
cx18-0: Autodetected Hauppauge card
cx18-0 info: base addr: 0xd0000000
cx18-0 info: Enabling pci device
ACPI: PCI Interrupt 0000:05:08.0[A] -> Link [APC3] -> GSI 18 (level,
low) -> IRQ 18
cx18-0: Unreasonably low latency timer, setting to 64 (was 32)
cx18-0 info: cx23418 (rev 0) at 05:08.0, irq: 18, latency: 64, memory:
0xd0000000
cx18-0 info: attempting ioremap at 0xd0000000 len 0x04000000
cx18-0: cx23418 revision 01010000 (B)
cx18-0 info: GPIO initial dir: 0000ffff/0000ffff out: 00000000/00000000
cx18-0 info: activating i2c...
cx18-0 i2c: i2c init
cx18-0 info: Active card count: 1.
tveeprom 6-0050: Hauppauge model 74041, rev C6B2, serial# 3334244
tveeprom 6-0050: MAC address is 00-0D-FE-32-E0-64
tveeprom 6-0050: tuner model is TCL M2523_5N_E (idx 112, type 50)
tveeprom 6-0050: TV standards NTSC(M) (eeprom 0x08)
tveeprom 6-0050: audio processor is CX23418 (idx 38)
tveeprom 6-0050: decoder processor is CX23418 (idx 31)
tveeprom 6-0050: has no radio, has IR receiver, has IR transmitter
cx18-0: Autodetected Hauppauge HVR-1600
cx18-0 info: NTSC tuner detected
cx18-0: VBI is not yet supported
cx18-0 info: Loaded module tuner
cx18-0 info: Loaded module cs5345
cx18-0 i2c: i2c client register
cx18-0 i2c: i2c client register
cs5345 6-004c: chip found @ 0x98 (cx18 i2c driver #0-0)
cx18-0 info: Allocate encoder MPEG stream: 63 x 32768 buffers (2016kB total)
cx18-0 info: Allocate TS stream: 32 x 32768 buffers (1024kB total)
cx18-0 info: Allocate encoder YUV stream: 16 x 131072 buffers (2048kB total)
cx18-0 info: Allocate encoder PCM audio stream: 63 x 16384 buffers
(1008kB total)
cx18-0: Disabled encoder IDX device
cx18-0: Registered device video1 for encoder MPEG (2 MB)
DVB: registering new adapter (cx18)
MXL5005S: Attached at address 0x63
DVB: registering frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
cx18-0: DVB Frontend registered
cx18-0: Registered device video32 for encoder YUV (2 MB)
cx18-0: Registered device video24 for encoder PCM audio (1 MB)
cx18-0: Initialized card #0: Hauppauge HVR-1600
cx18:  End initialization


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
