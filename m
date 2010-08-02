Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63029 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575Ab0HBKTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Aug 2010 06:19:48 -0400
Received: by iwn7 with SMTP id 7so4032741iwn.19
        for <linux-media@vger.kernel.org>; Mon, 02 Aug 2010 03:19:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
References: <AANLkTimD-BCmN+3YUykUCH0fdNagw=wcUu1g+Z87N_5W@mail.gmail.com>
	<1280741544.1361.17.camel@gagarin>
	<AANLkTinHK8mVwrCnOZTUMsHVGTykj8bNdkKwcbMQ8LK_@mail.gmail.com>
Date: Mon, 2 Aug 2010 22:19:48 +1200
Message-ID: <AANLkTi=M2wVY3vL8nGBg-YqUtRidBahpE5OXbjr5k96X@mail.gmail.com>
Subject: Fwd: No audio in HW Compressed MPEG2 container on HVR-1300
From: Shane Harrison <shane.harrison@paragon.co.nz>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 2, 2010 at 9:32 PM, lawrence rust <lawrence@softsystem.co.uk> wrote:
>
> On Mon, 2010-08-02 at 14:15 +1200, Shane Harrison wrote:
> > Hi There,
> >
> > I am having a problem with getting an audio stream present in the
> > MPEG2 stream from an HVR-1300 card.
>
> [snip]
>
> > Problem
> > ~~~~~~
> > The delivered MPEG-2 stream generally has no audio component. Mplayer
> > reports "no audio found".
> >
> > The same problem exists for both TV input and composite input.  By
> > repeatedly switching between the TV input and the Composite input we
> > can eventually get an audio component in the MPEG-2 stream.
> > Thereafter we always get the audio component until a power off and
> > restart.  Simply rebooting (no power off) seems to still leave things
> > in a state where the audio component is in the MPEG-2 stream.
> >
> > There is a second problem, the audio stream always contains white
> > noise (I assume TV tuner noise - we don't have it tuned nor an aerial
> > attached) mixed with the signal applied to the analog in ports.
> >
> > Analysis
> > ~~~~~~
> > The most likely scenario is that the hardware is not being initialised
> > correctly most of the time, once it is initialised correctly then it
> > works thereafter.  Unfortunately it is difficult to determine the
> > actual audio path being used.  Clearly the audio comes into the WM8775
> > (DAC) via a bus switch that switches between the composite/audio on
> > the back panel and the white header.  It then enters the CX2388x via
> > the I2S input pins.  We initially assumed that the audio was then
> > routed through to the CX23416 (MPEG Encoder) via the I2S output pins
> > of the CX2388x, but we have begun to doubt this assumption since the
> > CX2388x is set in normal mode by the drivers and the captured audio
> > doesn't reflect the bit patterns we see on the I2S Data Out line using
> > an oscilloscope.  That is, when we apply *no* signal to the analog
> > input, the I2S Dout line is "quiet" yet we hear white noise.
> >
> > Questions
> > ~~~~~~~~
> > 1) Anyone have any similar experiences?
>
> This sounds very much like the problems that I had with my Nova-S-plus
> card while developing a patch to capture line-in audio with composite
> video.  Looking at the docs for the wm8775 it appeared that it wasn't
> being correctly initialised.  I also found need to change the cx88 code
> to mute/un-mute audio in.  Maybe you should try applying this patch, I
> posted it to this group on Saturday - see.
>
> http://www.mail-archive.com/linux-media@vger.kernel.org/msg21030.html
>
> -- Lawrence Rust
>
>
Thanks Lawrence, will give that a whirl tomorrow and the muting idea
might be important in this case as well.  Wierd you posted Saturday
the day after I last worked on this and looked at the archives :-)

I am not ruling out initialisation problems with the WM8775 but I do
always seem to get an I2S output from it that has data in it that
reflects the input.  However it could be the wrong variant of I2S or
some other configuration that isn't set right.  Strange how eventually
I do get audio (albeit mixed with the TV source it appears) simply by
looping thru and changing input sources with v4l2-ctl.

I note that the Nova-S doesn't have the hardware MPEG encoding so
still hoping someone can enlighten me on the audio path when using
that chip.

Cheers
Shane
