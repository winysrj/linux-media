Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from hu-out-0506.google.com ([72.14.214.225])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bcjenkins@tvwhere.com>) id 1K6Uo9-0008Jp-0W
	for linux-dvb@linuxtv.org; Wed, 11 Jun 2008 20:12:29 +0200
Received: by hu-out-0506.google.com with SMTP id 23so5090323huc.11
	for <linux-dvb@linuxtv.org>; Wed, 11 Jun 2008 11:12:25 -0700 (PDT)
Message-ID: <de8cad4d0806111112v6872df8cx685631a753ac0a29@mail.gmail.com>
Date: Wed, 11 Jun 2008 14:12:25 -0400
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <1213141323.3196.33.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Disposition: inline
References: <de8cad4d0806101321x659cdec7n77714ba6e69cb563@mail.gmail.com>
	<484EE2EC.40501@linuxtv.org>
	<200806101419.09700.linuxdreas@launchnet.com>
	<1213141323.3196.33.camel@palomino.walls.org>
Subject: Re: [linux-dvb] HVR-1600 multiple cards question
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

Appears to be a defective card. Removing all others didn't resolve,
nor did moving to another slot. Interestingly dmesg is normal compared
to the other cards.. I'll begin the RMA process with Hauppage,
hopefully I won't have to confirm it works in windows..

Scan command was: scan -A 1 -a 0
/usr/share/doc/dvb-utils/examples/scan/atsc/us-ATSC-center-frequencies-8VSB

Thanks for the suggestions,

Brandon

Jun 11 05:16:47 sagetv-server kernel: [    8.780000] Linux video
capture interface: v2.00
Jun 11 05:16:47 sagetv-server kernel: [    8.940000] cx18:  Start
initialization, version 1.0.0
Jun 11 05:16:47 sagetv-server kernel: [    8.940000] cx18-0:
Initializing card #0
Jun 11 05:16:47 sagetv-server kernel: [    8.940000] cx18-0:
Autodetected Hauppauge card
Jun 11 05:16:47 sagetv-server kernel: [    8.940000] ACPI: PCI
Interrupt 0000:05:02.0[A] -> GSI 18 (level, low) -> IRQ 18
Jun 11 05:16:47 sagetv-server kernel: [    8.940000] cx18-0:
Unreasonably low latency timer, setting to 64 (was 32)
Jun 11 05:16:47 sagetv-server kernel: [    8.950000] cx18-0: cx23418
revision 01010000 (B)
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
Hauppauge model 74041, rev C6B2, serial# 3444629
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
MAC address is 00-0D-FE-34-8F-95
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
tuner model is TCL M2523_5N_E (idx 112, type 50)
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
TV standards NTSC(M) (eeprom 0x08)
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
audio processor is CX23418 (idx 38)
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
decoder processor is CX23418 (idx 31)
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] tveeprom 0-0050:
has no radio, has IR receiver, has IR transmitter
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] cx18-0:
Autodetected Hauppauge HVR-1600
Jun 11 05:16:47 sagetv-server kernel: [    9.070000] cx18-0: VBI is
not yet supported
Jun 11 05:16:47 sagetv-server kernel: [    9.300000] tuner 1-0061:
chip found @ 0xc2 (cx18 i2c driver #0-1)
Jun 11 05:16:47 sagetv-server kernel: [    9.300000] cs5345 0-004c:
chip found @ 0x98 (cx18 i2c driver #0-0)
Jun 11 05:16:47 sagetv-server kernel: [    9.480000] tuner-simple
1-0061: creating new instance
Jun 11 05:16:47 sagetv-server kernel: [    9.480000] tuner-simple
1-0061: type set to 50 (TCL 2002N)
Jun 11 05:16:47 sagetv-server kernel: [    9.490000] cx18-0: Disabled
encoder IDX device
Jun 11 05:16:47 sagetv-server kernel: [    9.490000] cx18-0:
Registered device video0 for encoder MPEG (4 MB)
Jun 11 05:16:47 sagetv-server kernel: [    9.490000] DVB: registering
new adapter (cx18)
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] MXL5005S:
Attached at address 0x63
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] DVB: registering
frontend 0 (Samsung S5H1409 QAM/8VSB Frontend)...
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] cx18-0: DVB
Frontend registered
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] cx18-0:
Registered device video32 for encoder YUV (2 MB)
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] cx18-0:
Registered device video24 for encoder PCM audio (1 MB)
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] cx18-0:
Initialized card #0: Hauppauge HVR-1600
Jun 11 05:16:47 sagetv-server kernel: [    9.730000] cx18:  End initialization


On Tue, Jun 10, 2008 at 7:42 PM, Andy Walls <awalls@radix.net> wrote:
> On Tue, 2008-06-10 at 14:19 -0700, Andreas wrote:
>> Am Dienstag, 10. Juni 2008 13:24:12 schrieb Steven Toth:
>> > Brandon Jenkins wrote:
>> > > Greetings,
>> > >
>> > > I currently have 3 HVR-1600 cards installed in my system. I am able to
>> > > get analog signal on all 3, but the ATSC scanning does not return any
>> > > data on the third card. I have swapped cables with a known working
>> > > card, but this does not resolve the issue.
>> > >
>> > > 2 of the cards are brand new, dmesg output seems to indicate no
>> > > issues. Does anyone know if there is an issue with 3 HD tuners? Is
>> > > there a method of trouble shooting I should follow?
>> >
>> > Remove the two working cards and test the failing card, report back.
>>
>> I don't know if it would help in this case, but it is generally a good idea
>> to change PCI slots as well.
>
>
>
> Change one variable at a time.  Either change PCI slots and retest or
> remove two cards and retest.  Don't do both before retesting, as you
> won't know which action "fixed" the problem, if the symptoms go away.
>
> -Andy
>
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
