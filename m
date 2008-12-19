Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from asmtp1.iomartmail.com ([62.128.201.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <lawrence@softsystem.co.uk>) id 1LDdML-0001qp-Di
	for linux-dvb@linuxtv.org; Fri, 19 Dec 2008 12:17:34 +0100
From: Lawrence Rust <lawrence@softsystem.co.uk>
To: Darron Broad <darron@kewl.org>
Date: Fri, 19 Dec 2008 12:16:37 +0100
References: <200812181804.34557.lawrence@softsystem.co.uk>
	<200812191127.35952.lawrence@softsystem.co.uk>
	<7882.1229683311@kewl.org>
In-Reply-To: <7882.1229683311@kewl.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812191216.38259.lawrence@softsystem.co.uk>
Cc: Linux-dvb list <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Nova-S-Plus audio line input
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

On Friday 19 December 2008 11:41:51 Darron Broad wrote:
> In message <200812191127.35952.lawrence@softsystem.co.uk>, Lawrence Rust
> wrote:
>
> Hiya.
>
> >On Thursday 18 December 2008 20:17:41 Darron Broad wrote:
> >> hi
> >>
> >> >I have a Hauppauge Nova-S-plus PCI card and it works great with
> >> > satellite reception.  However, I would also like to use it with an
> >> > external DVB-T box that outputs composite video and line audio but
> >> > when I select the composite video input I can see a picture but get no
> >> > sound.
> >> >
> >> >I'm using kernel version 2.6.24 so I dug around those sources and I see
> >> > in cx88-cards.c that there's no provision for line audio in.  However,
> >> > the latest v4l top of tree sources have added support for I2S audio
> >> > input and 'audioroute's.
> >> >
> >> >So I modded my 2.6.24 sources to support the external ADC and enable
> >> > I2S audio input using the struct cx88_board cx88_boards.extadc flag,
> >> > similar to the changes made in the current top of tree.  This now
> >> > means that I can watch DVB-T :-)  I don't believe the changes affect
> >> > any other cards.
> >> >
> >> >I would like to see support added for the Nova-S-Plus audio line input
> >> > in the kernel tree asap.  What's the best way of achieving this?  I
> >> > can supply a diff for 2.6.24 or the current top of tree.
> >>
> >> I would be interested to see what changes you made to achieve this
> >> and am able to test. Please share your patch for testing.
> >>
> >> Thanks
> >> darron
> >
> >Diffs for linux kernel 2.6.24 andcd out/linux.x86/release/bin/src the 
current v4l tip attached.
> >
> >The change for the current top of tree is minimal - just a few lines in
> > the static configuration data of cx88-cards.c.
> >
> >The changes for 2.6.24 parallel the changes made for audioroutes in the
> >current tip.
> >
> >Note the changes to cx88_alsa.c to remove the tuner volume control if
> > there's no TV tuner and to re-group the switches more logically.  I was
> > thinking of adding some code to adjust the WM8775 gain - what do you
> > think?
> >
> >HTH.
>
> Thanks for that Lawrence. I will test this soon.
>
> With regard to the gain control on the WM8775, perhaps you can
> look at this:
>
> http://hg.kewl.org/v4l-dvb-test/shortlog
>
> You can find some patches here:
> http://hg.kewl.org/v4l-dvb-test/rev/c1d603af3bef
> http://hg.kewl.org/v4l-dvb-test/rev/302d51bf2baf
> http://hg.kewl.org/v4l-dvb-test/rev/8b24b8211fc9
>
> Which sound like they would do what you desire?
>
> I should rebuild these patches soon to for better testing purposes
> but in the meantime please test if you are interested.

Yes, these patches look _exactly_ like what I was thinking of.  The control of 
audio overload was my main priority, together with a nice ALSA interface.  
I'll give them a try and report back.

NB I can build current top of tree, but I'm only testing with my Nova card on 
kernel 2.6.24.  I don't have a proper test m/c setup to try anything too 
bleeding edge.

Thanks.

-- Lawrence Rust

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
