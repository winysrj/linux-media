Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53061 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab0HBVCF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 17:02:05 -0400
Received: by iwn7 with SMTP id 7so4407776iwn.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 14:02:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1280750394.1361.87.camel@gagarin>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	<1280741544.1361.17.camel@gagarin>
	<AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
	<AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
	<1280750394.1361.87.camel@gagarin>
Date: Tue, 3 Aug 2010 09:02:04 +1200
Message-ID: <AANLkTi=V3eKuJ1jXPcBuSxUy6djCoK4q2pR-V0zo_cMS@mail.gmail.com>
Subject: Re: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: Shane Harrison <shane.harrison@paragon.co.nz>
To: lawrence rust <lawrence@softsystem.co.uk>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 2, 2010 at 11:59 PM, lawrence rust
<lawrence@softsystem.co.uk> wrote:
> On Mon, 2010-08-02 at 22:19 +1200, Shane Harrison wrote:
> [snip]

>> I am not ruling out initialisation problems with the WM8775 but I do
>> always seem to get an I2S output from it that has data in it that
>> reflects the input.  However it could be the wrong variant of I2S or
>> some other configuration that isn't set right.
>
> Currently in wm8775.c line 223, R11 is set to 0x21 which is 24-bit left
> justified mode.  This is wrong, it should be i2s mode (0x22).  My patch
> correctly sets this register and also disables ALC mode which is
> irrelevant when setting input level via ALSA and can cause hiss during
> quiet sections.
>
>> Strange how eventually
>> I do get audio (albeit mixed with the TV source it appears) simply by
>> looping thru and changing input sources with v4l2-ctl.
>
> Probably switching glitches eventually hit the right data
> synchronisation format.
>
>> I note that the Nova-S doesn't have the hardware MPEG encoding
>
> Correct.
>
>>  so
>> still hoping someone can enlighten me on the audio path when using
>> that chip.
>
> When a Blackbird cx23416 MPEG encoder is fitted, i2s audio data from the
> wm8775 is routed through the cx23883.  The i2s output of the cx23883 is
> enabled by the function set_audio_finish() in cx88-tvaudio.c line 148.
> The cx23416 can accept stereo Sony I2S format audio data when quoting
> from the Conexant datasheet "running its AILR sync signal through an
> inverting flip-flop, clocked by an inverted AICKIN".
>
> -- Lawrence Rust
>
>
>
Yes we had noticed that the WM8775 was in left justified rather than
I2S and had corrected that already.

Thanks for the audio path info.  While you are on a roll, a few more questions ?
1) So do you know how the I2S input (from WM8775) is looped back to
the I2S output that is fed to the MPEG encoder?  I can only assume in
software?  I note that the driver has a comment re. using passthrough
mode in the CX2388x but actually uses normal mode which isn't a
loopback.  Hence something else must generate the I2S output source.
2)  I interpreted the following note in the CX23416 datasheet slightly
differently than you:
       "The CX23416 audio input interface is designed to work with most commonly
       available audio analog-to-digital converters (ADCs) that are
compatible with the Sony
       I2S data format. An I2S-compatible audio part can be supported
by running its AILR
       sync signal through an inverting flip-flop, clocked by an
inverted AICKIN, before
       passing it to the CX23416.
I assumed it was saying it accepted standard Sony variant but you
could connect to Philips I2S if you used a flip-flop to invert and
synchronise with the AICKIN.  I did notice that the HVR1300 board has
a footprint for an IC that is connected to the I2S outputs in some
manner.  I wondered what this was - does something need to be fitted
then to make these two devices talk directly?  I also note that the
driver sets the I2S input to be Philips (as output by the WM8775) and
the I2S output as Sony which seems like an attempt to talk directly.
A bit confused here.....
3) Given I am getting audio sometimes in the MPEG2 stream, is it using
another path into the CX23416.  The idea of getting lucky on switching
glitches seems improbable on the I2S interface since once I get audio
I continue to have it until a hard reboot.  Switching glitches and
race conditions on the control interfaces being successful every so
often I could buy.

Still to try the patch - will let you know.  Unfortunately our
HVR-1300 is in the process of being swapped out since the supplier
wanted to try swapping boards first :-(

Cheers
Shane
