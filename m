Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp124.rog.mail.re2.yahoo.com ([206.190.53.29]:35690 "HELO
	smtp124.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750769AbZAYSLD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Jan 2009 13:11:03 -0500
Message-ID: <497CAB2F.7080700@rogers.com>
Date: Sun, 25 Jan 2009 13:10:55 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901182241.10047.hverkuil@xs4all.nl> <4973BD03.4060702@rogers.com> <200901190853.19327.hverkuil@xs4all.nl>
In-Reply-To: <200901190853.19327.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi, sorry for the delay

Hans Verkuil wrote:
> On Monday 19 January 2009 00:36:35 CityK wrote:  
>> Hans Verkuil wrote:    
>>> Shouldn't there be a tda9887 as well? It's what the card config says,
>>> but I'm not sure whether that is correct.
>> The Philips TUV1236D NIM does indeed use a tda9887  (I know, because I
>> was the one who discovered this some four years ago (pats self on
>> head)).  But the module is not loading.  I can make it load, just as
>> Hermann demonstrated to Mike in one of the recent messages for this
>> thread.
>>     
>
> I have no idea why the tda9887 isn't loading. It loads fine for my empress 
> card. Does someone know if there is something special about this? And how 
> do you manage to make analog TV work if the tda9887 isn't found? That's 
> rather peculiar.
>
> .....
>
>
> To clarify: you should see this in the dmesg output if there is a tda9887:
>
> ...
> saa7133[0]: i2c eeprom f0: 42 54 56 30 30 30 30 ff ff ff ff ff ff ff ff ff
> tuner 1-0043: chip found @ 0x86 (saa7133[0])
> tda9887 1-0043: creating new instance
> tda9887 1-0043: tda988[5/6/7] found
> ^^^^^^^^^^^^^^^

Mauro Carvalho Chehab wrote:
> Probably, it has something to do with the i2c gate control.
> ....
> From what I got from the sources, nxt200x has an i2c gate. For accessing the
> tuner, the gate needs to be opened. Maybe we need to close the gate in order to
> access tda9887.
>
> Unfortunately, I don't have nxt200x datasheet. Things would be clearer with the docs.
>   

hermann pitton wrote:
> in my case on the md7134 cards it happens only after cold boot.
> Analog of course doesn't work then.
>
> To reload the saa7134 with "modprobe" then is also enough to get it
> loaded and analog functional, likely what Mike meant.
>
> On warm reboots it is present and functional. Some eeprom readout
> corruption mostly on the first card occurs and I must force card=12.
>
> The tda9887 is by default not visible on the FMD1216ME MK3 hybrid.
>
> The init from Hartmut in tuner-core.c in set_tuner_type for analog.
>
> 	case TUNER_PHILIPS_FMD1216ME_MK3:
> 		buffer[0] = 0x0b;
> 		buffer[1] = 0xdc;
> 		buffer[2] = 0x9c;
> 		buffer[3] = 0x60;
> 		i2c_master_send(c, buffer, 4);
> 		mdelay(1);
> 		buffer[2] = 0x86;
> 		buffer[3] = 0x54;
> 		i2c_master_send(c, buffer, 4);
> 		if (!dvb_attach(simple_tuner_attach, &t->fe,
> 				t->i2c->adapter, t->i2c->addr, t->type))
> 			goto attach_failed;
> 		break;
>
> from dmesg.
>
> dmesg |grep "< c2"
> saa7133[1]: i2c xfer: < c2 30 90 >
> saa7134[3]: i2c xfer: < c2 >
> saa7134[3]: i2c xfer: < c2 0b dc 9c 60 >
> saa7134[3]: i2c xfer: < c2 0b dc 86 54 >
>
> Exactly here, when the buffers are sent the second time the tda9887
> becomes the first time visible on the bus. According to Hartmut the
> modification of buffer[3] from 0x60 to 0x54 is that hidden switch,
> IIRC. 
>
> saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
> saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
> saa7134[3]: i2c xfer: < c2 1b 6f 86 52 >
> saa7134[3]: i2c xfer: < c2 9c 60 85 54 >
> saa7134[0]: i2c xfer: < c2 9c 60 85 54 >
> saa7133[1]: i2c xfer: < c2 30 90 >
> saa7134[3]: i2c xfer: < c2 9c 60 85 54 >
>   

I believe Mauro is correct in regards to the tda9887 in that, within the
Philips TUV1236D NIM, it is behind the Nxt2004's i2c gate.  After
re-reading what Michael mentioned previously:
> tda9887 is now a sub-module of tuner-core.  tda9887, when modprobed
> alone, will not attach to any actual device without also having
> tuner.ko loaded in memory.  tda9887 is a separate module, but its
> interface is currently only accessed via tuner-core (tuner.ko) 
I believe that even in the case where I modprobe the tda9887 (such as
how Hermann demonstrated) and get the module to load, it is not
effectively attaching to the device.  So, this still begs Han's
question:  "how do you manage to make analog TV work if the tda9887
isn't found? That's rather peculiar."  I don't have an answer for that. 
The tuner-simple module, however, seems to be able to drive/provide that
functionality sufficiently enough.  Perhaps Michael can shed more light
on this.

In any regard, if anyone is interested, you can observe the internal
layout of the NIM from this Anandtech pic (warning, large image) :
http://images.anandtech.com/reviews/video/ATI/hdtvwonder/tuner.jpg   As
would happen to be the case, the labelling on the tda9887 gets washed
out in the photo, however, one can surmise from the shadow that the
insignia is the Philips badge and, with a good monitor, you can actually
make out "TDA" on the top line of print.


Mauro Carvalho Chehab wrote:
>
> CityK wrote:  
>> Note:  users have reported different default configurations in the past
>> (e.g. http://www.mythtv.org/wiki/Kworld_ATSC_110), but I actually doubt
>> that there has been any manufacturing difference with the TUV1236D. 
>> Rather, I suspect that the user experiences being reported are just
>> reflecting a combination of the different states of how our driver
>> behaved in the past and differences in driver version that they may have
>> been using (i.e. that version provided by/within their distro or by our
>> Hg).  After all, this configuration setting has gone from being handled
>> by saa7134-dvb.c to dvb-pll.c to tuner-simple.c, with changes in the
>> behaviour implemented along the way.
> The issue doesn't seem to be related to TUV1236D, but, instead with nxt200x.
> The i2c command to enable the tuner is sent to nxt200x. If there are any
> ATSC110 variant with a different demod (maybe a different version of nxt200x?),
> then the users may experience different behaviors.

Different demod? -- No, I'm pretty sure that the NIM exclusively uses
the Nxt2004. 
Different revision of the Nxt2004? -- I'd say its quite logical to
suspect that there have been a couple of fabrication spins of the demod
... it is, after all, several years old.  However, although possible, I
don't think a different revision explains the case here.  Rather, as
described above, I just think that it's a case of apples to oranges
comparisons; user experiences that reflect different snapshots of time
and driver revisions.

Though, although unlikely, another thought I have on this is the
possibility of a situation akin to a switch for railway tracks ....
especially if the user first employs the card under Windows -- my
thought is perhaps the Windows driver configures a hard routing pathway.

Anyway, there is, coincidently, a similar analogue-less variant of the
NIM, the TU1236.  As one user reports
(http://marc.info/?l=linux-dvb&m=122314219031405&w=2) it can be found on
the "VE" version of the HDTV wonder.  I believe that the TU1236 is also
differentiated from the TUV1236D by its use of the Nxt2003, as opposed
to the Nxt2004 in the later.

Hans Verkuil wrote:

> CityK wrote:
>> In regards to the tuner type being set twice, that is precisely my point
>> -- its peculiar and not symptomatic of normal behaviour.  That is why I
>> asked whether you expected it to do this    
>
> I think it is OK. The second setup is probably done by dvb_attach() in 
> saa7134-dvb.c, line 1191. Can you verify that with a debug message?  

Could not verify.  (dmesg output provided below at end).


Mauro Carvalho Chehab wrote:
>
> Please test the enclosed patch. It adds a proper gate_ctrl callback at saa7134
> core, and initializes it for ATSC110. 
>
> The gate_ctrl is close to what we currently have on cx88 driver, however with a
> simpler implementation. We'll likely need to improve it, moving the i2c gate
> control into nxt200x, adding the i2c close commands, and putting the gate_ctrl
> initialization into saa7134-dvb.
>
> You should notice that we don't know how to close the gate. So, the code is
> still a workaroud.. However, to properly implement it, we need the help
> of someone with the datasheets.
>
>   
>>> Someone with a better knowledge
>>> of this driver and these tuners should review the saa7134_board_init2()
>>> function and move the opening of tuner gate/muxes to a separate function.     
>
> This should be needed to do per board. The issue here is that we need to know
> the i2c open and close cmds.
>   

Mauro, your patch applied cleanly against mainline.  (But not against
Hans' KWorld test repo; though I don't think you meant/intended for it
to be applied against that anyway).
However, analogue TV functionality still is inoperative.   (dmesg output
provided below at end).


Mauro Carvalho Chehab wrote:
> Hans Verkuil wrote:
>> Note that Mauro merged my saa7134 changes, so these are now in the master 
>> repository.
>>     
> Yes. We need to fix it asap, to avoid regressions. It is time to review also
> the other codes that are touching on i2c gates at _init2().
>   

Thoughts on merging the changes from Hans' KWorld repo? 


----------------------------------------------------------------------------------------------------

And now, some observations:

[1] Hans KWorld repo:

A)
modprobe -r saa7134-dvb
modprobe -r tuner
modprobe saa7134 i2c_scan=1
dmesg:

tuner-simple 1-0061: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32, mmio:
0xfa021000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
[card=90,autodetected]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x14  [???]
saa7133[0]: i2c scan: found device @ 0x16  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
tuner 1-0061: chip found @ 0xc2 (saa7133[0])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
nxt200x: NXT2004 Detected
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
nxt2004: Waiting for firmware upload(2)...
nxt2004: Firmware upload complete


B)
modprobe -r saa7134-dvb
modprobe -r tuner
modprobe saa7134 i2c_debug=1
dmesg:

tuner-simple 1-0061: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32, mmio:
0xfa021000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
[card=90,autodetected]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c xfer: < a0 00 >
saa7133[0]: i2c xfer: < a1 =de =17 =50 =73 =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff
=ff =ff =ff =ff =ff =ff =ff =ff =ff =ff =ff >
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 84 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 86 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 94 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < 96 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c0 ERROR: NO_DEVICE
saa7133[0]: i2c xfer: < c2 >
tuner 1-0061: chip found @ 0xc2 (saa7133[0])
tuner i2c attach [addr=0x61,client=]
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c3 =7c >
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c2 1b 6f ce 02 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c2 1b 6f ce 02 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c2 1b 6f ce 02 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c2 1b 6f ce 02 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 10 12 ><6>dvb_init() allocating 1 frontend

saa7133[0]: i2c xfer: < 14 00 [fd quirk] < 15 =05 =02 =09 =20 =01 >
nxt200x: NXT2004 Detected
saa7133[0]: i2c xfer: < c3 =7c >
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
saa7133[0]: i2c xfer: < 14 1e 00 >
nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < c2 1b 6f ce 02 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 17 00 >
nxt2004: Waiting for firmware upload(2)...
saa7133[0]: i2c xfer: < 14 2b 80 >
saa7133[0]: i2c xfer: < 14 29 10 00 81 >
saa7133[0]: i2c xfer: < 14 2c 02 29 85 90 ff 21 e0 30 e5 1c 90 35 fe 74
01 f0 a3 e4 f0 7e 36 7f 00 12 2f 1d 90 ff 21 e0 54 df f0 7f 08 12 30 b0
22 00 00 00 00 02 33 cc c2 20 e4 ff 12 28 fd 7f 01 12 31 21 90 ff 08 e0
44 07 f0 e0 54 f8 f0 e4 ff 02 31 21 00 02 35 59 75 55 02 75 56 e4 e5 56
15 56 70 02 15 55 e5 56 45 55 70 f2 22 02 31 a6 02 12 a8 e8 64 80 f8 e9
33 e8 33 60 11 04 60 f0 ed 33 ec 33 70 09 e8 fc e9 fd ea fe eb ff 22 04
60 de d3 eb 9f ea 9e e9 9d e8 c2 e7 8c f0 c2 f7 95 f0 40 0c e8 cc f8 e9
cd f9 ea ce fa eb cf fb 12 12 73 85 d0 f0 58 04 70 03 20 d5 b3 e8 04 70
07 50 02 b2 d5 02 12 b2 92 d5 ec 04 60 f7 e4 cc c0 e0 c3 98 f8 60 3b 94
18 60 08 40 0d d0 e0 fb 02 12 8a e4 fb fa c9 fc 80 28 e8 30 e4 06 e4 c9
fb e4 ca fc e8 30 e3 05 e4 c9 ca cb fc e8 54 07 60 10 f8 c3 e9 13 f9 ea 13 >
saa7133[0]: i2c xfer: < 14 2c fa eb 13 fb ec 13 fc d8 f1 30 f5 2f c3 e4
9c fc ef 9b ff ee 9a fe ed 99 fd d0 e0 fb ef 4e 4d 4c 70 12 22 db 03 02
12 af ec 2c fc ef 33 ff ee 33 fe ed 33 fd ed 30 e7 eb 02 12 8a ef 2b ff
ee 3a fe ed 39 fd d0 e0 fb 50 13 0b bb 00 03 02 12 b2 ed 13 fd ee 13 fe
ef 13 ff ec 13 fc 02 12 8a 02 12 b2 ec 5d 04 60 05 e8 59 04 70 03 02 12
a8 12 12 73 58 04 60 f6 ec 48 60 f2 ec 70 04 fd fe ff 22 c8 60 db 24 81
c8 50 09 c3 98 60 02 50 06 02 12 af 98 50 ca f5 82 e9 29 4b 4a 70 05 ab
82 02 12 9e 75 f0 00 7c 1a 78 80 c3 ef 9b ee 9a ed 99 40 0d c3 ef 9b ff
ee 9a fe ed 99 fd e8 42 f0 dc 23 ac f0 d0 e0 ff d0 e0 fe d0 e0 fd ab 82
20 e7 10 1b eb 60 ba ec 2c fc ef 33 ff ee 33 fe ed 33 fd 02 12 8a e8 03
f8 30 e7 05 c0 f0 75 f0 00 ef 2f ff ee 33 fe ed 33 fd 40 b8 30 e7 c2 80 aa >
saa7133[0]: i2c xfer: < 14 2c 75 f0 20 80 0e 75 f0 10 80 05 75 f0 08 7d
00 7e 00 7f 00 33 92 d5 30 d5 03 12 13 12 ec 33 40 10 ef 33 ff ee 33 fe
ed 33 fd ec 33 fc d5 f0 ed 22 e5 f0 24 7e a2 d5 13 cc 92 e7 cd ce ff 22
ed d2 e7 cd 33 ec 33 92 d5 24 81 40 06 e4 ff fe fd fc 22 fc e4 cf ce cd
cc 24 e0 50 11 74 ff 80 ed c3 cc 13 cc cd 13 cd ce 13 ce cf 13 cf 04 70
f0 30 d5 de 02 13 12 e9 d2 e7 c9 33 e8 33 f8 92 d5 ed d2 e7 cd 33 ec 33
fc 50 02 b2 d5 22 ec 30 e7 10 0f bf 00 0c 0e be 00 08 0d bd 00 04 0b eb
60 14 a2 d5 eb 13 fc ed 92 e7 fd 22 74 ff fc fd fe ff 22 e4 80 f8 a2 d5
74 ff 13 fc 7d 80 e4 80 ef bc 00 0b be 00 29 ef 8d f0 84 ff ad f0 22 e4
cc f8 75 f0 08 ef 2f ff ee 33 fe ec 33 fc ee 9d ec 98 40 05 fc ee 9d fe
0f d5 f0 e9 e4 ce fd 22 ed f8 f5 f0 ee 84 20 d2 1c fe ad f0 75 f0 08 ef 2f >
saa7133[0]: i2c xfer: < 14 2c ff ed 33 fd 40 07 98 50 06 d5 f0 f2 22 c3
98 fd 0f d5 f0 ea 22 c3 e4 9f ff e4 9e fe e4 9d fd e4 9c fc 22 ec f0 a3
ed f0 a3 ee f0 a3 ef f0 22 a8 82 85 83 f0 d0 83 d0 82 12 13 43 12 13 43
12 13 43 12 13 43 e4 73 e4 93 a3 c5 83 c5 f0 c5 83 c8 c5 82 c8 f0 a3 c5
83 c5 f0 c5 83 c8 c5 82 c8 22 8a 83 89 82 e4 73 c9 ef c9 8c 0e 8d 0f 8a
10 8b 11 90 ff ab e0 f5 0b 90 ff 0a e0 33 92 34 30 34 11 e9 64 03 60 0c
e9 60 09 85 0f 82 85 0e 83 e4 f0 22 c2 33 75 0a 7c e9 b4 07 00 40 03 02
14 35 90 13 a4 f8 28 28 73 02 13 b9 02 13 df 02 13 ec 02 13 f7 02 14 16
02 14 21 02 14 2c e4 f5 08 75 09 0a 30 34 07 75 0a 20 d2 33 80 6c e5 0b
30 e5 05 75 0a 20 80 03 75 0a 3d e5 0b 20 e6 5a d2 33 80 56 75 08 20 75
09 3e d2 33 75 0a 20 80 49 75 08 40 75 09 4e 75 0a 20 80 3e 75 08 50 75 09 >
saa7133[0]: i2c xfer: < 14 2c 5e 30 34 07 75 0a 3c d2 33 80 2e e5 0b 30
e4 05 75 0a 40 80 24 75 0a 7c 80 1f 75 08 60 75 09 66 75 0a 5c 80 14 75
08 68 75 09 6a 75 0a 7c 80 09 75 08 6c 75 09 6e 75 0a 7c 30 33 0d e5 0a
25 e0 25 e0 f5 0b 43 0a 80 80 06 e5 0a 25 e0 f5 0b ad 0b af 11 ae 10 12
35 17 85 0f 82 85 0e 83 e5 0a f0 e9 60 03 02 15 10 e5 08 d3 95 09 40 03
02 15 10 e5 08 44 80 90 ff b1 f0 75 0c ff 75 0d b4 75 0a 04 85 0d 82 85
0c 83 e0 f5 0b 05 0d e5 0d 70 02 05 0c 30 33 1c e5 0b 25 e0 f5 0b 30 34
07 e5 08 d3 94 08 50 0a 20 34 09 e5 0a d3 94 02 50 02 05 0b e5 0b 25 e0
f5 0b 85 0d 82 85 0c 83 e0 ff e5 11 25 0b f5 82 e4 35 10 f5 83 ef f0 05
0d e5 0d 70 02 05 0c f5 82 85 0c 83 e0 ff e5 11 25 0b f5 82 e4 35 10 f5
83 a3 ef f0 05 0d e5 0d 70 02 05 0c 15 0a e5 0a 70 8a 05 08 05 08 20 34 03 >
saa7133[0]: i2c xfer: < 14 2c 02 14 63 e5 08 64 08 60 03 02 14 63 75 08
10 75 09 16 02 14 63 e9 64 01 60 03 02 15 95 e5 08 d3 95 09 50 76 e5 08
44 80 90 ff b1 f0 75 0c ff 75 0d b4 e5 08 24 e0 25 e0 25 e0 f5 0b e5 08
30 e1 06 74 fa 25 0b f5 0b 75 0a 04 05 0d e5 0d 70 02 05 0c f5 82 85 0c
83 e0 ff e5 11 25 0b f5 82 e4 35 10 f5 83 ef f0 05 0d e5 0d 70 02 05 0c
f5 82 85 0c 83 e0 ff e5 11 25 0b f5 82 e4 35 10 f5 83 a3 ef f0 05 0d e5
0d 70 02 05 0c 74 04 25 0b f5 0b d5 0a b6 05 08 05 08 80 83 e9 c3 94 02
50 03 02 16 2b e5 08 d3 95 09 40 03 02 16 2b e5 08 44 80 90 ff b1 f0 75
0c ff 75 0d b4 e4 f5 0a 85 0d 82 85 0c 83 e0 f5 0b 05 0d e5 0d 70 02 05
0c 30 34 03 63 0b 01 b9 02 0a e5 08 24 c0 25 e0 25 0a f5 0b e5 0b 25 e0
f5 0b 85 0d 82 85 0c 83 e0 ff e5 11 25 0b f5 82 e4 35 10 f5 83 ef f0 05 0d >
saa7133[0]: i2c xfer: < 14 2c e5 0d 70 02 05 0c f5 82 85 0c 83 e0 ff e5
11 25 0b f5 82 e4 35 10 f5 83 a3 ef f0 05 0d e5 0d 70 02 05 0c 05 0a e5
0a b4 04 95 05 08 05 08 02 15 9e 22 7c 24 7d d1 7b ff e4 ff 12 18 8f 90
ff 30 e0 30 e0 03 75 70 20 e5 70 60 03 02 17 ef 90 ff 3f e0 54 f0 f5 70
64 60 70 03 02 16 e7 e4 f5 60 ff 12 2c a0 12 2f b1 e4 f5 70 90 3e 00 e0
ff 7d 01 7c 3e 12 2c 39 c3 ef 94 50 ee 94 00 50 5e 90 3c 00 e0 ff 7d 01
7c 3c 12 2c 39 c3 ef 94 50 ee 94 00 50 1a 90 3b 00 e0 24 b6 ff 7d 95 7c
3b 12 2c 39 c3 ef 94 32 ee 94 00 50 03 75 70 10 90 3d 00 e0 ff 7d 01 7c
3d 12 2c 39 c3 ef 94 50 ee 94 00 50 1a 90 38 00 e0 24 f6 ff 7d 01 7c 38
12 2c 39 c3 ef 94 58 ee 94 02 50 03 43 70 20 e5 70 60 0c 44 02 ff 12 2c
a0 12 2f b1 e4 f5 70 90 ff 3f e0 54 f0 60 05 e0 54 f0 f5 70 e5 70 60 03 02 >
saa7133[0]: i2c xfer: < 14 2c 17 ef 75 70 30 90 3d 00 e0 ff 7d 01 7c 3d
12 2c 39 d3 ef 94 c8 ee 94 00 50 15 90 3e 00 e0 ff 7d 01 7c 3e 12 2c 39
d3 ef 94 c8 ee 94 00 40 06 75 70 50 02 17 ef 90 38 00 e0 ff 7d 01 7c 38
12 2c 39 c3 ef 94 c8 ee 94 00 50 73 90 3a 00 e0 ff 7d 01 7c 3a 12 2c 39
c3 ef 94 2c ee 94 01 50 5e 90 3b 00 e0 ff 7d 01 7c 3b 12 2c 39 c3 ef 94
c8 ee 94 00 50 49 90 3c 00 e0 ff 7d 01 7c 3c 12 2c 39 c3 ef 94 64 ee 94
00 50 34 90 3e 00 e0 ff 7d 01 7c 3e 12 2c 39 ee c0 e0 ef c0 e0 90 3d 00
e0 ff 7d 01 7c 3d 12 2c 39 d0 e0 2f ff d0 e0 3e fe c3 ef 94 64 ee 94 00
50 05 75 70 40 80 39 90 38 00 e0 ff 7d 01 7c 38 12 2c 39 d3 ef 94 f4 ee
94 01 40 05 75 70 10 80 1f 90 3a 00 e0 24 e5 ff 7d 01 7c 3a 12 2c 39 d3
ef 94 c8 ee 94 00 40 08 7f 32 12 2c a0 75 70 40 e5 70 24 e0 60 65 24 f0 60 >
saa7133[0]: i2c xfer: < 14 2c 42 24 f0 60 31 24 e0 60 47 24 10 70 73 90
ff a6 e0 fe a3 e0 c3 94 44 ee 94 02 50 0d 7c 2d 7d fa 7b ff e4 ff 12 18
8f 80 57 7c 2d 7d ed 7b ff e4 ff 12 18 8f 80 4a 7c 2e 7d 07 7b ff e4 ff
12 18 8f 80 3d 7c 2e 7d 17 7b ff e4 ff 12 18 8f 80 30 7f 32 12 2c a0 7c
2e 7d 07 7b ff e4 ff 12 18 8f 80 1e 7c 24 7d d1 7b ff e4 ff 12 18 8f 7f
01 12 2c a0 7c 2d 7d ca 7b ff e4 ff 12 18 8f 75 60 01 90 ff 3f e0 54 f0
f0 e0 ff e5 70 c4 54 0f fe ef 4e f0 7f 01 02 32 54 8f 66 8c 5b 8d 5c 8b
5d e5 5d 70 03 02 1a 65 85 5c 82 85 5b 83 e0 ff 54 1f f5 5a ef 54 e0 24
e0 70 03 02 19 ea 24 a0 60 76 24 e0 70 03 02 19 44 24 e0 70 03 02 19 9a
24 80 60 03 02 1a 65 05 5c e5 5c 70 02 05 5b e5 66 60 12 85 5c 82 85 5b
83 e0 24 00 f5 58 e4 34 fe f5 57 80 10 85 5c 82 85 5b 83 e0 24 00 f5 58 e4 >
saa7133[0]: i2c xfer: < 14 2c 34 ff f5 57 05 5c e5 5c 70 02 05 5b e5 5a
70 03 02 1a 60 85 5c 82 85 5b 83 e0 f5 59 85 58 82 85 57 83 f0 05 5c e5
5c 70 02 05 5b 05 58 e5 58 70 02 05 57 15 5a 80 d5 e5 5a 60 07 12 10 4e
15 5a 80 f5 05 5c e5 5c 70 02 05 5b 02 1a 60 05 5c e5 5c 70 02 05 5b e5
66 60 12 85 5c 82 85 5b 83 e0 24 00 f5 58 e4 34 fe f5 57 80 10 85 5c 82
85 5b 83 e0 24 00 f5 58 e4 34 ff f5 57 e5 5a 60 19 05 5c e5 5c 70 02 05
5b f5 82 85 5b 83 e0 85 58 82 85 57 83 f0 15 5a 80 e3 05 5c e5 5c 70 02
05 5b 02 1a 60 05 5c e5 5c 70 02 05 5b e5 66 60 12 85 5c 82 85 5b 83 e0
24 00 f5 58 e4 34 fe f5 57 80 10 85 5c 82 85 5b 83 e0 24 00 f5 58 e4 34
ff f5 57 e5 5a 60 14 85 58 82 85 57 83 e4 f0 05 58 e5 58 70 02 05 57 15
5a 80 e8 05 5c e5 5c 70 7a 05 5b 80 76 05 5c e5 5c 70 02 05 5b e5 66 60 12 >
saa7133[0]: i2c xfer: < 14 2c 85 5c 82 85 5b 83 e0 24 00 f5 58 e4 34 fe
f5 57 80 10 85 5c 82 85 5b 83 e0 24 00 f5 58 e4 34 ff f5 57 e5 5a 60 3c
85 58 82 85 57 83 e0 f5 59 05 5c e5 5c 70 02 05 5b f5 82 85 5b 83 e0 52
59 05 5c e5 5c 70 02 05 5b f5 82 85 5b 83 e0 45 59 85 58 82 85 57 83 f0
05 58 e5 58 70 02 05 57 15 5a 80 c0 05 5c e5 5c 70 02 05 5b 15 5d 02 18
97 22 90 ff 22 e0 f5 21 30 0f 18 30 2c 03 02 1b c7 d2 2c 12 10 2e d2 2b
12 35 61 90 ff 31 e0 44 10 f0 22 c2 2c 90 ff 31 e0 54 ef f0 90 ff 30 e0
54 03 f5 64 20 2b 07 65 5f 70 03 02 1b 45 c2 2b 12 10 2e d2 20 e5 64 60
65 14 60 62 24 fe 60 32 04 60 03 02 1b 3c 90 35 e6 74 ff f0 a3 74 34 f0
a3 74 e7 f0 90 35 e3 74 ff f0 a3 74 33 f0 a3 74 96 f0 90 35 e0 74 ff f0
a3 74 26 f0 a3 74 1e f0 80 56 90 35 e6 74 ff f0 a3 74 34 f0 a3 74 f7 f0 90 >
saa7133[0]: i2c xfer: < 14 2c 35 e3 74 ff f0 a3 74 33 f0 a3 74 b1 f0 90
35 e0 74 ff f0 a3 74 21 f0 a3 74 8a f0 80 2a 90 35 e6 74 ff f0 a3 74 34
f0 a3 74 d5 f0 90 35 e3 74 ff f0 a3 74 16 f0 a3 74 2c f0 90 35 e0 74 ff
f0 a3 74 20 f0 a3 74 9e f0 d2 17 c2 16 c2 15 85 64 5f 30 17 0f 7f 01 12
31 21 90 35 e6 12 31 15 c2 17 d2 16 30 16 26 20 0e 23 7f 01 12 31 21 90
35 e3 12 31 15 c2 16 d2 15 d2 2d 90 ff 31 e0 f5 5e 53 5e fc e5 60 54 03
42 5e e5 5e f0 30 15 31 20 0d 29 90 35 e0 e0 a3 e0 fa a3 e0 f9 12 13 5d
8f 63 e5 63 70 0a c2 15 7f 03 12 28 fd 12 10 2e e5 63 b4 01 0c 7f 02 12
28 fd 80 05 7f 01 12 28 fd 20 17 10 20 16 0d 20 15 0a 20 0c 07 7f 02 12
32 54 d2 17 22 90 ff 21 e0 20 e7 03 02 1d 1f 90 ff 34 e0 54 f0 f5 72 e0
54 0f f5 71 90 ff 21 e0 54 f7 f0 e5 72 24 f0 60 6e 24 f0 60 77 24 f0 70 03 >
saa7133[0]: i2c xfer: < 14 2c 02 1c 7e 24 f0 70 03 02 1c d2 24 f0 70 03
02 1c e8 24 f0 70 03 02 1d 02 24 f0 70 03 02 1d 07 24 70 60 03 02 1d 0c
90 ff 35 e0 30 e0 1b e0 ff 7b 36 7a ff ad 71 12 30 76 ef 70 03 02 1d 13
90 ff 21 e0 44 08 f0 02 1d 13 90 ff 35 e0 ff 7b 36 7a ff ad 71 12 31 d4
ef 70 03 02 1d 13 90 ff 21 e0 44 08 f0 02 1d 13 90 ff 35 e0 f5 47 a3 e0
f5 46 02 1d 13 90 ff 35 e0 24 00 ff e4 34 ff fe ab 71 7d 36 7c ff 12 34
2e 02 1d 13 75 73 36 90 ff 35 e0 f5 74 e5 71 70 03 02 1d 13 e4 25 73 ff
e4 34 ff 8f 82 f5 83 e0 f5 72 e5 74 b4 08 0b 53 72 f8 90 ff 08 e0 54 07
42 72 e5 74 b4 09 0b 53 72 f9 90 ff 09 e0 54 06 42 72 e4 25 74 ff e4 34
ff 8f 82 f5 83 e5 72 f0 05 73 05 74 15 71 80 b5 90 ff 35 e0 24 00 ff e4
34 fe fe ab 71 7d 36 7c ff 12 34 2e 80 2b 90 ff 35 e0 24 00 ff e4 34 fe fe >
saa7133[0]: i2c xfer: < 14 2c cd ef cd fc ab 71 7f 36 7e ff 12 34 2e 80
11 12 2a 0b 80 0c 12 2d 06 80 07 90 ff 21 e0 44 08 f0 90 ff 21 e0 54 7f
f0 7f 10 12 30 b0 22 e5 2d 24 80 70 03 02 1d b4 24 e0 70 03 02 1e 08 24
40 60 03 02 1e 6d 12 33 e5 8f 66 e5 66 d3 95 27 40 06 85 66 27 85 3f 34
05 3f 05 3f c3 e5 3f 64 80 94 90 40 58 e4 f5 33 90 35 f1 e0 54 c0 60 2f
e5 2b d3 94 00 40 0e e5 27 d3 94 5f 40 07 15 2b 75 2d 80 80 1d e5 2b c3
94 03 50 0e e5 27 c3 94 46 50 07 05 2b 75 2d 80 80 08 75 2d a0 80 03 75
2d a0 e5 2d b4 80 05 85 34 3f 80 11 85 3f 3e e5 34 70 05 75 3f 0f 80 05
e5 34 14 f5 3f 75 3d 04 02 1e 6d 12 33 e5 8f 66 05 33 e5 33 c3 94 02 50
11 e5 2b 94 00 40 0b e5 66 d3 94 5f 40 04 15 2b 80 30 e5 33 c3 94 02 50
12 e5 2b c3 94 03 50 0b e5 66 c3 94 46 50 04 05 2b 80 17 85 3f 3e e5 34 70 >
saa7133[0]: i2c xfer: < 14 2c 05 75 3f 0f 80 05 e5 34 14 f5 3f e4 f5 33
75 2d a0 75 3d 04 80 65 12 24 1d d3 ef 95 2a ee 95 29 40 07 8e 29 8f 2a
85 3f 3e 05 33 e5 33 c3 94 03 50 0f 05 3f e5 3f b4 10 03 e4 f5 3f 75 3d
04 80 3a 85 3e 3f 78 82 e6 90 ff 46 f0 78 7f e6 90 ff 42 f0 08 e6 ff 08
e6 90 ff 5c cf f0 a3 ef f0 90 ff 22 e5 32 f0 e4 f5 2d 53 28 fd 75 36 01
75 37 45 85 3f 35 f5 3a f5 30 75 3d 0a 02 2a 82 8c 65 8d 66 8f 82 8e 83
e4 f5 67 f5 68 f5 69 75 6a 40 74 9e f0 7d 78 af 66 ae 65 12 35 17 e4 ff
fe 90 fe 72 ef f0 a3 e0 fd 05 68 e5 68 aa 67 70 02 05 67 14 25 66 f5 82
e5 65 3a f5 83 ed f0 90 fe 74 e0 fd 05 68 e5 68 aa 67 70 02 05 67 14 25
66 f5 82 e5 65 3a f5 83 ed f0 90 fe 75 e0 fd 05 68 e5 68 aa 67 70 02 05
67 14 25 66 f5 82 e5 65 3a f5 83 ed f0 90 fe 76 e0 fd 05 68 e5 68 aa 67 70 >
saa7133[0]: i2c xfer: < 14 2c 02 05 67 14 25 66 f5 82 e5 65 3a f5 83 ed
f0 74 10 2f ff e4 3e fe d3 ef 94 f0 ee 64 80 94 80 50 03 02 1e 91 e4 fe
ff 90 fe 72 ef f0 90 fe 77 e0 fd 05 6a e5 6a aa 69 70 02 05 69 14 25 66
f5 82 e5 65 3a f5 83 ed f0 90 fe 78 e0 fd 05 6a e5 6a aa 69 70 02 05 69
14 25 66 f5 82 e5 65 3a f5 83 ed f0 90 fe 79 e0 fd 05 6a e5 6a aa 69 70
02 05 69 14 25 66 f5 82 e5 65 3a f5 83 ed f0 90 fe 7a e0 fd 05 6a e5 6a
aa 69 70 02 05 69 14 25 66 f5 82 e5 65 3a f5 83 ed f0 0f bf 00 01 0e ef
64 10 4e 70 84 22 cd eb cd cc ea cc 8c 51 8d 52 90 ff 90 74 18 f0 e4 f5
4d f5 4e f5 4f f5 50 c3 e5 4d 94 01 40 0b e4 25 4e f5 4e 74 ff 35 4d f5
4d e5 4e 24 40 f5 4c e4 35 4d f5 4b c3 94 01 40 0b e4 25 4c f5 4c 74 ff
35 4b f5 4b c3 e5 50 94 0c e5 4f 94 00 50 0e ae 50 ee 24 31 90 ff b0 f0 a3 >
saa7133[0]: i2c xfer: < 14 2c ee f0 80 08 e5 50 24 14 90 ff b1 f0 d3 e5
4c 94 80 e5 4b 94 00 50 10 e5 4c 90 27 5d 93 90 ff b2 f0 a3 74 20 f0 80
18 74 dd 25 4c f5 82 74 26 35 4b f5 83 e4 93 f4 04 90 ff b2 f0 a3 74 2f
f0 d3 e5 4e 94 80 e5 4d 94 00 50 10 e5 4e 90 27 5d 93 90 ff b2 f0 a3 74
60 f0 80 18 74 dd 25 4e f5 82 74 26 35 4d f5 83 e4 93 f4 04 90 ff b2 f0
a3 74 6f f0 ef 25 4e f5 4e e4 35 4d f5 4d 05 50 e5 50 70 02 05 4f 64 2c
45 4f 60 03 02 1f ae 90 ff 90 74 38 f0 12 35 25 90 ff a6 e0 85 52 82 85
51 83 f0 90 ff a7 e0 85 52 82 85 51 83 a3 f0 22 75 66 01 30 2d 4e c2 2d
e4 f5 6d 75 65 64 90 ff 22 e0 20 e7 0e 90 ff 9f e0 54 0c 70 06 12 10 4e
d5 65 eb e5 65 70 0e f5 66 05 6c e5 6c d3 94 02 50 03 e4 f5 70 7f 01 12
25 78 12 35 69 c2 32 e4 f5 6e 90 ff 22 e0 30 e7 03 02 21 87 90 ff f2 e4 f0 >
saa7133[0]: i2c xfer: < 14 2c 02 21 87 20 32 03 02 21 84 c2 32 90 ff 9f
e0 30 e0 31 75 65 19 e5 65 60 0c 12 10 4e 15 65 90 ff 9f e0 20 e0 f0 e5
65 70 1a f5 66 05 6c e5 6d c3 94 32 40 05 e4 f5 6c 80 0a e5 6c d3 94 02
50 03 e4 f5 70 e5 66 64 01 70 4f 05 6e e5 6e d3 94 06 40 37 15 6e e4 ff
12 25 78 ef 70 0b e5 6d c3 94 3c 50 0d 05 6d 80 09 e5 6d d3 94 00 40 02
15 6d ef d3 94 03 40 22 e4 f5 66 e5 6d 94 32 40 05 e4 f5 6c 80 14 75 6c
03 80 0f e5 6e b4 06 0a 7f 01 12 25 78 80 03 75 66 02 af 66 22 30 2d 16
c2 2d 7f 01 12 25 78 12 35 69 c2 32 90 ff ee 74 07 f0 a3 74 98 f0 20 32
03 02 22 6d 90 ff f0 e0 d3 94 40 40 08 90 ff ed 74 1f f0 80 06 90 ff ed
74 a5 f0 c2 32 e4 ff 12 25 78 12 31 46 90 ff a1 e0 54 f3 f5 76 90 ff e3
e0 f5 75 c4 54 0f ff c3 13 04 f5 75 c2 30 c3 e5 78 94 3f e5 77 94 00 50 45 >
saa7133[0]: i2c xfer: < 14 2c 30 2e 3e e5 75 b4 01 0c 43 76 0c 90 ff a2
74 01 f0 a3 e4 f0 e5 75 64 02 60 05 e5 75 b4 03 0a 90 ff a2 74 01 f0 a3
74 80 f0 e5 75 c3 94 04 40 09 90 ff a2 74 01 f0 a3 e4 f0 90 ff a1 e5 76
f0 d2 30 d2 2e 80 19 20 2e 14 43 76 04 90 ff a2 e4 f0 a3 74 80 f0 90 ff
a1 e5 76 f0 d2 30 c2 2e 30 30 07 90 ff 90 e0 44 40 f0 90 ff db e0 20 e1
0d 12 10 4e 90 ff db e0 20 e1 03 7f 00 22 7f 01 22 7f 02 22 90 ff 9f e0
30 e0 10 05 3a e5 3a d3 94 04 40 03 02 2b 66 75 3d 0a 22 e4 f5 3a 90 ff
a1 e0 ff 54 fc f0 90 ff a6 e0 f5 66 a3 e0 f5 67 90 ff a1 ef f0 e5 30 14
60 75 04 60 03 02 23 4a d3 e5 67 94 8d e5 66 94 02 50 2e e5 67 94 45 e5
66 94 01 40 45 74 8d 95 37 cf 74 02 95 36 cf 25 37 cf 35 36 fe ef 78 02
ce c3 13 ce 13 d8 f9 ff d3 e5 67 9f e5 66 9e 40 21 85 66 3b 85 67 3c 85 66 >
saa7133[0]: i2c xfer: < 14 2c 36 85 67 37 85 3f 35 e5 3f 25 2f 54 0f f5
3f 12 2a 82 75 30 01 75 3d 05 22 c3 e5 67 95 37 e5 66 95 36 50 06 85 66
36 85 67 37 75 3d 0a 22 c3 e5 67 95 3c e5 66 95 3b 50 0d 85 66 36 85 67
37 e4 f5 30 75 3d 0a 22 c3 e4 95 2f f5 2f e4 95 2e f5 2e 85 35 3f 12 2a
82 e4 f5 30 75 3d 05 22 21 08 f8 07 21 0a 3f c0 21 08 f8 00 45 66 00 4b
09 89 c4 41 87 00 a2 af 4c 00 41 c4 01 41 c6 30 41 c4 02 41 c6 31 41 c4
03 41 c6 32 41 c4 04 41 c6 33 41 c4 05 41 c6 34 41 c4 06 41 c6 35 41 c4
07 41 c6 36 41 c4 08 41 c6 37 44 b0 1b 05 00 66 41 a1 00 41 90 48 41 a0
c0 00 44 62 61 a8 00 64 41 60 c1 8a 44 62 09 c4 00 0a 8a 44 62 03 e8 00
02 82 41 61 01 41 90 68 81 44 a2 01 80 00 06 41 90 68 9e 94 44 a2 00 80
00 02 41 90 68 94 41 92 58 41 97 48 41 90 68 41 ac 55 42 ad 00 80 8f 41 c0 >
saa7133[0]: i2c xfer: < 14 2c 40 82 41 92 38 41 97 38 41 90 68 85 44 a2
00 80 00 01 41 90 68 85 41 c7 03 41 a1 04 41 90 65 8a 42 ad 04 00 41 ac
77 41 92 28 41 97 28 41 90 65 00 90 35 f4 12 13 2c 00 00 00 00 12 31 77
e4 f5 67 e4 f5 68 e5 68 60 03 b4 40 07 e5 67 25 68 ff 80 08 e5 68 24 1f
c3 95 67 ff 7c 35 7d f2 12 1f 9b 90 35 f4 e0 f8 a3 e0 f9 a3 e0 fa a3 e0
fb e8 c0 e0 e9 c0 e0 ea c0 e0 eb c0 e0 90 35 f2 e0 fc a3 e0 fd e4 12 12
03 c8 ec c8 c9 ed c9 ca ee ca cb ef cb e4 ff fe 7d 80 7c 3f 12 11 61 d0
e0 fb d0 e0 fa d0 e0 f9 d0 e0 f8 12 10 6d 90 35 f4 12 13 20 74 20 25 68
f5 68 c3 94 80 40 87 05 67 e5 67 c3 94 20 50 03 02 24 2d 90 35 f4 e0 f8
a3 e0 f9 a3 e0 fa a3 e0 fb e4 ff fe 7d c8 7c 42 12 11 61 12 12 3c 22 21
08 f8 07 21 0a 3f 00 21 08 f8 00 a2 af 6c 20 41 ab 00 43 b1 35 00 36 43 b1 >
saa7133[0]: i2c xfer: < 14 2c 35 00 70 00 50 77 02 b8 01 88 01 07 01 39
03 9c 02 0a 00 5a 02 3c 21 60 f9 06 00 41 f2 04 8a 44 62 61 a8 00 64 44
6f 61 a8 00 64 21 60 fe 01 8a 44 62 09 c4 00 0a 44 6f 09 c4 00 0a 8a 44
62 03 e8 00 02 85 21 90 9f 60 81 44 a2 00 80 00 00 21 90 bf 40 87 49 92
44 44 44 44 55 55 55 55 55 21 90 bf 40 21 ab f8 06 41 ac 44 42 ad 00 80
8a 41 c0 40 94 44 a2 00 40 00 00 45 96 44 44 44 44 44 21 90 bf 40 8a 41
c7 03 21 90 fd 02 00 ef 60 11 90 ff e8 e0 f5 7a 75 7b 02 e4 f5 79 f5 7a
02 26 14 90 ff e8 e0 f5 7a ff 90 ff 33 e0 2f ff e4 33 fe c3 ef 95 7a 74
80 f8 6e 98 40 06 e0 25 7a f0 80 06 90 ff 33 74 ff f0 e5 7a d3 94 32 40
08 74 03 25 79 f5 79 80 22 e5 7a d3 94 0a 40 06 05 79 05 79 80 15 e5 7a
d3 94 02 40 04 05 79 80 0a e5 7a 70 06 e5 79 60 02 15 79 e5 7a 70 08 e5 7b >
saa7133[0]: i2c xfer: < 14 2c 60 0c 15 7b 80 08 75 7b 02 7f 40 12 32 54
e5 7b 70 05 7f 80 12 32 54 e5 79 c3 94 03 40 07 7f 10 12 32 54 80 05 7f
20 12 32 54 e5 79 30 e7 02 15 79 af 79 22 30 2d 16 c2 2d 7f 01 12 25 78
12 35 69 c2 32 90 ff ee 74 05 f0 a3 74 48 f0 20 32 03 02 26 bd c2 32 90
ff f0 e0 d3 94 40 40 08 90 ff ed 74 1f f0 80 06 90 ff ed 74 a5 f0 e4 ff
12 25 78 12 31 46 90 ff a1 e0 54 f3 f5 76 c2 30 c3 e5 78 94 70 e5 77 94
00 50 10 30 2e 09 a3 74 01 f0 a3 e4 f0 d2 30 d2 2e 80 13 20 2e 0e 43 76
0c 90 ff a2 e4 f0 a3 74 80 f0 d2 30 c2 2e 30 30 0d 90 ff a1 e5 76 f0 90
ff 90 e0 44 40 f0 90 ff db e0 20 e1 0d 12 10 4e 90 ff db e0 20 e1 03 7f
00 22 7f 01 22 7f 02 22 90 ff 22 e0 f5 23 30 1b 15 30 2a 03 02 27 5c d2
2a 12 35 4f d2 28 90 ff 31 e0 44 40 f0 22 c2 2a 90 ff 31 e0 54 bf f0 90 ff >
saa7133[0]: i2c xfer: < 14 2c 30 e0 54 c0 f5 49 20 28 04 65 4a 60 17 c2
28 90 fe 41 e0 f5 41 e4 78 83 f6 08 f6 d2 29 c2 27 85 49 4a d2 23 30 29
0b 12 2d 6a c2 29 d2 27 d2 26 80 2c 30 27 29 20 1a 26 12 2f f4 8f 48 e5
48 70 07 c2 27 7f 03 12 2e ce e5 48 b4 01 05 7f 02 12 2e ce 20 18 09 e5
48 64 02 60 03 12 2e 7c 20 29 12 20 27 0f 20 19 0c 12 35 4f d2 29 90 ff
32 e0 44 08 f0 22 00 03 06 09 0c 10 13 16 19 1c 1f 22 25 28 2b 2e 31 33
36 39 3c 3f 41 44 47 49 4c 4e 51 53 55 58 5a 5c 5e 60 62 64 66 68 6a 6b
6d 6f 70 71 73 74 75 76 78 79 7a 7a 7b 7c 7d 7d 7e 7e 7e 7f 7f 7f 7f 7f
7f 7f 7e 7e 7e 7d 7d 7c 7b 7a 7a 79 78 76 75 74 73 71 70 6f 6d 6b 6a 68
66 64 62 60 5e 5c 5a 58 55 53 51 4e 4c 49 47 44 41 3f 3c 39 36 33 31 2e
2b 28 25 22 1f 1c 19 16 13 10 0c 09 06 03 00 0b 04 34 3a 40 46 4c 52 58 5e >
saa7133[0]: i2c xfer: < 14 2c 16 12 31 77 e4 90 35 f8 f0 a3 f0 a3 f0 a3
f0 f5 53 75 54 02 90 35 fa e0 fe a3 e0 ff c3 74 ff 9f ff 74 ff 9e fe 90
35 f8 e0 fc a3 e0 fd d3 9f ec 9e 40 03 7f 00 22 90 35 fb e0 2d f0 90 35
fa e0 3c f0 e5 54 90 27 de 93 ff 7c 35 7d f8 12 1f 9b 05 54 e5 54 70 02
05 53 90 27 de e4 93 ff c3 e5 54 9f e5 53 94 00 40 ac 90 35 fa e0 fe a3
e0 78 02 c3 33 ce 33 ce d8 f9 ff d3 90 35 f9 e0 9f 90 35 f8 e0 9e 40 03
7f 01 22 7f 00 22 21 08 f8 07 21 0a 3f 80 21 08 f8 00 45 66 00 4f 8a ca
de 41 87 00 a2 af 4c 00 44 b0 1b 05 00 66 41 a1 00 41 90 48 41 a0 c0 00
44 62 61 a8 00 64 41 60 c1 8a 44 62 09 c4 00 0a 8a 44 62 03 e8 00 02 82
41 61 01 41 90 68 81 44 a2 00 80 00 01 41 90 68 91 41 92 48 41 97 58 41
90 68 41 ac 55 42 ad 00 40 8f 41 c0 40 82 41 92 38 41 97 38 41 90 68 85 44 >
saa7133[0]: i2c xfer: < 14 2c a2 00 80 00 01 41 90 68 85 41 c7 03 41 a1
04 41 ac 77 41 90 65 00 c2 21 ef 14 60 0b 14 60 33 24 02 70 31 c2 22 80
2d 90 ff 0a e0 30 e7 19 90 ff d0 e0 30 e3 1f 90 ff db e0 30 e1 18 90 ff
eb e0 30 e1 11 d2 21 80 0d 90 ff 9f e0 20 e0 06 d2 21 80 02 d2 21 30 21
0e 90 ff 31 e0 44 20 f0 7f 04 12 32 54 80 11 90 ff 31 e0 54 df f0 7f 08
12 32 54 7f 80 12 32 54 20 20 08 a2 22 30 21 01 b3 50 1c 90 ff 22 e0 20
e7 15 c2 20 30 21 07 7f 80 12 30 b0 80 05 7f 40 12 30 b0 a2 21 92 22 22
75 81 c0 02 29 c6 02 34 b0 e4 93 a3 f8 e4 93 a3 40 03 f6 80 01 f2 08 df
f4 80 29 e4 93 a3 f8 54 07 24 0c c8 c3 33 c4 54 0f 44 20 c8 83 40 04 f4
56 80 01 46 f6 df e4 80 0b 01 02 04 08 10 20 40 80 90 33 40 e4 7e 01 93
60 bc a3 ff 54 3f 30 e5 09 54 1f fe e4 93 a3 60 01 0e cf 54 c0 25 e0 60 a8 >
saa7133[0]: i2c xfer: < 14 2c 40 b8 e4 93 a3 fa e4 93 a3 f8 e4 93 a3 c8
c5 82 c8 ca c5 83 ca f0 a3 c8 c5 82 c8 ca c5 83 ca df e9 de e7 80 be e4
f5 65 90 ff 35 e0 24 fd 60 18 14 60 2b 24 fe 60 36 14 60 42 24 07 70 4e
e5 28 25 2d 90 ff 36 f0 80 47 e5 28 20 e0 05 75 65 01 80 3d e5 38 90 ff
36 f0 e5 39 a3 f0 80 31 7e 35 7f e9 7b 09 7d 36 7c ff 12 34 2e 80 22 90
ff 36 e4 f0 12 33 e5 90 ff 37 ef f0 80 13 12 24 1d cc ee cc ec 90 ff 36
f0 ef a3 f0 80 03 75 65 01 e5 65 b4 01 07 90 ff 21 e0 44 08 f0 22 e5 3f
54 0f ff a2 e7 13 ff 24 e9 f5 82 e4 34 35 f5 83 e0 fd 7c 00 e5 3f 30 e0
0a ed 7d 00 25 e0 25 e0 fc 80 11 ed ce ec ce 78 06 c3 33 ce 33 ce d8 f9
fd cc ee cc 7d 00 cc 54 3c cc e5 2b 54 03 fb 7a 00 7e 00 78 07 c3 33 ce
33 ce d8 f9 fb ca ee ca cd 4d cd ea cc 4c cc e5 2c 60 04 cc 44 02 cc e5 31 >
saa7133[0]: i2c xfer: < 14 2c 54 7f cd 4d cd e4 cf ed cf ce ec ce 02 2a
f4 8e 68 8f 69 e4 f5 6b e5 28 20 e0 05 75 6b 01 80 5e 43 68 40 7f 03 7e
01 12 34 88 7f 4f 7e 00 12 34 9c 75 6a 0e 74 01 7e 00 a8 6a 08 80 05 c3
33 ce 33 ce d8 f9 ff e5 68 5e fe e5 69 5f 4e 60 10 7f 39 7e 00 12 34 88
7f 14 7e 00 12 34 9c 80 0e 7f 1c 7e 00 12 34 88 7f 30 7e 00 12 34 9c 15
6a c3 e5 6a 64 80 94 80 50 bc 85 68 38 85 69 39 af 6b 22 e5 28 30 e0 63
20 e1 5d 90 ff 22 e0 f5 32 44 80 f0 90 ff 46 e0 78 82 f6 90 ff 42 e0 78
7f f6 90 ff 5c e0 ff a3 e0 08 cf f6 08 ef f6 90 ff 46 74 3f f0 90 ff 42
74 70 f0 90 ff 5c 74 66 f0 a3 e4 f0 f5 27 f5 29 f5 2a f5 3f 90 35 f1 e0
54 c0 60 05 75 2b 03 80 03 e4 f5 2b 12 2a 82 75 3d 04 75 2d 60 43 28 02
7f 00 22 7f 01 22 90 ff 36 e0 70 07 53 28 f2 d2 b7 80 54 e5 28 54 09 70 4e >
saa7133[0]: i2c xfer: < 14 2c c2 b7 12 10 4e e4 f5 66 f5 67 7f c4 7e 00
12 34 88 7f 3a 7e 00 12 34 88 05 67 e5 67 70 02 05 66 c3 94 03 e5 66 94
00 40 e1 7f c4 7e 00 12 34 9c 7f 3a 7e 00 12 34 9c 75 28 01 e4 f5 3f 75
2b 03 f5 2c 75 31 02 12 2a 82 75 28 08 75 3d 14 90 ff 46 74 3f f0 22 cb
ef cb eb 30 e7 03 25 e0 fb e4 f5 12 f5 13 eb 60 50 8d 82 8c 83 e0 f5 14
a3 e0 f5 15 c3 e5 14 64 80 94 80 50 0b c3 e4 95 15 f5 15 e4 95 14 f5 14
c3 74 ff 95 13 ff 74 ff 95 12 fe c3 e5 15 9f e5 14 9e 50 0e e5 15 25 13
f5 13 e5 14 35 12 f5 12 80 05 7e ff 7f ff 22 74 02 2d fd e4 3c fc 1b 80
ad ae 12 af 13 22 8f 65 e5 65 54 0f 24 fe 60 23 04 70 43 7c 24 7d ef 7b
ff e4 ff 12 18 8f 90 ff ab 74 40 f0 90 ff cb 74 43 f0 90 ff 61 e0 44 80
f0 80 23 e5 65 30 e4 06 90 ff ab 74 10 f0 e5 65 30 e5 07 90 ff ab e0 44 20 >
saa7133[0]: i2c xfer: < 14 2c f0 e5 65 30 e6 07 90 ff ab e0 44 40 f0 7c
33 7d 33 7b ff e4 ff 12 18 8f 7c 25 7d 06 7b ff e4 ff 02 18 8f e4 f5 65
90 ff 35 e0 14 60 12 14 60 16 14 60 1a 14 60 32 24 04 70 3d 12 2b d1 80
3b 12 2b 66 8f 65 80 34 12 32 2a 8f 65 80 2d 90 ff 36 e0 fd 7c 00 7d 00
fc a3 e0 fd e4 cf ed cf ce ec ce 12 2a f4 8f 65 80 12 7c 35 7d e9 7b 09
7f 36 7e ff 12 34 2e 80 03 75 65 01 e5 65 b4 01 07 90 ff 21 e0 44 08 f0
22 12 33 fe e5 49 24 c0 60 1e 24 c0 60 2a 24 80 70 3a 90 fe 4e 74 06 f0
a3 74 82 f0 a3 74 42 f0 90 fe 7c 74 f1 f0 80 24 90 fe 4e 74 0e f0 a3 74
41 f0 a3 74 21 f0 80 14 90 fe 4e 74 17 f0 a3 74 62 f0 a3 74 34 f0 90 fe
7c 74 c1 f0 90 fe 4c e5 47 f0 a3 e5 46 f0 7c 30 7d 3b 7b ff 7f 01 02 18
8f c9 92 21 90 bf 40 41 c7 0f 21 61 3f 40 00 c9 92 44 a2 00 00 00 00 21 ab >
saa7133[0]: i2c xfer: < 14 2c f8 07 21 90 bf 40 21 61 3f 40 00 42 99 55
55 21 90 bf 40 42 ad 00 20 00 42 99 77 77 21 90 bf 40 42 ad 00 01 00 49
92 23 33 33 33 33 33 33 23 23 21 90 bf 40 00 43 96 44 55 55 21 90 bf 40
21 61 3f 80 00 90 ff 3f e0 54 f0 60 06 e4 f5 70 f5 6c 22 e5 70 b4 40 0b
e5 6f 70 07 75 6f 01 75 70 30 22 e5 70 b4 30 0b e5 6f 70 07 75 6f 01 75
70 40 22 e5 70 b4 60 13 90 ff 30 e0 30 e2 08 e4 f5 70 f5 6c f5 6f 22 75
70 20 22 e5 70 b4 20 08 e4 f5 70 f5 6c f5 6f 22 75 70 60 22 78 84 e6 ff
c4 54 f0 90 ff 32 f0 90 fe 6e e0 fc a3 e0 c3 94 8c ec 94 02 50 0d e5 48
b4 01 08 ef c3 94 04 50 2c 06 22 ef d3 94 00 40 03 78 84 16 78 84 e6 c3
94 02 50 19 18 06 e6 c3 94 05 40 02 e4 f6 78 83 e6 24 41 f8 e6 90 fe 41
f0 e4 78 84 f6 22 c2 24 ef 24 fe 60 08 24 02 70 06 c2 25 80 02 d2 24 30 24 >
saa7133[0]: i2c xfer: < 14 2c 0e 90 ff 31 e0 44 80 f0 7f 84 12 32 54 80
0c 90 ff 31 e0 54 7f f0 7f 88 12 32 54 20 23 08 a2 25 30 24 01 b3 50 15
c2 23 30 24 07 7f 02 12 30 b0 80 05 7f 01 12 30 b0 a2 24 92 25 22 cb ef
cb ca ee ca 12 31 77 75 53 00 75 54 3f e5 54 f4 04 ff 12 1f 95 74 02 2b
fb e4 3a fa e5 54 15 54 70 02 15 53 e5 54 45 53 70 e3 d3 e5 54 94 c0 e5
53 94 00 50 16 af 54 12 1f 95 74 02 2b fb e4 3a fa 05 54 e5 54 70 e3 05
53 80 df 22 90 ff 19 e0 f5 20 20 03 0b 7c 33 7d 21 7b ff e4 ff 12 18 8f
12 34 5c 90 ff 27 e4 f0 74 1f f0 c2 35 75 47 07 75 46 fe 12 34 c3 12 1a
66 12 30 e3 90 ff 19 e0 f5 20 30 02 ee 20 35 05 12 34 72 d2 35 12 26 c0
80 e1 7b 01 7a 38 7d 00 7c 38 e4 ff 12 13 63 0a 7d 00 0c 7f 01 12 13 63
0a 7d 00 0c 7f 02 12 13 63 0a 7d 00 0c 7f 03 12 13 63 0a 7d 00 0c 7f 04 12 >
saa7133[0]: i2c xfer: < 14 2c 13 63 0a 7d 00 0c 7f 05 12 13 63 0a 7d 00
0c 7f 06 02 13 63 30 26 07 c2 26 c2 31 e4 f5 7d 30 31 32 c2 31 90 fe 6e
e0 fe a3 e0 d3 94 08 ee 94 04 40 15 12 10 4e 90 fe 6e e0 fe a3 e0 d3 94
08 ee 94 04 40 03 7f 00 22 90 fe 5d e0 c3 94 45 50 03 7f 01 22 7f 02 22
21 7b fd 06 00 21 7b 00 07 81 9e 94 21 4e f9 00 44 51 06 86 54 ba 85 44
62 25 60 54 28 85 44 51 01 4d 03 66 44 62 03 a5 00 a6 8a 41 61 ad 21 60
ff 60 41 5f 25 8a 9e 9e 9e 9e 9e 21 4e ff 06 00 12 34 16 ef 44 01 ff 12
32 a1 ef 60 03 7f 01 22 19 e9 60 14 12 32 7d 8b 82 8a 83 ef f0 12 35 33
0b bb 00 01 0a 19 80 e9 12 32 7d 8b 82 8a 83 ef f0 12 35 41 12 35 07 7f
00 22 90 ff 26 e0 f5 7c ef 20 e7 03 30 e6 03 53 7c 3f ef 20 e1 03 30 e0
03 53 7c fc ef 42 7c 90 ff 26 e5 7c f0 90 ff 25 e0 55 7c 60 07 c2 b5 53 91 >
saa7133[0]: i2c xfer: < 14 2c df d2 e9 22 e5 3d 60 14 15 3d e4 f5 65 12
10 4e 05 65 c3 e5 65 64 80 94 8a 40 f2 22 e5 28 30 e3 04 75 28 01 22 e5
28 30 e1 03 02 1d 20 e5 28 30 e2 03 12 22 70 22 e0 a3 e0 fa a3 e0 f9 12
13 5d e4 ff ef 60 11 90 ff cc e0 f5 5e 90 ff e9 e0 f5 61 a3 e0 f5 62 22
90 ff cc e5 5e f0 90 ff e9 e5 61 f0 a3 e5 62 f0 22 90 ff db e0 30 e1 23
90 ff a1 e0 54 fc f5 76 f0 90 ff a6 e0 75 77 00 f5 78 75 78 00 f5 77 a3
e0 25 78 f5 78 e4 35 77 f5 77 22 75 77 7f 75 78 ff 22 90 ff 08 e0 44 07
f0 90 ff 0a e0 54 3f f0 90 ff 08 e0 54 f8 f0 90 ff a0 74 46 f0 a3 74 18
f0 90 ff af 74 6c f0 74 20 f0 90 ff 60 74 c5 f0 22 c0 e0 c0 f0 c0 83 c0
82 c0 85 c0 84 c0 86 75 86 00 c0 d0 75 d0 18 d2 32 12 35 69 c2 db d0 d0
d0 86 d0 84 d0 85 d0 82 d0 83 d0 f0 d0 e0 32 12 34 16 12 32 a1 ef 60 03 7f >
saa7133[0]: i2c xfer: < 14 2c 01 22 e9 60 17 8b 82 8a 83 e0 ff 12 32 a1
ef 60 03 7f 01 22 19 0b bb 00 01 0a 80 e6 12 35 07 7f 00 22 90 ff 21 e0
30 e6 22 12 27 e9 ef 60 09 90 ff 21 e0 44 04 f0 80 07 90 ff 21 e0 54 fb
f0 90 ff 21 e0 54 bf f0 7f 20 12 30 b0 22 90 ff 36 e0 70 05 53 28 fb ff
22 e5 28 30 e0 17 20 e2 11 75 36 01 75 37 45 e4 f5 3a 85 3f 35 f5 30 43
28 04 7f 00 22 7f 01 22 bf 01 02 d2 b2 bf 02 02 c2 b2 bf 40 02 c2 b3 bf
80 02 d2 b3 bf 04 02 c2 b4 bf 08 02 d2 b4 bf 84 02 c2 b6 bf 88 02 d2 b6
22 e4 ff 7e 08 d2 b0 12 32 c7 d2 b1 30 b1 fd 12 32 c7 ef 25 e0 ff 30 b0
04 cf 44 01 cf c2 b1 12 32 c7 de e1 22 7e 08 ef 30 e7 04 d2 b0 80 02 c2
b0 12 32 c7 d2 b1 30 b1 fd 12 32 c2 ef 25 e0 ff de e5 12 32 e2 22 12 32
c7 c2 b1 ad 16 7c 00 20 b1 08 ec a2 e7 13 fc ed 13 fd ed 4c 60 07 ed 1d 70 >
saa7133[0]: i2c xfer: < 14 2c f8 1c 80 f5 22 d2 b0 12 32 c7 d2 b1 30 b1
fd 12 32 c7 30 b0 08 c2 b1 12 32 c7 7f 01 22 c2 b1 12 32 c7 7f 00 22 90
ff 21 e0 30 e1 17 7d 01 7c 3f 7f 00 7e 3f 12 1e 70 90 ff 21 e0 54 fd f0
7f 04 12 30 b0 22 41 42 74 41 57 87 42 58 32 00 42 5c 64 00 41 41 04 00
21 90 9f 60 21 60 fe 01 21 41 fb 04 00 05 41 4a 2a 33 60 70 01 2c 00 01
31 02 01 28 00 01 3d 00 01 2d 00 01 30 00 02 2e 00 01 00 90 ff 25 e0 65
7e 60 13 e0 f5 7e a3 e0 f5 7c f0 55 7e 60 07 c2 b5 53 91 df d2 e9 22 e4
f5 7e d2 ec d2 ad d2 af f5 7d f5 c8 75 cb 5c 75 ca 74 85 cb cd 85 ca 8b
d2 ca 22 75 60 02 c2 2e 7c 33 7d 33 7b ff e4 ff 12 18 8f 7c 28 7d 9e 7b
ff e4 ff 02 18 8f 75 60 03 c2 2e 7c 33 7d 33 7b ff e4 ff 12 18 8f 7c 23
7d a5 7b ff e4 ff 02 18 8f c0 e0 c0 d0 c2 cf 05 7d e5 7d c3 94 0a 40 05 d2 >
saa7133[0]: i2c xfer: < 14 2c 31 75 7d 00 d0 d0 d0 e0 32 90 ff 58 e0 fe
a3 e0 ff c3 74 ff 9f ff 74 ff 9e fe 7c 02 7d 8f 12 12 bd 22 90 fe 7d e0
f5 40 90 ff 09 e0 44 04 f0 e0 54 fb f0 90 fe 7d e5 40 f0 22 c9 ed c9 90
ff 20 e0 54 7f f5 16 d2 b1 d2 b0 12 32 c7 c2 b0 12 32 c2 22 8e 83 8f 82
8c 85 8d 84 eb 60 0b e0 a3 05 86 f0 a3 15 86 1b 80 f2 22 90 ff 21 e0 30
e4 0f 12 2f b1 90 ff 21 e0 54 ef f0 7f 04 12 30 b0 22 90 ff 31 e4 f0 d2
2b 12 10 2e 12 35 61 12 33 7a c2 2c e4 f5 60 22 d2 28 12 35 4f c2 2a 90
ff 30 e0 54 c0 f5 4a 90 fe 41 e5 41 f0 22 e4 fd fc c3 ed 9f ec 9e 50 09
d2 b7 0d bd 00 01 0c 80 f0 22 e4 fd fc c3 ed 9f ec 9e 50 09 c2 b7 0d bd
00 01 0c 80 f0 22 53 8e f8 90 ff 05 74 04 f0 a3 e4 f0 a3 74 04 f0 02 2f
6b 12 1b c8 12 33 5e 12 10 03 12 32 00 12 34 45 02 33 02 e5 70 70 03 f5 6f >
saa7133[0]: i2c xfer: < 14 2c 22 e5 6c d3 94 02 40 03 12 2e 25 22 7c 28
7d 74 7b ff e4 ff 12 18 8f 7f 02 02 32 54 7c 23 7d 4b 7b ff e4 ff 12 18
8f 7f 02 02 32 54 c2 b0 12 32 c7 d2 b1 12 32 c7 d2 b0 12 32 c7 22 8f 82
8e 83 ed 60 06 e4 f0 a3 1d 80 f7 22 7f 94 7e 00 ef 1f 70 01 1e ef 4e 70
f7 22 c2 b0 12 32 c7 d2 b1 30 b1 fd 12 32 c2 22 d2 b0 12 32 c7 d2 b1 30
b1 fd 12 32 c2 22 c2 23 12 33 fe e4 ff 02 2e ce 53 91 df d2 b5 c2 e9 32
e4 f5 6c f5 6f f5 70 22 90 ff 27 e0 a3 e0 22 >
saa7133[0]: i2c xfer: < 14 2c f1 b2 >
saa7133[0]: i2c xfer: < 14 2c [fd quirk] < 15 =22 >
saa7133[0]: i2c xfer: < 14 2b 80 >
nxt2004: Firmware upload complete
saa7133[0]: i2c xfer: < 14 19 01 >
saa7133[0]: i2c xfer: < 14 2b 00 >
saa7133[0]: i2c xfer: < 14 34 70 >
saa7133[0]: i2c xfer: < 14 35 04 >
saa7133[0]: i2c xfer: < 14 36 01 23 45 67 89 ab cd ef c0 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 22 80 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 22 80 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 2b 00 >
saa7133[0]: i2c xfer: < 14 34 70 >
saa7133[0]: i2c xfer: < 14 35 04 >
saa7133[0]: i2c xfer: < 14 36 01 23 45 67 89 ab cd ef c0 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 22 80 >
saa7133[0]: i2c xfer: < 14 31 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 ff >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 57 d7 >
saa7133[0]: i2c xfer: < 14 35 07 fe >
saa7133[0]: i2c xfer: < 14 34 12 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 0a 21 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 01 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 e9 7e 00 >
saa7133[0]: i2c xfer: < 14 cc 00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =01 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 34 21 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 10 >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 34 21 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 01 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 81 >
saa7133[0]: i2c xfer: < 14 36 70 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 82 >
saa7133[0]: i2c xfer: < 14 36 31 5e 66 >
saa7133[0]: i2c xfer: < 14 34 53 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 88 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =78 >
saa7133[0]: i2c xfer: < 14 35 88 >
saa7133[0]: i2c xfer: < 14 36 11 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =01 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 40 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 10 [fd quirk] < 15 =12 >
saa7133[0]: i2c xfer: < 14 10 10 >
saa7133[0]: i2c xfer: < 14 0a [fd quirk] < 15 =21 >
saa7133[0]: i2c xfer: < 14 0a 21 >
saa7133[0]: i2c xfer: < 14 2b 00 >
saa7133[0]: i2c xfer: < 14 34 70 >
saa7133[0]: i2c xfer: < 14 35 04 >
saa7133[0]: i2c xfer: < 14 36 01 23 45 67 89 ab cd ef c0 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 0a 21 >
saa7133[0]: i2c xfer: < 14 e9 7e >
saa7133[0]: i2c xfer: < 14 ea 00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =40 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 34 21 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 10 >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 34 21 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 35 08 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 31 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 04 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 81 >
saa7133[0]: i2c xfer: < 14 36 00 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 82 >
saa7133[0]: i2c xfer: < 14 36 80 00 00 >
saa7133[0]: i2c xfer: < 14 34 53 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 88 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =78 >
saa7133[0]: i2c xfer: < 14 35 88 >
saa7133[0]: i2c xfer: < 14 36 11 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 34 41 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 36 [fd quirk] < 15 =04 >
saa7133[0]: i2c xfer: < 14 35 80 >
saa7133[0]: i2c xfer: < 14 36 44 >
saa7133[0]: i2c xfer: < 14 34 51 >
saa7133[0]: i2c xfer: < 14 21 80 >
saa7133[0]: i2c xfer: < 14 21 [fd quirk] < 15 =00 >
saa7133[0]: i2c xfer: < 14 10 [fd quirk] < 15 =10 >
saa7133[0]: i2c xfer: < 14 10 12 >
saa7133[0]: i2c xfer: < 14 13 04 >
saa7133[0]: i2c xfer: < 14 16 00 >
saa7133[0]: i2c xfer: < 14 14 04 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >
saa7133[0]: i2c xfer: < 14 14 00 >
saa7133[0]: i2c xfer: < 14 17 00 >




C)
modprobe -r saa7134-dvb
modprobe -r tuner
modprobe saa7134-dvb debug=1
dmesg:

tuner-simple 1-0061: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32, mmio:
0xfa021000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
[card=90,autodetected]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
tuner 1-0061: chip found @ 0xc2 (saa7133[0])
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
nxt200x: NXT2004 Detected
tuner-simple 1-0061: attaching existing instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
nxt2004: Waiting for firmware upload(2)...
nxt2004: Firmware upload complete


-------------

[2] Current Hg with Mauro's patch applied

A)
fresh install, no options
dmesg:

Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32, mmio:
0xfa021000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
[card=90,autodetected]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
nxt200x: NXT2004 Detected
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
nxt2004: Waiting for firmware upload(2)...
nxt2004: Firmware upload complete


B)
modprobe -r saa7134-dvb
modprobe -r tuner
modprobe saa7134 i2c_scan=1
dmesg:

tuner-simple 1-0061: destroying instance
Linux video capture interface: v2.00
saa7130/34: v4l2 driver version 0.2.14 loaded
saa7133[0]: found at 0000:00:09.0, rev: 240, irq: 19, latency: 32, mmio:
0xfa021000
saa7133[0]: subsystem: 17de:7350, board: Kworld ATSC110/115
[card=90,autodetected]
saa7133[0]: board init: gpio is 100
saa7133[0]: i2c eeprom 00: de 17 50 73 ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c scan: found device @ 0x14  [???]
saa7133[0]: i2c scan: found device @ 0x16  [???]
saa7133[0]: i2c scan: found device @ 0xa0  [eeprom]
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
nxt200x: NXT2004 Detected
tuner-simple 1-0061: creating new instance
tuner-simple 1-0061: type set to 68 (Philips TUV1236D ATSC/NTSC dual in)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Nextwave NXT200X VSB/QAM frontend)...
nxt2004: Waiting for firmware upload (dvb-fe-nxt2004.fw)...
nxt2004: Waiting for firmware upload(2)...
nxt2004: Firmware upload complete




