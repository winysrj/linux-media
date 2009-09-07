Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:25641 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbZIGQMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Sep 2009 12:12:14 -0400
Received: by ey-out-2122.google.com with SMTP id 25so934154eya.19
        for <linux-media@vger.kernel.org>; Mon, 07 Sep 2009 09:12:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090907151809.GA12556@systol-ng.god.lan>
References: <13c90c570909070123r2ba1f5f6w2b288703f5e98738@mail.gmail.com>
	 <13c90c570909070127j11ae6ee2w2aa677529096f820@mail.gmail.com>
	 <20090907124934.GA8339@systol-ng.god.lan>
	 <37219a840909070718q47890f5bgbf76a00ea8826880@mail.gmail.com>
	 <20090907151809.GA12556@systol-ng.god.lan>
Date: Mon, 7 Sep 2009 12:12:15 -0400
Message-ID: <37219a840909070912h3678fb2cm94102d7437bec5df@mail.gmail.com>
Subject: Re: [PATCH] Add support for Zolid Hybrid PCI card
From: Michael Krufky <mkrufky@kernellabs.com>
To: Henk <henk.vergonet@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 7, 2009 at 11:18 AM, <spam@systol-ng.god.lan> wrote:
> On Mon, Sep 07, 2009 at 10:18:46AM -0400, Michael Krufky wrote:
>> >
>> > This patch adds support for Zolid Hybrid TV card. The results are
>> > pretty encouraging DVB reception and analog TV reception are confirmed
>> > to work. Might still need to find the GPIO pin that switches AGC on
>> > the TDA18271 for even better reception.
>> >
>> > see:
>> > http://linuxtv.org/wiki/index.php/Zolid_Hybrid_TV_Tuner
>> > for more information.
>> >
>> > Signed-off-by: Henk.Vergonet@gmail.com
>> >
>> >
>>
>> Henk, thanks for your contribution, but this patch has problems.  This
>> should NOT be merged as it is here.  Please see below:
>
> Thanks for the review.
>
>>
>> #1) It's just a copy of the HVR1120 configuration.  There tuner_config
>> = 3 value is definitely wrong for your board.  To prove my point,
>> notice that you added a case for your board to the switch..case block
>> in saa7134_tda8290_callback.  This will cause
>> saa7134_tda8290_18271_callback to get called, then the default case
>> will do nothing and the entire thing was a no-op.
>>
>> The correct value for your board for tuner_config is 0.  Always try
>> the defaults before blindly copying somebody else's configuration.
>
> You're right, changed tuner_config to zero.
>
>> #2) Card description reads, "NXP Europa DVB-T hybrid reference design"
>> but the card ID is SAA7134_BOARD_ZOLID_HYBRID_PCI.  I suggest to pick
>> one name for the sake of clarity, specifically, the actual board name.
>>  Feel free to indicate that it is based on a reference design in
>> comments.
>>
> Fair enough.
>
>> #3) The change in saa7134-dvb will prevent an HVR1120 and your Zolid
>> board from working together in the same PC.  Please create a new case
>> block for the Zolid board, and create a new configuration structure
>> for the tda10048 -- do not edit the value of static structures
>> on-the-fly, and dont alter configuration of cards other than that of
>> the board that you are adding today.
>
> Ok I was assuming configuration parameters get copied in the tuner
> state.
>
>>
>> #4) Does your card have a saa7131 on it or some other saa713x variant?
>> Is there actually a tda8290 present on the board?  Does the
>> tda8290_attach function sucess or fail?  Please send in a dmesg
>> snippit of the board functioning with your next patch.
>>
> Well the chip is labeled as SAA7131E/03/G, according to the NXP docs its a
> SAA7135 combined with a TDA8295 analog IF demod.
>
> dmesg is attached below.
>
>> #5)  Aren't there multiple versions of this board using different
>> steppings of the tda18271 tuner?  This I am not sure of, but I do
>> recall having issues bringing up the Zolid board months ago -- is this
>> actually working for you?
>
> Well all the references on the net refer to a tda18271/C2 version.
>
> I have tested dvb reception just now, with a good antenna, and it works
> get good audio and video. I still need to test analog reception.
>
> Also I assume selectivity can be better as I assume the V_AGC pin of
> the TDA18271 is connected to some GPIO pin.
>
>>
>> After you resubmit a cleaned up patch, we should see if anybody else
>> out there can test this for you.  A dmesg snippit of the board's
>> driver output would be nice.
>>
>> Cheers,
>>
>> Mike
>
> Can you take a peek at the improved patch below?
>
>
> dmesg:
> [280156.190062] saa7130/34: v4l2 driver version 0.2.15 loaded
> [280156.190234] saa7133[0]: found at 0000:04:00.0, rev: 209, irq: 16, latency: 64, mmio: 0xfebff800
> [280156.190271] saa7133[0]: subsystem: 1131:2004, board: Zolid Hybrid TV Tuner PCI [card=173,autodetected]
> [280156.190445] saa7133[0]: board init: gpio is 400100
> [280156.190481] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [280156.372530] saa7133[0]: i2c eeprom 00: 31 11 04 20 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
> [280156.372579] saa7133[0]: i2c eeprom 10: 00 ff 86 0f ff 20 ff ff ff ff ff ff ff ff ff ff
> [280156.372622] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 b2 ff ff ff ff
> [280156.372664] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372715] saa7133[0]: i2c eeprom 40: ff 35 00 c0 96 10 03 32 21 05 ff ff ff ff ff ff
> [280156.372758] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372800] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372842] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372885] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372927] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.372969] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373012] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373054] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373097] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373139] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373181] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
> [280156.373229] i2c-adapter i2c-3: Invalid 7-bit address 0x7a
> [280156.500405] tuner 3-004b: chip found @ 0x96 (saa7133[0])
> [280156.660034] tda829x 3-004b: setting tuner address to 60
> [280156.738826] tda18271 3-0060: creating new instance
> [280156.820031] TDA18271HD/C2 detected @ 3-0060
> [280159.210047] tda18271: performing RF tracking filter calibration
> [280192.310026] tda18271: RF tracking filter calibration complete
> [280192.420033] tda829x 3-004b: type set to tda8290+18271
> [280200.470374] saa7133[0]: dsp access error
> [280200.602731] saa7133[0]: registered device video0 [v4l2]
> [280200.602842] saa7133[0]: registered device vbi0
> [280200.602945] saa7133[0]: registered device radio0
> [280200.659811] dvb_init() allocating 1 frontend
> [280200.920034] tda829x 3-004b: type set to tda8290
> [280200.960408] tda18271 3-0060: attaching existing instance
> [280200.960426] DVB: registering new adapter (saa7133[0])
> [280200.960440] DVB: registering adapter 0 frontend 0 (NXP TDA10048HN DVB-T)...
> [280201.780031] tda10048_firmware_upload: waiting for firmware upload (dvb-fe-tda10048-1.0.fw)...
> [280201.780054] saa7134 0000:04:00.0: firmware: requesting dvb-fe-tda10048-1.0.fw
> [280201.794323] tda10048_firmware_upload: firmware read 24878 bytes.
> [280201.794342] tda10048_firmware_upload: firmware uploading
> [280207.010051] tda10048_firmware_upload: firmware uploaded
> [280207.404727] saa7134 ALSA driver for DMA sound loaded
> [280207.404763] IRQ 16/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
> [280207.404812] saa7133[0]/alsa: saa7133[0] at 0xfebff800 irq 16 registered as card -1
>
> Here's a new patch:
>

Henk,

Something is up with your mailer, making it difficult to reply to your
emails.... going to some spam account instead of your email address...
Please look into that, maybe set up a reply-to or something.

Anyway, thanks for your responses -- that clears a lot up.  I
recommend to also create your own tda18271 config structure, as I have
a pending pull request that will tweak the tda18271 configuration
within that hcw_tda18271_config structure -- Id hate for your board to
break as a result of using somebody else's config.

About the SAA7131 - correct -- it is a SAA713x combined with a TDA8295
analog IF demod.  I was just checking to see that it was actually what
your board uses.  Looks good to me.

As far as the analog input setup, have you verified that those work
properly, or did you also copy those from the HVR1120 configuration?
If you havent verified those yourself, I recommend removing them from
your patch -- better to not check in untested configurations, as it
may lead others to believe that it should work, causing support
problems for the future.

After you re-submit with the above recommended changes, I'll be happy
to push the patch for you.

Regards,

Mike
