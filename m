Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.170])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lucastim@gmail.com>) id 1KiLJZ-0008BF-6y
	for linux-dvb@linuxtv.org; Wed, 24 Sep 2008 05:45:24 +0200
Received: by wf-out-1314.google.com with SMTP id 27so2711769wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 23 Sep 2008 20:45:16 -0700 (PDT)
Message-ID: <e32e0e5d0809232045j56bef9ah1ec3ac59401de0d5@mail.gmail.com>
Date: Tue, 23 Sep 2008 20:45:15 -0700
From: "Tim Lucas" <lucastim@gmail.com>
To: "Steven Toth" <stoth@linuxtv.org>, "linux dvb" <linux-dvb@linuxtv.org>
In-Reply-To: <48D34C69.6050700@linuxtv.org>
MIME-Version: 1.0
References: <e32e0e5d0809171545r3c2e58beh62d58fa6d04dae71@mail.gmail.com>
	<48D34C69.6050700@linuxtv.org>
Subject: Re: [linux-dvb] Porting analog support from HVR-1500 to the DViCO
	FusionHDTV7 Dual Express (Read this one)
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1446408755=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============1446408755==
Content-Type: multipart/alternative;
	boundary="----=_Part_35438_19114060.1222227915973"

------=_Part_35438_19114060.1222227915973
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Sep 18, 2008 at 11:53 PM, Steven Toth <stoth@linuxtv.org> wrote:

> Tim Lucas wrote:
>
>> Please excuse my previous message.  I hit the send button too early.
>>
>> OK, so I am going to take the advice of others and be persistant.  I am
>> trying to add analog support for the
>> DViCO FusionHDTV7 Dual Express by working with the current code for the
>> HVR-1500. Loading the HVR-1500 driver doesn't work. I have thoughts about
>> the dmesg output.
>>
>> [   11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge
>> WinTV-HVR1500 [card=6,insmod option]
>> [   11.224568] cx23885[0]: i2c bus 0 registered
>> [   11.224609] cx23885[0]: i2c bus 1 registered
>> [   11.224632] cx23885[0]: i2c bus 2 registered
>> [   11.251024] tveeprom 2-0050: Encountered bad packet header [ff].
>> Corrupt or not a Hauppauge eeprom.
>> [   11.251026] cx23885[0]: warning: unknown hauppauge model #0
>> [   11.251027] cx23885[0]: hauppauge eeprom: model=0
>>
>> This makes sense because it is not a hauppauge card, but I think it might
>> be a harmless warning.
>>
>
> You can ignore the eeprom error, it is not effecting your tests.
>
>
>> [   11.268639] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
>> [   11.283305] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
>> [   11.285887] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
>> [   11.288377] cx23885[0]/0: registered device video0 [v4l2]
>> [   11.288653] cx23885[0]/1: registered ALSA audio device
>> [   11.288658] tuner' 3-0064: tuner type not set
>>
>> 2-0064 and 3-0064 are probably the dual digital tuners.  3-0064 tuner type
>> is not set because the HVR1500 card
>> is a single tuner card and so it only sets one tuner.  I am guessing that
>> cx25840' 4-0044 has something to
>> do with the analog support.
>> [   11.292131] firmware: requesting v4l-cx23885-avcore-01.fw
>> [   11.310299] cx25840' 4-0044: unable to open firmware
>> v4l-cx23885-avcore-01.fw
>>
>> Why is it trying to load v4l-cx23885-avcore-01.fw?  I have the xc5000
>> firmware installed from
>> http://www.steventoth.net/linux/xc5000/
>> because that is the correct firmware for my card.
>>
>
> If you specify analog .porta in the card struct, it has to load the analog
> audio encoder firmware. This is why this firmware is loaded.
>
>>
>> [   11.324551] cx23885[0]: cx23885 based dvb card
>> [   11.348947] cx23885[0]: frontend initialization failed
>> [   11.348949] cx23885_dvb_register() dvb_register failed err = -1
>> [   11.348951] cx23885_dev_setup() Failed to register dvb on VID_C
>> [   11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0
>>
>> Is this error a big deal or is it fatal?
>>
>
> remove the portb and portc entries in your newly defined cards struct,
> these errors will be removed.
>
> Focus on fixing analog first, enabling portb and portc only complicates
> things.
>
>
>
>> Next I tried to go out and find v4l-cx23885-avcore-01.fw which was at  <
>> http://www.steventoth.net/linux/hvr1800/>
>> http://www.steventoth.net/linux/hvr1800/
>>
>> I loaded this firmware too.  Results are the same until:
>> [   11.254199] firmware: requesting v4l-cx23885-avcore-01.fw
>> [   11.876323] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
>> (16382 bytes)
>> [   11.890444] cx23885[0]: cx23885 based dvb card
>> [   11.920769] cx23885[0]: frontend initialization failed
>> [   11.920771] cx23885_dvb_register() dvb_register failed err = -1
>> [   11.920773] cx23885_dev_setup() Failed to register dvb on VID_C
>> [   11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0
>>
>> So it loaded the firmware, but it didn't help with tuning channels.  Next
>> attempt was to copy the relevant code from the HVR-1500 section to the
>> FusionHDTV7 Dual Express section.  This was just a few lines in
>> /linux/drivers/media/video/cx23885/cx23885-cards.c that you will see a
>> little later in this message.  The dmesg output was
>>
>> [   11.613432] cx23885 0000:08:00.0: PCI INT A -> Link[APC6] -> GSI 16
>> (level, low) -> IRQ
>>  16
>> [   11.613491] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
>> FusionHDTV7 Dual Expres
>> s [card=10,autodetected]
>> [   11.752552] cx23885[0]: i2c bus 0 registered
>> [   11.752824] cx23885[0]: i2c bus 1 registered
>> [   11.752850] cx23885[0]: i2c bus 2 registered
>> [   11.806061] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
>> [   11.815419] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
>> [   11.818004] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
>> [   11.820086] cx23885[0]/0: registered device video0 [v4l2]
>> [   11.820356] cx23885[0]/1: registered ALSA audio device
>> [   11.820360] tuner' 3-0064: tuner type not set
>> [   11.833710] firmware: requesting v4l-cx23885-avcore-01.fw
>> [   12.504759] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
>> (16382 bytes)
>> [   12.518893] cx23885[0]: cx23885 based dvb card
>> [   12.694643] xc5000: Successfully identified at address 0x64
>> [   12.694645] xc5000: Firmware has not been loaded previously
>> [   12.694651] DVB: registering new adapter (cx23885[0])
>> [   12.694654] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB
>> Frontend)...
>> [   12.696204] cx23885[0]: cx23885 based dvb card
>> [   12.741530] xc5000: Successfully identified at address 0x64
>> [   12.741531] xc5000: Firmware has not been loaded previously
>> [   12.741533] DVB: registering new adapter (cx23885[0])
>> [   12.741535] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB
>> Frontend)...
>> [   12.743028] cx23885_dev_checkrevision() Hardware revision = 0xb0
>> [   12.743034] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
>> latency: 0, mmio: 0xf
>> d800000
>> [   12.743039] cx23885 0000:08:00.0: setting latency timer to 64
>>
>> I don't get dvb_register() or dev_checkrevision() errors, but I still
>> can't tune channels.  I suspect that
>> I have loaded the digital stuff, but the analog stuff hasn't been loaded
>> successfully.
>>
>
> Use tvtime and switch he input to svideo or composite, does this work?
>
>
>> Were there things that were HVR1500 specific?  I took a look at
>> /linux/drivers/media/video/cx23885/cx23885-cards.c:
>>
>> [CX23885_BOARD_HAUPPAUGE_HVR1500] = {
>>                .name           = "Hauppauge WinTV-HVR1500",
>> // The section for my card is
>> [CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP] = {
>>                .name           = "DViCO FusionHDTV7 Dual Express",
>>                .porta          = CX23885_ANALOG_VIDEO,
>>  //  I added the following for the dvico card                  .portb  =
>> CX23885_MPEG_DVB,
>>
>
> remove the portb definition for the time being.
>
>  // back to original code
>>                .portc          = CX23885_MPEG_DVB,
>> // the following is probably not compatible with the dvico card
>>                .tuner_type     = TUNER_XC2028,
>>                .tuner_addr     = 0x61, /* 0xc2 >> 1 */
>>
>
> Acccording to the logs, shouldn't this be 0xc8 >> 1? or 0xc4 >> 1?
>
>  // I tried replacing it with the following code.  It is a guess, but the
>> following dmesg makes it seem like a good guess.
>>                .tuner_type     = TUNER_XC5000,
>>                .tuner_addr     = 0x64, /* 0xc2 >> 1 */
>> //  Why is the stuff below referring to 25480?  Probably because that has
>> analog support.
>>
>
> Correct.
>
>  //  Is that why it asks for the v4l-cx23885-avcore-01.fw firmware?
>>
>
> Yes.
>
>  // Why are there three different versions below?  I would think that TV,
>> Composite and SVideo are outputs,
>>
>
> One section for each available input. TVTuner, Composite and Svideo. They
> configure the video mux to the correct signals are received by the video
> hardware.
>
>
>  // but the mythtv tuning setup makes it seem like they are input.
>>                .input          = {{
>>                        .type   = CX23885_VMUX_TELEVISION,
>>                        .vmux   =       CX25840_VIN7_CH3 |
>>                                        CX25840_VIN5_CH2 |
>>                                        CX25840_VIN2_CH1,
>>                        .gpio0  = 0,
>>                }, {
>>                        .type   = CX23885_VMUX_COMPOSITE1,
>>                        .vmux   =       CX25840_VIN7_CH3 |
>>                                        CX25840_VIN4_CH2 |
>>                                        CX25840_VIN6_CH1,
>>                        .gpio0  = 0,
>>                }, {
>>                        .type   = CX23885_VMUX_SVIDEO,
>>                        .vmux   =       CX25840_VIN7_CH3 |
>>                                        CX25840_VIN4_CH2 |
>>                                        CX25840_VIN8_CH1 |
>>                                        CX25840_SVIDEO_ON,
>>                        .gpio0  = 0,
>>                } },
>>
>> With those minor changes I tried loading the cx23885 module again.
>> [   10.977705] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO
>> FusionHDTV7 Dual Express [card=10,autodetected]
>> [   11.116725] cx23885[0]: i2c bus 0 registered
>> [   11.116738] cx23885[0]: i2c bus 1 registered
>> [   11.116752] cx23885[0]: i2c bus 2 registered
>> [   11.158834] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
>> [   11.186669] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
>> [   11.228894] xc5000: Successfully identified at address 0x64
>> [   11.228896] xc5000: Firmware has not been loaded previously
>> [   11.229567] xc5000: waiting for firmware upload
>> (dvb-fe-xc5000-1.1.fw)...
>> [   11.229570] firmware: requesting dvb-fe-xc5000-1.1.fw
>> [   11.301703] xc5000: firmware read 12332 bytes.
>> [   11.301706] xc5000: firmware upload
>> [   11.301708] xc5000: no tuner reset callback function, fatal
>>
>
> You need to modify the tuner_callback function to toggle the correct GPIO
> and reset the tuner hardware, else you will get this error.
>
>  [   13.766578] tuner' 3-0064: chip found @ 0xc8 (cx23885[0])
>> [   13.767308] xc5000: Successfully identified at address 0x64
>> [   13.767309] xc5000: Firmware has not been loaded previously
>> [   13.767979] xc5000: waiting for firmware upload
>> (dvb-fe-xc5000-1.1.fw)...
>> [   13.767980] firmware: requesting dvb-fe-xc5000-1.1.fw
>> [   13.769073] xc5000: firmware read 12332 bytes.
>> [   13.769074] xc5000: firmware upload
>> [   13.769075] xc5000: no tuner reset callback function, fatal
>> [   16.238788] xc5000: Successfully identified at address 0x64
>> [   16.238790] xc5000: Firmware has been loaded previously
>> [   17.384118] cx23885[0]/0: registered device video0 [v4l2]
>> [   17.384429] cx23885[0]/1: registered ALSA audio device
>> [   19.479469] firmware: requesting v4l-cx23885-avcore-01.fw
>> [   20.084869] cx25840' 4-0044: loaded v4l-cx23885-avcore-01.fw firmware
>> (16382 bytes)
>>
>> Why is this still asking for v4l-cx23885-avcore-01.fw firmware?  I thought
>> that
>>
>
> Because porta is defined as being an analog input.
>
>  my alterations would have changed that?   I could remove it, but
>> I bet it would still be asking for it.  It seems to load the xc5000
>> over and over again so I am guessing my changes were wrong.
>>
>> [   20.098995] cx23885[0]: cx23885 based dvb card
>> [   20.178461] xc5000: Successfully identified at address 0x64
>> [   20.178462] xc5000: Firmware has been loaded previously
>> [   20.178470] DVB: registering new adapter (cx23885[0])
>> [   20.178474] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB
>> Frontend)...
>> [   20.180029] cx23885[0]: cx23885 based dvb card
>> [   20.225399] xc5000: Successfully identified at address 0x64
>> [   20.225400] xc5000: Firmware has been loaded previously
>> [   20.225403] DVB: registering new adapter (cx23885[0])
>> [   20.225404] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB
>> Frontend)...
>> [   20.226909] cx23885_dev_checkrevision() Hardware revision = 0xb0
>> [   20.226915] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
>> latency: 0, mmio: 0xf
>> d800000
>> [   20.226920] cx23885 0000:08:00.0: setting latency timer to 64
>>
>> Again I don't get dvb_register() or dev_checkrevision() errors, but I
>> still can't tune channels.
>>
>
> Try tvtime, and switch tvtime to use the composite or svideo inputs
> connected to a video source. Does this help?
>
>  What should go here for my card?
>>               .tuner_type     = ?
>>               .tuner_addr     = ?
>>
>> As you can see I have made several attempts to dive into the code and
>> understand the error messages.  I have tried to identify problem areas so
>> that someone more familiar with the code could possibly see what the errors
>> may be.
>>
>
> Good good. Disable all of the portb and portc code. Focus on getting analog
> svideo or composite working first. After this the tuner changes should be
> small.
>
> Once analog is working correctly, digital can be enabled.
>
> Thanks Tim,
>
> - Steve
>
>
I followed you advice and changed the tuner to 0xc8 >> 1.  I get a warning
about outdated support for tuners and a request for xc3028-v27.fw.  I went
looking for the file, but could not find it.  Any ideas?  I still cannot
tune channels with tvtime.  Thanks for your help.  My dmesg output is below.

[   11.066472] cx23885 driver version 0.0.1 loaded
[   11.067254] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16
[   11.067257] cx23885 0000:08:00.0: PCI INT A -> Link[APC6] -> GSI 16
(level, low) -> IRQ 16
[   11.067327] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge
WinTV-HVR1500 [card=6,insmod option]
[   11.176039] cx23885[0]: i2c bus 0 registered
[   11.176063] cx23885[0]: i2c bus 1 registered
[   11.176085] cx23885[0]: i2c bus 2 registered
[   11.202476] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt
or not a Hauppauge eeprom.
[   11.202479] cx23885[0]: warning: unknown hauppauge model #0
[   11.202480] cx23885[0]: hauppauge eeprom: model=0
[   11.210785] cx25840' 4-0044: cx25  0-21 found @ 0x88 (cx23885[0])
[   11.236265] tuner' 2-0064: chip found @ 0xc8 (cx23885[0])
[   11.298695] xc2028 2-0064: creating new instance
[   11.298697] xc2028 2-0064: type set to XCeive xc2028/xc3028 tuner
[   11.298699] tuner' 2-0064: ====================== WARNING!
======================
[   11.298701] tuner' 2-0064: Support for tuners in i2c address range 0x64
thru 0x6f
[   11.298702] tuner' 2-0064: will soon be dropped. This message indicates
that your
[   11.298704] tuner' 2-0064: hardware has a Xceive XC3028 tuner at i2c
address 0x64.
[   11.298705] tuner' 2-0064: To ensure continued support for your device,
please
[   11.298706] tuner' 2-0064: send a copy of this message, along with full
dmesg
[   11.298708] tuner' 2-0064: output to v4l-dvb-maintainer@linuxtv.org
[   11.298709] tuner' 2-0064: Please use subject line: "obsolete tuner i2c
address."
[   11.298710] tuner' 2-0064: driver: cx23885[0], addr: 0x64, type: 71
(Xceive XC3028)
[   11.298712] tuner' 2-0064: ====================== WARNING!
======================

The warning gets repeated several times for 2-0064 and 3-0064.

[   11.303497] cx23885[0]/0: registered device video0 [v4l2]
[   11.303770] cx23885[0]/1: registered ALSA audio device
[   11.303779] firmware: requesting xc3028-v27.fw
[   11.329126] xc2028 3-0064: Error: firmware xc3028-v27.fw not found.
[   11.332622] firmware: requesting v4l-cx23885-avcore-01.fw
[   11.333993] cx25840' 4-0044: unable to open firmware
v4l-cx23885-avcore-01.fw
[   11.348605] cx23885_dev_checkrevision() Hardware revision = 0xb0
[   11.348611] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16,
latency: 0, mmio: 0xfd800000
[   11.348617] cx23885 0000:08:00.0: setting latency timer to 64


-- 
--Tim

------=_Part_35438_19114060.1222227915973
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div class="gmail_quote">On Thu, Sep 18, 2008 at 11:53 PM, Steven Toth <span dir="ltr">&lt;<a href="mailto:stoth@linuxtv.org">stoth@linuxtv.org</a>&gt;</span> wrote:<br><blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex;">
<div class="Ih2E3d">Tim Lucas wrote:<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
Please excuse my previous message. &nbsp;I hit the send button too early.<br>
<br>
OK, so I am going to take the advice of others and be persistant. &nbsp;I am trying to add analog support for the<br>
DViCO FusionHDTV7 Dual Express by working with the current code for the HVR-1500. Loading the HVR-1500 driver doesn&#39;t work. I have thoughts about the dmesg output.<br>
<br>
[ &nbsp; 11.088311] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge<br>
WinTV-HVR1500 [card=6,insmod option]<br>
[ &nbsp; 11.224568] cx23885[0]: i2c bus 0 registered<br>
[ &nbsp; 11.224609] cx23885[0]: i2c bus 1 registered<br>
[ &nbsp; 11.224632] cx23885[0]: i2c bus 2 registered<br>
[ &nbsp; 11.251024] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.<br>
[ &nbsp; 11.251026] cx23885[0]: warning: unknown hauppauge model #0<br>
[ &nbsp; 11.251027] cx23885[0]: hauppauge eeprom: model=0<br>
<br>
This makes sense because it is not a hauppauge card, but I think it might be a harmless warning.<br>
</blockquote>
<br></div>
You can ignore the eeprom error, it is not effecting your tests.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
[ &nbsp; 11.268639] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])<br>
[ &nbsp; 11.283305] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 11.285887] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 11.288377] cx23885[0]/0: registered device video0 [v4l2]<br>
[ &nbsp; 11.288653] cx23885[0]/1: registered ALSA audio device<br>
[ &nbsp; 11.288658] tuner&#39; 3-0064: tuner type not set<br>
<br>
2-0064 and 3-0064 are probably the dual digital tuners. &nbsp;3-0064 tuner type is not set because the HVR1500 card<br>
is a single tuner card and so it only sets one tuner. &nbsp;I am guessing that cx25840&#39; 4-0044 has something to<br>
do with the analog support. &nbsp;<br>
[ &nbsp; 11.292131] firmware: requesting v4l-cx23885-avcore-01.fw<br>
[ &nbsp; 11.310299] cx25840&#39; 4-0044: unable to open firmware v4l-cx23885-avcore-01.fw<br>
<br>
Why is it trying to load v4l-cx23885-avcore-01.fw? &nbsp;I have the xc5000 firmware installed from<br>
<a href="http://www.steventoth.net/linux/xc5000/" target="_blank">http://www.steventoth.net/linux/xc5000/</a><br>
because that is the correct firmware for my card.<br>
</blockquote>
<br></div>
If you specify analog .porta in the card struct, it has to load the analog audio encoder firmware. This is why this firmware is loaded.<div class="Ih2E3d"><br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
[ &nbsp; 11.324551] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 11.348947] cx23885[0]: frontend initialization failed<br>
[ &nbsp; 11.348949] cx23885_dvb_register() dvb_register failed err = -1<br>
[ &nbsp; 11.348951] cx23885_dev_setup() Failed to register dvb on VID_C<br>
[ &nbsp; 11.348955] cx23885_dev_checkrevision() Hardware revision = 0xb0<br>
<br>
Is this error a big deal or is it fatal?<br>
</blockquote>
<br></div>
remove the portb and portc entries in your newly defined cards struct, these errors will be removed.<br>
<br>
Focus on fixing analog first, enabling portb and portc only complicates things.<div><div></div><div class="Wj3C7c"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Next I tried to go out and find v4l-cx23885-avcore-01.fw which was at &nbsp;&lt;<a href="http://www.steventoth.net/linux/hvr1800/" target="_blank">http://www.steventoth.net/linux/hvr1800/</a>&gt;<br>
<a href="http://www.steventoth.net/linux/hvr1800/" target="_blank">http://www.steventoth.net/linux/hvr1800/</a><br>
<br>
I loaded this firmware too. &nbsp;Results are the same until:<br>
[ &nbsp; 11.254199] firmware: requesting v4l-cx23885-avcore-01.fw<br>
[ &nbsp; 11.876323] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware<br>
(16382 bytes)<br>
[ &nbsp; 11.890444] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 11.920769] cx23885[0]: frontend initialization failed<br>
[ &nbsp; 11.920771] cx23885_dvb_register() dvb_register failed err = -1<br>
[ &nbsp; 11.920773] cx23885_dev_setup() Failed to register dvb on VID_C<br>
[ &nbsp; 11.920777] cx23885_dev_checkrevision() Hardware revision = 0xb0<br>
<br>
So it loaded the firmware, but it didn&#39;t help with tuning channels. &nbsp;Next attempt was to copy the relevant code from the HVR-1500 section to the FusionHDTV7 Dual Express section. &nbsp;This was just a few lines in /linux/drivers/media/video/cx23885/cx23885-cards.c that you will see a little later in this message. &nbsp;The dmesg output was<br>

<br>
[ &nbsp; 11.613432] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 16 (level, low) -&gt; IRQ<br>
&nbsp;16<br>
[ &nbsp; 11.613491] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Expres<br>
s [card=10,autodetected]<br>
[ &nbsp; 11.752552] cx23885[0]: i2c bus 0 registered<br>
[ &nbsp; 11.752824] cx23885[0]: i2c bus 1 registered<br>
[ &nbsp; 11.752850] cx23885[0]: i2c bus 2 registered<br>
[ &nbsp; 11.806061] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])<br>
[ &nbsp; 11.815419] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 11.818004] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 11.820086] cx23885[0]/0: registered device video0 [v4l2]<br>
[ &nbsp; 11.820356] cx23885[0]/1: registered ALSA audio device<br>
[ &nbsp; 11.820360] tuner&#39; 3-0064: tuner type not set<br>
[ &nbsp; 11.833710] firmware: requesting v4l-cx23885-avcore-01.fw<br>
[ &nbsp; 12.504759] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)<br>
[ &nbsp; 12.518893] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 12.694643] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 12.694645] xc5000: Firmware has not been loaded previously<br>
[ &nbsp; 12.694651] DVB: registering new adapter (cx23885[0])<br>
[ &nbsp; 12.694654] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...<br>
[ &nbsp; 12.696204] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 12.741530] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 12.741531] xc5000: Firmware has not been loaded previously<br>
[ &nbsp; 12.741533] DVB: registering new adapter (cx23885[0])<br>
[ &nbsp; 12.741535] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB Frontend)...<br>
[ &nbsp; 12.743028] cx23885_dev_checkrevision() Hardware revision = 0xb0<br>
[ &nbsp; 12.743034] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf<br>
d800000<br>
[ &nbsp; 12.743039] cx23885 0000:08:00.0: setting latency timer to 64<br>
<br>
I don&#39;t get dvb_register() or dev_checkrevision() errors, but I still can&#39;t tune channels. &nbsp;I suspect that<br>
I have loaded the digital stuff, but the analog stuff hasn&#39;t been loaded successfully.<br>
</blockquote>
<br></div></div>
Use tvtime and switch he input to svideo or composite, does this work?<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Were there things that were HVR1500 specific? &nbsp;I took a look at /linux/drivers/media/video/cx23885/cx23885-cards.c:<br>
<br>
[CX23885_BOARD_HAUPPAUGE_HVR1500] = {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = &quot;Hauppauge WinTV-HVR1500&quot;,<br>
// The section for my card is<br>
[CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP] = {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.name &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; = &quot;DViCO FusionHDTV7 Dual Express&quot;,<br>
&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.porta &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= CX23885_ANALOG_VIDEO,<br>
&nbsp;// &nbsp;I added the following for the dvico card &nbsp;  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.portb &nbsp;= CX23885_MPEG_DVB,<br>
</blockquote>
<br></div>
remove the portb definition for the time being.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
// back to original code<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.portc &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= CX23885_MPEG_DVB,<br>
// the following is probably not compatible with the dvico card<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_type &nbsp; &nbsp; = TUNER_XC2028,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_addr &nbsp; &nbsp; = 0x61, /* 0xc2 &gt;&gt; 1 */<br>
</blockquote>
<br></div>
Acccording to the logs, shouldn&#39;t this be 0xc8 &gt;&gt; 1? or 0xc4 &gt;&gt; 1?<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
// I tried replacing it with the following code. &nbsp;It is a guess, but the following dmesg makes it seem like a good guess.<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_type &nbsp; &nbsp; = TUNER_XC5000,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.tuner_addr &nbsp; &nbsp; = 0x64, /* 0xc2 &gt;&gt; 1 */<br>
// &nbsp;Why is the stuff below referring to 25480? &nbsp;Probably because that has analog support.<br>
</blockquote>
<br></div>
Correct.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
// &nbsp;Is that why it asks for the v4l-cx23885-avcore-01.fw firmware?<br>
</blockquote>
<br></div>
Yes.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
// Why are there three different versions below? &nbsp;I would think that TV, Composite and SVideo are outputs, <br>
</blockquote>
<br></div>
One section for each available input. TVTuner, Composite and Svideo. They configure the video mux to the correct signals are received by the video hardware.<div><div></div><div class="Wj3C7c"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
// but the mythtv tuning setup makes it seem like they are input.<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.input &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;= {{<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_TELEVISION,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN5_CH2 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN2_CH1,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_COMPOSITE1,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN6_CH1,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;}, {<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.type &nbsp; = CX23885_VMUX_SVIDEO,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.vmux &nbsp; = &nbsp; &nbsp; &nbsp; CX25840_VIN7_CH3 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN4_CH2 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_VIN8_CH1 |<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;CX25840_SVIDEO_ON,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;.gpio0 &nbsp;= 0,<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;} },<br>
<br>
With those minor changes I tried loading the cx23885 module again.<br>
[ &nbsp; 10.977705] CORE cx23885[0]: subsystem: 18ac:d618, board: DViCO FusionHDTV7 Dual Express [card=10,autodetected]<br>
[ &nbsp; 11.116725] cx23885[0]: i2c bus 0 registered<br>
[ &nbsp; 11.116738] cx23885[0]: i2c bus 1 registered<br>
[ &nbsp; 11.116752] cx23885[0]: i2c bus 2 registered<br>
[ &nbsp; 11.158834] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])<br>
[ &nbsp; 11.186669] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 11.228894] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 11.228896] xc5000: Firmware has not been loaded previously<br>
[ &nbsp; 11.229567] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...<br>
[ &nbsp; 11.229570] firmware: requesting dvb-fe-xc5000-1.1.fw<br>
[ &nbsp; 11.301703] xc5000: firmware read 12332 bytes.<br>
[ &nbsp; 11.301706] xc5000: firmware upload<br>
[ &nbsp; 11.301708] xc5000: no tuner reset callback function, fatal<br>
</blockquote>
<br></div></div>
You need to modify the tuner_callback function to toggle the correct GPIO and reset the tuner hardware, else you will get this error.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
[ &nbsp; 13.766578] tuner&#39; 3-0064: chip found @ 0xc8 (cx23885[0])<br>
[ &nbsp; 13.767308] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 13.767309] xc5000: Firmware has not been loaded previously<br>
[ &nbsp; 13.767979] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.1.fw)...<br>
[ &nbsp; 13.767980] firmware: requesting dvb-fe-xc5000-1.1.fw<br>
[ &nbsp; 13.769073] xc5000: firmware read 12332 bytes.<br>
[ &nbsp; 13.769074] xc5000: firmware upload<br>
[ &nbsp; 13.769075] xc5000: no tuner reset callback function, fatal<br>
[ &nbsp; 16.238788] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 16.238790] xc5000: Firmware has been loaded previously<br>
[ &nbsp; 17.384118] cx23885[0]/0: registered device video0 [v4l2]<br>
[ &nbsp; 17.384429] cx23885[0]/1: registered ALSA audio device<br>
[ &nbsp; 19.479469] firmware: requesting v4l-cx23885-avcore-01.fw<br>
[ &nbsp; 20.084869] cx25840&#39; 4-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)<br>
<br>
Why is this still asking for v4l-cx23885-avcore-01.fw firmware? &nbsp;I thought that<br>
</blockquote>
<br></div>
Because porta is defined as being an analog input.<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
my alterations would have changed that? &nbsp; I could remove it, but<br>
I bet it would still be asking for it. &nbsp;It seems to load the xc5000<br>
over and over again so I am guessing my changes were wrong.<br>
<br>
[ &nbsp; 20.098995] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 20.178461] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 20.178462] xc5000: Firmware has been loaded previously<br>
[ &nbsp; 20.178470] DVB: registering new adapter (cx23885[0])<br>
[ &nbsp; 20.178474] DVB: registering frontend 0 (Samsung S5H1411 QAM/8VSB Frontend)...<br>
[ &nbsp; 20.180029] cx23885[0]: cx23885 based dvb card<br>
[ &nbsp; 20.225399] xc5000: Successfully identified at address 0x64<br>
[ &nbsp; 20.225400] xc5000: Firmware has been loaded previously<br>
[ &nbsp; 20.225403] DVB: registering new adapter (cx23885[0])<br>
[ &nbsp; 20.225404] DVB: registering frontend 1 (Samsung S5H1411 QAM/8VSB Frontend)...<br>
[ &nbsp; 20.226909] cx23885_dev_checkrevision() Hardware revision = 0xb0<br>
[ &nbsp; 20.226915] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xf<br>
d800000<br>
[ &nbsp; 20.226920] cx23885 0000:08:00.0: setting latency timer to 64<br>
<br>
Again I don&#39;t get dvb_register() or dev_checkrevision() errors, but I still can&#39;t tune channels. <br>
</blockquote>
<br></div>
Try tvtime, and switch tvtime to use the composite or svideo inputs connected to a video source. Does this help?<div class="Ih2E3d"><br>
<br>
<blockquote class="gmail_quote" style="margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
What should go here for my card?<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .tuner_type &nbsp; &nbsp; = ?<br>
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; .tuner_addr &nbsp; &nbsp; = ?<br>
<br>
As you can see I have made several attempts to dive into the code and understand the error messages. &nbsp;I have tried to identify problem areas so that someone more familiar with the code could possibly see what the errors may be.<br>

</blockquote>
<br></div>
Good good. Disable all of the portb and portc code. Focus on getting analog svideo or composite working first. After this the tuner changes should be small.<br>
<br>
Once analog is working correctly, digital can be enabled.<br>
<br>
Thanks Tim,<br>
<br>
- Steve<br>
<br>
</blockquote></div><div><br></div><div>I followed you advice and changed the tuner to 0xc8 &gt;&gt; 1. &nbsp;I get a warning about outdated support for tuners and a request for&nbsp;xc3028-v27.fw. &nbsp;I went looking for the file, but could not find it. &nbsp;Any ideas? &nbsp;I still cannot tune channels with tvtime. &nbsp;Thanks for your help. &nbsp;My dmesg output is below.</div>
<div><br></div><div>[ &nbsp; 11.066472] cx23885 driver version 0.0.1 loaded</div><div>[ &nbsp; 11.067254] ACPI: PCI Interrupt Link [APC6] enabled at IRQ 16</div><div>[ &nbsp; 11.067257] cx23885 0000:08:00.0: PCI INT A -&gt; Link[APC6] -&gt; GSI 16 (level, low) -&gt; IRQ 16</div>
<div>[ &nbsp; 11.067327] CORE cx23885[0]: subsystem: 18ac:d618, board: Hauppauge WinTV-HVR1500 [card=6,insmod option]</div><div>[ &nbsp; 11.176039] cx23885[0]: i2c bus 0 registered</div><div>[ &nbsp; 11.176063] cx23885[0]: i2c bus 1 registered</div>
<div>[ &nbsp; 11.176085] cx23885[0]: i2c bus 2 registered</div><div>[ &nbsp; 11.202476] tveeprom 2-0050: Encountered bad packet header [ff]. Corrupt or not a Hauppauge eeprom.</div><div>[ &nbsp; 11.202479] cx23885[0]: warning: unknown hauppauge model #0</div>
<div>[ &nbsp; 11.202480] cx23885[0]: hauppauge eeprom: model=0</div><div>[ &nbsp; 11.210785] cx25840&#39; 4-0044: cx25 &nbsp;0-21 found @ 0x88 (cx23885[0])</div><div>[ &nbsp; 11.236265] tuner&#39; 2-0064: chip found @ 0xc8 (cx23885[0])</div>
<div>[ &nbsp; 11.298695] xc2028 2-0064: creating new instance</div><div>[ &nbsp; 11.298697] xc2028 2-0064: type set to XCeive xc2028/xc3028 tuner</div><div>[ &nbsp; 11.298699] tuner&#39; 2-0064: ====================== WARNING! ======================</div>
<div>[ &nbsp; 11.298701] tuner&#39; 2-0064: Support for tuners in i2c address range 0x64 thru 0x6f</div><div>[ &nbsp; 11.298702] tuner&#39; 2-0064: will soon be dropped. This message indicates that your</div><div>[ &nbsp; 11.298704] tuner&#39; 2-0064: hardware has a Xceive XC3028 tuner at i2c address 0x64.</div>
<div>[ &nbsp; 11.298705] tuner&#39; 2-0064: To ensure continued support for your device, please</div><div>[ &nbsp; 11.298706] tuner&#39; 2-0064: send a copy of this message, along with full dmesg</div><div>[ &nbsp; 11.298708] tuner&#39; 2-0064: output to <a href="mailto:v4l-dvb-maintainer@linuxtv.org">v4l-dvb-maintainer@linuxtv.org</a></div>
<div>[ &nbsp; 11.298709] tuner&#39; 2-0064: Please use subject line: &quot;obsolete tuner i2c address.&quot;</div><div>[ &nbsp; 11.298710] tuner&#39; 2-0064: driver: cx23885[0], addr: 0x64, type: 71 (Xceive XC3028)</div><div>[ &nbsp; 11.298712] tuner&#39; 2-0064: ====================== WARNING! ======================</div>
<div><br></div><div>The warning gets repeated several times for 2-0064 and 3-0064.</div><div><br></div><div><div>[ &nbsp; 11.303497] cx23885[0]/0: registered device video0 [v4l2]</div><div>[ &nbsp; 11.303770] cx23885[0]/1: registered ALSA audio device</div>
<div>[ &nbsp; 11.303779] firmware: requesting xc3028-v27.fw</div><div>[ &nbsp; 11.329126] xc2028 3-0064: Error: firmware xc3028-v27.fw not found.</div><div>[ &nbsp; 11.332622] firmware: requesting v4l-cx23885-avcore-01.fw</div><div>[ &nbsp; 11.333993] cx25840&#39; 4-0044: unable to open firmware v4l-cx23885-avcore-01.fw</div>
<div>[ &nbsp; 11.348605] cx23885_dev_checkrevision() Hardware revision = 0xb0</div><div>[ &nbsp; 11.348611] cx23885[0]/0: found at 0000:08:00.0, rev: 2, irq: 16, latency: 0, mmio: 0xfd800000</div><div>[ &nbsp; 11.348617] cx23885 0000:08:00.0: setting latency timer to 64</div>
<div><br></div></div><div><br></div>-- <br> --Tim<br>
</div>

------=_Part_35438_19114060.1222227915973--


--===============1446408755==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1446408755==--
