Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from moutng.kundenserver.de ([212.227.126.174])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <shaun@saintsi.co.uk>) id 1JLdAh-0004BS-Sl
	for linux-dvb@linuxtv.org; Sun, 03 Feb 2008 12:38:03 +0100
From: Shaun <shaun@saintsi.co.uk>
To: linux-dvb@linuxtv.org
Date: Sun, 3 Feb 2008 11:37:32 +0000
References: <BC723861-F3E2-4B1C-BA54-D74B8960579A@firshman.co.uk>
	<200802021020.20298.shaun@saintsi.co.uk>
	<1202031541.17762.23.camel@anden.nu>
In-Reply-To: <1202031541.17762.23.camel@anden.nu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802031137.32087.shaun@saintsi.co.uk>
Subject: Re: [linux-dvb] Nova-T 500 issues - losing one tuner
Reply-To: shaun@saintsi.co.uk
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi  People,

Jonas I like your never give up attitude.

I am running on a 3Ghz P4. At the moment I am running with a very slightly =

modified driver. I have my remote plugged in and I sometimes get hundreds o=
f =

messages like the one below:

Jan 23 22:01:00 media-desktop kernel: [ 1062.522880] dib0700: Unknown remote
controller key : =A00 20

I have included a line in linux/drivers/media/dvb/dvb-usb/dib0700_devices.c =

that eats the unknown controller key and prevents the message repeating, as =

was suggested by Jonas.

>From my mythwatcher logs:
[27-1-08 17:02:21] --- Started ---
[27-1-08 19:51:02] --- Started ---
[27-1-08 23:50:20] --- Started ---
[29-1-08 05:41:07] ERROR: Disconnect Detected.
[29-1-08 05:41:07] ACTION: Attempting mythtv-backend restart.
[29-1-08 19:36:37] ERROR: Disconnect Detected.
[29-1-08 19:36:37] ACTION: Attempting mythtv-backend restart.
[30-1-08 04:55:17] ERROR: Disconnect Detected.
[30-1-08 04:55:17] ACTION: Attempting mythtv-backend restart.
[30-1-08 05:00:16] ERROR: Disconnect Detected.
[30-1-08 05:00:16] ACTION: Attempting mythtv-backend restart.
[1-2-08 06:24:17] ERROR: Disconnect Detected.
[1-2-08 06:24:17] ACTION: Attempting mythtv-backend restart.
[1-2-08 20:18:48] ERROR: Disconnect Detected.
[1-2-08 20:18:48] ACTION: Attempting mythtv-backend restart.
[2-2-08 12:24:58] --- Started ---

I have been using the modified driver since [2-2-08 12:24:58].
I have been up for 24 hours with no disconnect. I will let you know how it =

goes. If I do get a disconnect, I will turn on debugging and see how that =

goes.

Cheers,
Shaun =



On Sunday 03 February 2008 09:39:01 Jonas Anden wrote:
> I have a hunch about this problem...
>
> I had this problem (I tink 3 times last weekend) after initially
> updating my hg tree and recompiling the modules. I then turned on full
> debugging for the dib0700 module in order to try to see what happens
> when it goes wrong, but with full debugging on I haven't been able to
> reproduce the problem. I ran with full debugging on from monday to
> saturday and *really* tried to make it go away. I tried starting all
> tuners at once (ie scheduling three programs with the same start time),
> I tried running long recordings, I tried running plenty of retuning, and
> I tried doing it "my normal way" of a few recordings a day. Nothing made
> the tuner die.
>
> So yesterday, I finally gave up in trying to cause the problem. I turned
> debugging back off, and this morning one of the tuners is dead again
> (MythTV stopping at "L__" instead of proceeding to "LMS".)
>
> The *ONLY* change I have made is changing the debugging setting.
>
> This, in combination with the fact that some people see it and some
> don't, leads me to believe that this is timer-induced. Something can't
> keep up. Adding debugging makes the operations slightly slower (the
> module needs to do additional IO to speak to syslogd), and this delay
> seems to be enough to keep it operational.
>
> I don't think this has anything to do with the remote since I have the
> RC feature disabled (I'm using an M$ MCE remote instead).
>
> I set it up with full debugging (options dvb_usb_0700 debug=3D15). This
> will cause a whole bunch of logging in the system logs, but appears to
> keep the tuner alive. I have now changed the debug setting to 1 (only
> 'info' type messages) to see if that also keeps the tuner alive.
>
> My system has a 3.3 Ghz Celeron processor. Shaun, Ben, Nicolas -- what
> kind of systems are you running? If my hunch is correct, I'd expect
> Shaun and Ben to have faster processors than Nicolas since they are
> seeing this issue and Nicolas isn't.
>
>   // J
>
> On Sat, 2008-02-02 at 10:20 +0000, Shaun wrote:
> > On Friday 01 February 2008 21:43:51 Nicolas Will wrote:
> > > On Fri, 2008-02-01 at 21:07 +0000, Ben Firshman wrote:
> > > > Feb  1 20:52:04 mythtv kernel: [   11.072000] dvb-usb: found a
> > > > 'Hauppauge Nova-T 500 Dual DVB-T' in cold state, will try to load a
> > > > firmware Feb  1 20:52:04 mythtv kernel: [   11.132000] dvb-usb:
> > > > downloading firmware from file 'dvb-usb-dib0700-1.10.fw'
> > > > ...
> > > > Feb  1 20:52:04 mythtv kernel: [   11.844000] dvb-usb: found a
> > > > 'Hauppauge Nova-T 500 Dual DVB-T' in warm state.
> > > > Feb  1 20:52:04 mythtv kernel: [   11.844000] dvb-usb: will pass the
> > > > complete MPEG2 transport stream to the software demuxer.
> > > > Feb  1 20:52:04 mythtv kernel: [   11.844000] DVB: registering new
> > > > adapter (Hauppauge Nova-T 500 Dual DVB-T)
> > > > Feb  1 20:52:04 mythtv kernel: [   11.956000] DVB: registering
> > > > frontend 1 (DiBcom 3000MC/P)...
> > > > ...
> > > > Feb  1 20:52:04 mythtv kernel: [   12.500000] dvb-usb: will pass the
> > > > complete MPEG2 transport stream to the software demuxer.
> > > > Feb  1 20:52:04 mythtv kernel: [   12.500000] DVB: registering new
> > > > adapter (Hauppauge Nova-T 500 Dual DVB-T)
> > > > Feb  1 20:52:04 mythtv kernel: [   12.508000] DVB: registering
> > > > frontend 2 (DiBcom 3000MC/P)...
> > > > Feb  1 20:52:04 mythtv kernel: [   13.068000] input: IR-receiver
> > > > inside an USB DVB receiver as /class/input/input2
> > > > Feb  1 20:52:04 mythtv kernel: [   13.068000] dvb-usb: schedule
> > > > remote query interval to 150 msecs.
> > > > Feb  1 20:52:04 mythtv kernel: [   13.068000] dvb-usb: Hauppauge
> > > > Nova-T 500 Dual DVB-T successfully initialized and connected.
> > > >
> > > > Got the tree from the day of your message, and I'm still having
> > > > problems. I'm not the only one either:
> > > >
> > > > http://www.linuxtv.org/pipermail/linux-dvb/2008-January/022629.html
> > > >
> > > > Thanks
> > > >
> > > > Ben
> > > >
> > > > Nicolas Will wrote:
> > > > > On Sun, 2008-01-27 at 14:30 +0000, Ben Firshman wrote:
> > > > >> I am using the (almost) latest SVN version of mythtv. I am using
> > > > >> the v4l-dvb sources from a couple of days back. I have followed
> > > > >> and used the patches that were on (are they in the repos now?):
> > > > >>
> > > > >> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500
> > > > >>
> > > > >> After a short while, one of the tuners dies. I get a "(L__)
> > > > >> Partial Lock" message from mythtv. If it's any help, I also get
> > > > >> messages like:
> > > > >>
> > > > >> DVB: frontend 0 frequency limits undefined - fix the driver
> > > > >>
> > > > >> In syslog, but that's even when it's working fine.
> > > > >
> > > > > Weird issue that I never encountered since I started using the ca=
rd
> > > > > in August...
> > > > >
> > > > > Get a brand new tree, there have been a lot of changes very
> > > > > recently, merge of old patches and new fixes too.
> > > > >
> > > > > Make sure that you have the right firmware too.
> > > > >
> > > > > Then do a cold reboot, going through a power down, then check in
> > > > > the messages that the card was found in a cold state before a
> > > > > firmware upload.
> > > > >
> > > > > http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-NOVA-T-500#Firm=
wa
> > > > >re
> > > > >
> > > > > Nico
> > >
> > > Ben,
> > >
> > > I'm at loss for an explanation. I'm just not experiencing your proble=
m.
> > >
> > > People with a better brain than mine will need to jump in.
> > >
> > > Have you tried turning debugging on for the modules, and get a more
> > > verbose log from mythbackend ?
> > >
> > > Nico
> > >
> > >
> > > _______________________________________________
> > > linux-dvb mailing list
> > > linux-dvb@linuxtv.org
> > > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> >
> > Hi,
> >
> > I have been experiencing this problem for a few months now. I think it =
is
> > related to the use of the remote control. I have written a workaround
> > application for Ubuntu Linux that scans for a mt2060 error in the dmesg
> > log. If found it will restart mythtv-backend.  This seems to mitigate t=
ha
> > problem.
> >
> > I can't wait for this issue to be fixed.
> >
> > Shaun
> >
> > _______________________________________________
> > linux-dvb mailing list
> > linux-dvb@linuxtv.org
> > http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
