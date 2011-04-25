Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50545 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab1DYBaz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2011 21:30:55 -0400
Received: by bwz15 with SMTP id 15so1351263bwz.19
        for <linux-media@vger.kernel.org>; Sun, 24 Apr 2011 18:30:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303258890.2249.84.camel@localhost>
References: <BANLkTikqBPdr2M8jyY1zmu4TPLsXo0y5Xw@mail.gmail.com>
	<BANLkTi=dVYRgUbQ5pRySQLptnzaHOMKTqg@mail.gmail.com>
	<1302015521.4529.17.camel@morgan.silverblock.net>
	<BANLkTimQkDHmDsqSsQ9jiYnHWXnc7umeWw@mail.gmail.com>
	<1302481535.2282.61.camel@localhost>
	<20110411163239.GA4324@mgebm.net>
	<20110418141514.GA4611@mgebm.net>
	<ac791492-7bc5-4a78-92af-503dda599346@email.android.com>
	<20110418224855.GB4611@mgebm.net>
	<1303215523.2274.27.camel@localhost>
	<20110419171220.GA4883@mgebm.net>
	<1303258890.2249.84.camel@localhost>
Date: Sun, 24 Apr 2011 21:30:53 -0400
Message-ID: <BANLkTinsn4S52zuwaiTRXwHHHjJcSbCikA@mail.gmail.com>
Subject: Re: HVR-1600 (model 74351 rev F1F5) analog Red Screen
From: Eric B Munson <emunson@mgebm.net>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Michael Krufky <mkrufky@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	mchehab@infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Apr 19, 2011 at 8:21 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Tue, 2011-04-19 at 13:12 -0400, Eric B Munson wrote:
>> On Tue, 19 Apr 2011, Andy Walls wrote:
>>
>
>> > > > Have you used v4l2-ctl or ivtv-tune to tune to the proper tv channel
>> > > (the driver defaults to US channel 4)?
>> > >
>> > > emunson@grover:~$ v4l2-ctl -F
>> > > Frequency: 0 (0.000000 MHz)
>> > > emunson@grover:~$ v4l2-ctl -f 259.250
>> > > Frequency set to 4148 (259.250000 MHz)
>> > > emunson@grover:~$ v4l2-ctl -F
>> > > Frequency: 0 (0.000000 MHz)
>> >
>> > OK, that doesn't look good.  The tda18271 tuner and/or tda8290 demod
>> > drivers may not be working right.
>
> I looked into this.
>
> Apparently the tda18271 tuner driver doesn't report back analog
> frequency setting.  So reading back 0.00000 MHz is OK.
>
>> > I'll have to look into that later this week.
>> >
>> > BTW, Mike Krufky just submitted some patches that may be relevant:
>> >
>> >     http://kernellabs.com/hg/~mkrufky/tda18271-fix
>> >
>>
>> I have applied these patches and I am still seeing the same problem (frequency
>> still report 0 after being set) and mplayer still closes immediately.
>
> I don't have those patches applied.   I just tested my 74351 HVR-1600
> again tonight, and analog channel 3 works for me.  I don't know what to
> say....
>
>> > >
>> > > > Does v4l2-ctl --log-status still show no signal present for the '843 core in the CX23418?
>> > >
>> > > Yeah,
>> > >    [94465.349721] cx18-0 843: Video signal:              not present
>> >
>> > The tuner or demod isn't tuning to a channel or getting a signal.
>> >
>> > Can you try channel 3 (61.250 MHz)?  That one works for me.
>>
>> Still shows not present on channel 3.
>
> OK.  Tonight was the first time I have *ever* been able to reproduce the
> "red screen" out of a CX23418.
>
> I am fairly sure the red screen happens because of some kernel bug or
> PCI bus problem that ends up corrupting the CX23418 registers
> responsible for configuring the CX25843 A/V core inside of the CX23418.
> The '843 core is responsible for digitizing the analog video, so when it
> stops functioning, the result is a red screen. I guess the root cause
> could also happen due to some thermal or power condition causes the '843
> core to stop, but I think that is less likely.
>
> Anyway, when you're going to get a red screen, the '843 core will always
> indicate "cx18-N 843: Video signal:    not present", even if there is a
> signal present from the analog tuner and demodulator chips.
>
>
>> > > > Does mplayer /dev/videoN -cache 8192 have a tv station when set to the rf analog input with v4l2-ctl?
>> > >
>> > > emunson@grover:~$ mplayer /dev/video0 -cache 8192
>> > > MPlayer 1.0rc4-4.4.5 (C) 2000-2010 MPlayer Team
>> > >
>> > > Playing /dev/video0.
>> > > Cache fill:  0.00% (0 bytes)
>> > >
>> > >
>> > > Exiting... (End of file)
>> >
>> > Hmmm.  I would have expected at least a black picture with snow, if not
>> > tuned to a channel.
>> >
>> > Does analog S-Video or Composite work?
>>
>> Unfortunately, I do not have anything I can use to test these.  The card only
>> takes coaxial or S-Video input and I don't have any sort of S-Video cables or
>> converters.
>
> With new HVR-1600 from Hauppauge, an adapter for plugging a Composite
> RCA cable  into the S-Video jack is in the box.
>
> It looks very much like the one at the end of this thread, but it is
> grey in color:
>
>        http://www.hauppauge.co.uk/board/showthread.php?t=22115
>
> If this is a second hand card, or one bought from e-Bay, etc. have you
> ever tested it in a Windows machine with the Hauppauge Windows drivers?
> (In other words, are you reasonably confident the card is not defective
> or broken.)
>
>
> When testing tonight, I unloaded all the drivers, performed the
> following commands to get verbose debugging, and saved the dmesg:
>
>  # modinfo tuner
>  # modprobe tuner debug=7
>  # modinfo tda8290
>  # modprobe tda8290 debug=7
>  # modinfo tda18271
>  # modprobe tda18271 debug=31
>  # modinfo cx18
>  # modprobe cx18 debug=255
>
>  # ivtv-tune -d /dev/video1 -c3
>  # v4l2-ctl -d /dev/video1 --log-status
>
>  # mplayer /dev/video1 -cache 8192
>
> I'll send you the 138 kB dmesg file off list, so you can see the
> messgaes generated by a functioning 73451 HVR-1600 setup.  Note that the
> card of interest in the dmesg output was 'cx18-1'.
>
> You'll want to look to see that the TDA18271 and TDA8290 related
> messages look the same, to get reasonable assurance that the tuner and
> demodulator chip are being set up properly and repsonding.
>
> If you consistently get "cx18-N 843: Video signal:  not present" in your
> v4l2-ctl --log-status output but the tuner chip configurations look good
> (i.e. closely match the debug output from my machine), then you really
> have a "red screen" problem versus a problem related to the analog
> tuner/demod chips.
>
> The "red screen" will be a tough one to track down.  It's a system level
> issue, likely involving one or more of:
>
> 1. a kernel bug in a driver for some other hardware in your system
> 2. a hardware problem with your PCI chipset when the PCI bus is heavily
> loaded
> 3. a power or thermal condition that causes problems for the HVR-1600
> hardware
>
> I usually start by recommending that all non-critical linux driver
> modules be blacklisted (or not loaded), and booting the system into
> run-level 3 or lower (no X windows), when trying to isolate the cause in
> any one system.
>
> Regards,
> Andy


Sorry for the long silence here, I must have not mentioned it, but the
last round of your patches fixed the red screen problem.  The problem
I have been chasing down since is that the card won't tune into
anything.  All I ever get from it is static in picture and sound.
Even when showing the static v4l2-ctl shows Video signal: not present.
 I bought the card new but no longer have the accessories that came
with it, I will try and find a converter and try that for input.
Trying the card on windows will be tough but I will try and have that
done in a week.  Thanks for all your help and patience. :)

Eric
