Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1Kg5mF-0002yO-Ct
	for linux-dvb@linuxtv.org; Thu, 18 Sep 2008 00:46:15 +0200
Received: by wf-out-1314.google.com with SMTP id 27so3462289wfd.17
	for <linux-dvb@linuxtv.org>; Wed, 17 Sep 2008 15:45:35 -0700 (PDT)
Message-ID: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
Date: Wed, 17 Sep 2008 15:45:34 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "linux dvb" <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Subject: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1196215922=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1196215922==
Content-Type: multipart/alternative;
	boundary="----=_Part_23247_24557222.1221691534898"

------=_Part_23247_24557222.1221691534898
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Please excuse my previous message.  I hit the send button too early.

OK, so I am going to take the advice of others and be persistant.  I am
trying to add analog support for the
DViCO FusionHDTV7 Dual Express by working with the current code for the
HVR-1500. Loading the HVR-1500 driver doesn't work. I have thoughts about
the dmesg output.

[   11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge
WinTV-HVR1500 [card=6,insmod option]
[   11.224568] cx23885[0]: i2c bus 0 registered
[   11.224609] cx23885[0]: i2c bus 1 registered
[   11.224632] cx23885[0]: i2c bus 2 registered
[   11.251024] tveeprom 2-0050: Encountered bad packet header [ff].
Corrupt or not a Hauppauge eeprom.
[   11.251026] cx23885[0]: warning: unknown hauppauge model #0
[   11.251027] cx23885[0]: hauppauge eeprom: model=0

This makes sense because it is not a hauppauge card, but I think it might be
a harmless warning.

[   11.268639] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.283305] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.285887] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
[   11.288377] cx23885[0]/0: registered device video0 [v4l2]
[   11.288653] cx23885[0]/1: registered ALSA audio device
[   11.288658] tuner' 3-0064: tuner type not set

2-0064 and 3-0064 are probably the dual digital tuners.  3-0064 tuner type
is not set because the HVR1500 card
is a single tuner card and so it only sets one tuner.  I am guessing that
cx25840' 4-0044 has something to
do with the analog support.

[   11.292131] firmware: requesting v4l-cx23885-avcore-01.fw
[   11.310299] cx25840' 4-0044: unable to open
firmware v4l-cx23885-avcore-01.fw

Why is it trying to load v4l-cx23885-avcore-01.fw?  I have the xc5000
firmware installed from
http://www.steventoth.net/linux/xc5000/
because that is the correct firmware for my card.

[   11.324551] cx23885[0]: cx23885 based dvb card
[   11.348947] cx23885[0]: frontend initialization failed
[   11.348949] cx23885_dvb_register() dvb_register failed err = -1
[   11.348951] cx23885_dev_setup() Failed to register dvb on VID_C
[   11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0

Is this error a big deal or is it fatal?

Next I tried to go out and find v4l-cx23885-avcore-01.fw which was at
<http://www.steventoth.net/linux/hvr1800/>
http://www.steventoth.net/linux/hvr1800/

I loaded this firmware too.  Results are the same until:
[   11.254199] firmware: requesting v4l-cx23885-avcore-01.fw
[   11.876323] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   11.890444] cx23885[0]: cx23885 based dvb card
[   11.920769] cx23885[0]: frontend initialization failed
[   11.920771] cx23885_dvb_register() dvb_register failed err = -1
[   11.920773] cx23885_dev_setup() Failed to register dvb on VID_C
[   11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0

So it loaded the firmware, but it didn't help with tuning channels.  Next
attempt was to copy the relevant code from the HVR-1500 section to the
FusionHDTV7 Dual Express section.  This was just a few lines in
/linux/drivers/media/video/cx23885/cx23885-cards.c
that you will see a little later in this message.  The dmesg output was

[   11.613432] cx23885 0000:08:00.0: PCI INT A -> Link[APC6] -> GSI 16
(level, low) -> IRQ
 16
[   11.613491] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
FusionHDTV7 Dual Expres
s [card=10,autodetected]
[   11.752552] cx23885[0]: i2c bus 0 registered
[   11.752824] cx23885[0]: i2c bus 1 registered
[   11.752850] cx23885[0]: i2c bus 2 registered
[   11.806061] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.815419] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.818004] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
[   11.820086] cx23885[0]/0: registered device video0 [v4l2]
[   11.820356] cx23885[0]/1: registered ALSA audio device
[   11.820360] tuner' 3-0064: tuner type not set
[   11.833710] firmware: requesting v4l-cx23885-avcore-01.fw
[   12.504759] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)
[   12.518893] cx23885[0]: cx23885 based dvb card
[   12.694643] xc5000: Successfully identified at address 0x64
[   12.694645] xc5000: Firmware has not been loaded previously
[   12.694651] DVB: registering new adapter (cx23885[0])
[   12.694654] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB
Frontend)...
[   12.696204] cx23885[0]: cx23885 based dvb card
[   12.741530] xc5000: Successfully identified at address 0x64
[   12.741531] xc5000: Firmware has not been loaded previously
[   12.741533] DVB: registering new adapter (cx23885[0])
[   12.741535] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB
Frontend)...
[   12.743028] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   12.743034] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xf
d800000
[   12.743039] cx23885 0000:08:00.0: setting latency timer to 64

I don't get dvb_register() or dev_checkrevision() errors, but I still can't
tune channels.  I suspect that
I have loaded the digital stuff, but the analog stuff hasn't been loaded
successfully.

Were there things that were HVR1500 specific?  I took a look at
/linux/drivers/media/video/cx23885/cx23885-cards.c:

[CX23885_BOARD_HAUPPAUGE_HVR1500] = {
                .name           = "Hauppauge WinTV-HVR1500",
// The section for my card is
[CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP] = {
                .name           = "DViCO FusionHDTV7 Dual Express",

              .porta          = CX23885_ANALOG_VIDEO,
 //  I added the following for the dvico card
                .portb  = CX23885_MPEG_DVB,
// back to original code
                .portc          = CX23885_MPEG_DVB,
// the following is probably not compatible with the dvico card
                .tuner_type     = TUNER_XC2028,
                .tuner_addr     = 0x61, /* 0xc2 >> 1 */
// I tried replacing it with the following code.  It is a guess, but the
following dmesg makes it seem like a good guess.
                .tuner_type     = TUNER_XC5000,
                .tuner_addr     = 0x64, /* 0xc2 >> 1 */
//  Why is the stuff below referring to 25480?  Probably because that has
analog support.
//  Is that why it asks for the v4l-cx23885-avcore-01.fw firmware?
// Why are there three different versions below?  I would think that TV,
Composite and SVideo are outputs,
// but the mythtv tuning setup makes it seem like they are input.
                .input          = {{
                        .type   = CX23885_VMUX_TELEVISION,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN5_CH2 |
                                        CX25840_VIN2_CH1,
                        .gpio0  = 0,
                }, {
                        .type   = CX23885_VMUX_COMPOSITE1,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN4_CH2 |
                                        CX25840_VIN6_CH1,
                        .gpio0  = 0,
                }, {
                        .type   = CX23885_VMUX_SVIDEO,
                        .vmux   =       CX25840_VIN7_CH3 |
                                        CX25840_VIN4_CH2 |
                                        CX25840_VIN8_CH1 |
                                        CX25840_SVIDEO_ON,
                        .gpio0  = 0,
                } },

With those minor changes I tried loading the cx23885 module again.
[   10.977705] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
FusionHDTV7 Dual Express [card=10,autodetected]
[   11.116725] cx23885[0]: i2c bus 0 registered
[   11.116738] cx23885[0]: i2c bus 1 registered
[   11.116752] cx23885[0]: i2c bus 2 registered
[   11.158834] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.186669] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.228894] xc5000: Successfully identified at address 0x64
[   11.228896] xc5000: Firmware has not been loaded previously
[   11.229567] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
[   11.229570] firmware: requesting dvb-fe-xc5000-1.1.fw
[   11.301703] xc5000: firmware read 12332 bytes.
[   11.301706] xc5000: firmware upload
[   11.301708] xc5000: no tuner reset callback function, fatal
[   13.766578] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
[   13.767308] xc5000: Successfully identified at address 0x64
[   13.767309] xc5000: Firmware has not been loaded previously
[   13.767979] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...
[   13.767980] firmware: requesting dvb-fe-xc5000-1.1.fw
[   13.769073] xc5000: firmware read 12332 bytes.
[   13.769074] xc5000: firmware upload
[   13.769075] xc5000: no tuner reset callback function, fatal
[   16.238788] xc5000: Successfully identified at address 0x64
[   16.238790] xc5000: Firmware has been loaded previously
[   17.384118] cx23885[0]/0: registered device video0 [v4l2]
[   17.384429] cx23885[0]/1: registered ALSA audio device
[   19.479469] firmware: requesting v4l-cx23885-avcore-01.fw
[   20.084869] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
(16382 bytes)

Why is this still asking for v4l-cx23885-avcore-01.fw firmware?  I thought
that
my alterations would have changed that?   I could remove it, but
I bet it would still be asking for it.  It seems to load the xc5000
over and over again so I am guessing my changes were wrong.

[   20.098995] cx23885[0]: cx23885 based dvb card
[   20.178461] xc5000: Successfully identified at address 0x64
[   20.178462] xc5000: Firmware has been loaded previously
[   20.178470] DVB: registering new adapter (cx23885[0])
[   20.178474] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB
Frontend)...
[   20.180029] cx23885[0]: cx23885 based dvb card
[   20.225399] xc5000: Successfully identified at address 0x64
[   20.225400] xc5000: Firmware has been loaded previously
[   20.225403] DVB: registering new adapter (cx23885[0])
[   20.225404] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB
Frontend)...
[   20.226909] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   20.226915] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xf
d800000
[   20.226920] cx23885 0000:08:00.0: setting latency timer to 64

Again I don't get dvb_register() or dev_checkrevision() errors, but I still
can't tune channels.
What should go here for my card?
               .tuner_type     = ?
               .tuner_addr     = ?

As you can see I have made several attempts to dive into the code and
understand the error messages.  I have tried to identify problem areas so
that someone more familiar with the code could possibly see what the errors
may be.


--Tim

------=_Part_23247_24557222.1221691534898
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><span style="border-collapse: collapse; "><div><span style="border-collapse: separate; ">Please excuse my previous message. &nbsp;I hit the send button too early.</span></div><div><br></div><div>OK, so I am going to take the advice of others and be persistant. &nbsp;I am trying to add analog support for the</div>
<div><span style="white-space: pre; ">DViCO FusionHDTV7 Dual Express by working with the current code for the HVR-1500.  Loading the HVR-1500 driver doesn&#39;t work.  I have thoughts about the dmesg output.</span></div><div>
<div><br></div><div>[ &nbsp; 11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge</div><div>WinTV-HVR1500 [card=6,insmod option]</div></div><div>[ &nbsp; 11.224568] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.224609] cx23885[0]: i2c bus 1 registered</div>
<div>[ &nbsp; 11.224632] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.251024] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt&nbsp;or not a Hauppauge eeprom.</div><div>[ &nbsp; 11.251026] cx23885[0]: warning: unknown hauppauge model #0</div>
<div>[ &nbsp; 11.251027] cx23885[0]: hauppauge eeprom: model=0</div><div><br></div><div>This makes sense because it is not a hauppauge card, but I think it might be a harmless warning.</div><div><br></div><div>[ &nbsp; 11.268639] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div>
<div>[ &nbsp; 11.283305] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])<br></div><div>[ &nbsp; 11.285887] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.288377] cx23885[0]/0: registered device video0 [v4l2]<br>
</div><div>[ &nbsp; 11.288653] cx23885[0]/1: registered ALSA audio device</div><div>[ &nbsp; 11.288658] tuner&#39; 3-0064: tuner type not set</div><div><br></div><div>2-0064 and 3-0064 are probably the dual digital tuners. &nbsp;3-0064 tuner type is not set because the HVR1500 card<br>
</div><div>is a single tuner card and so it only sets one tuner. &nbsp;I am guessing that cx25840&#39; 4-0044 has something to</div><div>do with the analog support. &nbsp;</div><div><br></div><div>[ &nbsp; 11.292131] firmware: requesting v4l-cx23885-avcore-01.fw</div>
<div>[ &nbsp; 11.310299] cx25840&#39; 4-0044: unable to open firmware&nbsp;v4l-cx23885-avcore-01.fw</div><div><br></div><div>Why is it trying to load v4l-cx23885-avcore-01.fw? &nbsp;I have the xc5000 firmware installed from</div><div><a href="http://www.steventoth.net/linux/xc5000/" target="_blank">http://www.steventoth.net/linux/xc5000/</a><br>
</div><div>because that is the correct firmware for my card.</div><div><br></div><div>[ &nbsp; 11.324551] cx23885[0]: cx23885 based dvb card</div><div>[ &nbsp; 11.348947] cx23885[0]: frontend initialization failed<br></div><div>[ &nbsp; 11.348949] cx23885_dvb_register() dvb_register failed err = -1</div>
<div>[ &nbsp; 11.348951] cx23885_dev_setup() Failed to register dvb on VID_C</div><div>[ &nbsp; 11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div><br></div><div>Is this error a big deal or is it fatal?</div>
<div><br></div><div>Next I tried to go out and find&nbsp;v4l-cx23885-avcore-01.fw which was at&nbsp;<a href="http://www.steventoth.net/linux/hvr1800/" target="_blank" style="color: rgb(0, 0, 204); "></a></div><div><a href="http://www.steventoth.net/linux/hvr1800/" target="_blank" style="color: rgb(0, 0, 204); ">http://www.steventoth.net/linux/hvr1800/</a></div>
<div><br></div><div>I loaded this firmware too. &nbsp;Results are the same until:</div><div>[ &nbsp; 11.254199] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 11.876323] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware</div>
<div>(16382 bytes)</div><div>[ &nbsp; 11.890444] cx23885[0]: cx23885 based dvb card</div><div>[ &nbsp; 11.920769] cx23885[0]: frontend initialization failed</div><div>[ &nbsp; 11.920771] cx23885_dvb_register() dvb_register failed err = -1</div>
<div>[ &nbsp; 11.920773] cx23885_dev_setup() Failed to register dvb on VID_C</div><div>[ &nbsp; 11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0<br></div><div><br></div><div>So it loaded the firmware, but it didn&#39;t help with tuning channels. &nbsp;Next attempt was to copy the relevant code from the HVR-1500 section to the FusionHDTV7 Dual Express section. &nbsp;This was just a few lines in&nbsp;</div>
<div>/linux/drivers/media/video/cx23885/cx23885-cards.c&nbsp;<br></div><div>that you will see a little later in this message. &nbsp;The dmesg output was</div><div><br></div><div><div>[ &nbsp; 11.613432] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 16 (level, low) -&gt; IRQ</div>
<div>&nbsp;16</div><div>[ &nbsp; 11.613491] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Expres</div><div>s [card=10,autodetected]</div><div>[ &nbsp; 11.752552] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.752824] cx23885[0]: i2c bus 1 registered</div>
<div>[ &nbsp; 11.752850] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.806061] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div><div>[ &nbsp; 11.815419] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])</div><div>
[ &nbsp; 11.818004] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.820086] cx23885[0]/0: registered device video0 [v4l2]</div><div>[ &nbsp; 11.820356] cx23885[0]/1: registered ALSA audio device</div><div>[ &nbsp; 11.820360] tuner&#39; 3-0064: tuner type not set</div>
<div>[ &nbsp; 11.833710] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 12.504759] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)</div><div>[ &nbsp; 12.518893] cx23885[0]: cx23885 based dvb card</div>
<div>[ &nbsp; 12.694643] xc5000: Successfully identified at address 0x64</div><div>[ &nbsp; 12.694645] xc5000: Firmware has not been loaded previously</div><div>[ &nbsp; 12.694651] DVB: registering new adapter (cx23885[0])</div><div>[ &nbsp; 12.694654] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...</div>
<div>[ &nbsp; 12.696204] cx23885[0]: cx23885 based dvb card</div><div>[ &nbsp; 12.741530] xc5000: Successfully identified at address 0x64</div><div>[ &nbsp; 12.741531] xc5000: Firmware has not been loaded previously</div><div>[ &nbsp; 12.741533] DVB: registering new adapter (cx23885[0])</div>
<div>[ &nbsp; 12.741535] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB Frontend)...</div><div>[ &nbsp; 12.743028] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div>[ &nbsp; 12.743034] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf</div>
<div>d800000</div><div>[ &nbsp; 12.743039] cx23885 0000:08:00.0: setting latency timer to 64</div><div><br></div><div><div>I don&#39;t get dvb_register() or dev_checkrevision() errors, but I still can&#39;t tune channels. &nbsp;I suspect that</div>
<div>I have loaded the digital stuff, but the analog stuff hasn&#39;t been loaded successfully.</div></div></div><div><br></div><div>Were there things that were HVR1500 specific? &nbsp;I took a look at&nbsp;</div><div>/linux/drivers/media/video/cx23885/cx23885-cards.c:</div>
<div><div><br></div><div>[CX23885_BOARD_HAUPPAUGE_HVR1500] = {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = &quot;Hauppauge WinTV-HVR1500&quot;,</div><div>// The section for my card is</div><div>[CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP] = {</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = &quot;DViCO FusionHDTV7 Dual Express&quot;,</div><div>&nbsp;</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.porta &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= CX23885_ANALOG_VIDEO,</div><div>&nbsp;// &nbsp;I added the following for the dvico card &nbsp;&nbsp;</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.portb &nbsp;= CX23885_MPEG_DVB,</div><div>// back to original code</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.portc &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= CX23885_MPEG_DVB,</div><div>// the following is probably not compatible with the dvico card</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_type &nbsp; &nbsp; = TUNER_XC2028,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_addr &nbsp; &nbsp; = 0x61, /* 0xc2 &gt;&gt; 1 */</div><div>// I tried replacing it with the following code. &nbsp;It is a guess, but the following dmesg makes it seem like a good guess.</div>
<div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_type &nbsp; &nbsp; = TUNER_XC5000,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_addr &nbsp; &nbsp; = 0x64, /* 0xc2 &gt;&gt; 1 */</div><div>// &nbsp;Why is the stuff below referring to 25480? &nbsp;Probably because that has analog support.</div>
<div>// &nbsp;Is that why it asks for the&nbsp;v4l-cx23885-avcore-01.fw firmware?</div><div>// Why are there three different versions below? &nbsp;I would think that TV, Composite and SVideo are outputs,&nbsp;</div><div>// but the mythtv tuning setup makes it seem like they are input.</div>
</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.input &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= {{</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_TELEVISION,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN5_CH2 |</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN2_CH1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_COMPOSITE1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN6_CH1,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_SVIDEO,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN8_CH1 |</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_SVIDEO_ON,</div>
<div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,</div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;} },</div><div><br></div></div><div>With those minor changes I tried loading the cx23885 module again.</div><div><div>[ &nbsp; 10.977705] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]</div>
<div>[ &nbsp; 11.116725] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.116738] cx23885[0]: i2c bus 1 registered</div><div>[ &nbsp; 11.116752] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.158834] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div>
<div>[ &nbsp; 11.186669] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 11.228894] xc5000: Successfully identified at address 0x64</div><div>[ &nbsp; 11.228896] xc5000: Firmware has not been loaded previously</div>
<div>[ &nbsp; 11.229567] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...</div><div>[ &nbsp; 11.229570] firmware: requesting dvb-fe-xc5000-1.1.fw</div><div>[ &nbsp; 11.301703] xc5000: firmware read 12332 bytes.</div><div>[ &nbsp; 11.301706] xc5000: firmware upload</div>
<div>[ &nbsp; 11.301708] xc5000: no tuner reset callback function, fatal</div><div>[ &nbsp; 13.766578] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])</div><div>[ &nbsp; 13.767308] xc5000: Successfully identified at address 0x64</div>
<div>[ &nbsp; 13.767309] xc5000: Firmware has not been loaded previously</div><div>[ &nbsp; 13.767979] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...</div><div>[ &nbsp; 13.767980] firmware: requesting dvb-fe-xc5000-1.1.fw</div>
<div>[ &nbsp; 13.769073] xc5000: firmware read 12332 bytes.</div><div>[ &nbsp; 13.769074] xc5000: firmware upload</div><div>[ &nbsp; 13.769075] xc5000: no tuner reset callback function, fatal</div><div>[ &nbsp; 16.238788] xc5000: Successfully identified at address 0x64</div>
<div>[ &nbsp; 16.238790] xc5000: Firmware has been loaded previously</div><div>[ &nbsp; 17.384118] cx23885[0]/0: registered device video0 [v4l2]</div><div>[ &nbsp; 17.384429] cx23885[0]/1: registered ALSA audio device</div><div><div>[ &nbsp; 19.479469] firmware: requesting v4l-cx23885-avcore-01.fw</div>
<div>[ &nbsp; 20.084869] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)</div><div><br></div><div>Why is this still asking for v4l-cx23885-avcore-01.fw firmware? &nbsp;I thought that</div><div>my alterations would have changed that? &nbsp;&nbsp;I could remove it, but</div>
<div>I bet it would still be asking for it. &nbsp;It seems to load the xc5000</div><div>over and over again so I am guessing my changes were wrong.</div><div><br></div><div>[&nbsp;&nbsp; 20.098995] cx23885[0]: cx23885 based dvb card</div>
<div>[ &nbsp; 20.178461] xc5000: Successfully identified at address 0x64</div><div>[ &nbsp; 20.178462] xc5000: Firmware has been loaded previously</div><div>[ &nbsp; 20.178470] DVB: registering new adapter (cx23885[0])</div><div>[ &nbsp; 20.178474] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...</div>
<div>[ &nbsp; 20.180029] cx23885[0]: cx23885 based dvb card</div><div>[ &nbsp; 20.225399] xc5000: Successfully identified at address 0x64</div><div>[ &nbsp; 20.225400] xc5000: Firmware has been loaded previously</div><div>[ &nbsp; 20.225403] DVB: registering new adapter (cx23885[0])</div>
<div>[ &nbsp; 20.225404] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB Frontend)...</div><div>[ &nbsp; 20.226909] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div>[ &nbsp; 20.226915] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf</div>
<div>d800000</div><div>[ &nbsp; 20.226920] cx23885 0000:08:00.0: setting latency timer to 64</div><div><br></div><div>Again I don&#39;t get dvb_register() or dev_checkrevision() errors, but I still can&#39;t tune channels.&nbsp;</div>
<div>What should go here for my card?</div><div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .tuner_type &nbsp; &nbsp; = ?</div><div><div>&nbsp;&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .tuner_addr &nbsp; &nbsp; = ?</div></div></div><div><br></div></div></div><div>As you can see I have made several attempts to dive into the code and understand the error messages. &nbsp;I have tried to identify problem areas so that someone more familiar with the code could possibly see what the errors may be.</div>
<div><br></div><div><br></div></span> --Tim<br>
</div>

------=_Part_23247_24557222.1221691534898--


--===============1196215922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1196215922==--
