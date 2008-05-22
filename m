Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 108.203.233.220.exetel.com.au ([220.233.203.108]
	helo=hack.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christian@hack.id.au>) id 1Jz0zc-0000ze-6I
	for linux-dvb@linuxtv.org; Thu, 22 May 2008 04:57:25 +0200
From: "Christian Hack" <christian@hack.id.au>
To: "'Nick Andrew'" <nick-linuxtv@nick-andrew.net>
Date: Thu, 22 May 2008 12:56:35 +1000
Message-ID: <019c01c8bbb7$731d79e0$1c01010a@edmi.local>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_019D_01C8BC0B.44C989E0"
In-Reply-To: <20080521132619.GA27716@tull.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] LifeView TV Walker Twin DVB-T (LR540) Problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.

------=_NextPart_000_019D_01C8BC0B.44C989E0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

> -----Original Message-----
> From: Nick Andrew [mailto:nick-linuxtv@nick-andrew.net] 
> Sent: Wednesday, 21 May 2008 11:26 PM
> 
> On Mon, May 19, 2008 at 07:00:27PM +1000, Christian Hack wrote:
> > Hi guys,
> > 
> > I've got one of these that has been successfully working on 
> my MythDora
> > (based on Fedora 8) machine for the past few months. It 
> didn't ever scan
> > properly though. I was able to use my other cards to 
> populate the channel
> > list. Once the channels were set up, it worked perfectly.
> > 
> > All of sudden it seems to have stopped working.
> 
> What changed? If it's not a hardware problem, then something must have
> changed. Kernel upgraded, USB cable intermittent, firmware 
> file removed
> or renamed, antenna blown off roof, etc...

Nothing that I'm aware of had changed. No kernel change - not even a reboot.
Firmware file is OK. I certainly didn't even touch anything physically.
Antenna is in the roof. I totally understand the concept that something must
have changed though (I'm an engineer)

> I'm suspicious about when you say "didn't ever scan properly". Mine
> didn't scan either. Then I connected it to a proper antenna, and it
> scanned fine.

Well it's possible my signal isn't the best. I see something like 75%
reported in MythTV (not that I see it much since I don't watch Live TV
often). I'm not that keen on upgrading/replacing it just yet. It does work
perfectly with the Two Hauppauge Nova-T PCI cards.

> > Using dvbtune it is unable
> > to lock on to a signal. In MythTV I just get a garbled mess 
> like a very bad
> > signal. The audio is almost intelligble, video is a mess.
> 
> Have you tried tzap? Please post output from tzap and also the kernel
> log messages generated using debug=1 and while tzap is running.

I can't get any extra info with debug=1. I have tried in both
/etc/modprobe.conf and by specifying it on the command line i.e. "modprobe
dvb_usb_m920x debug=1" etc. I am removing dvb_usb tda827x and dvb_usb_m920x
modules before trying each time.

Tzap output (first go is the LR540, second is the Hauppage Nova-T) using the
same aerial:

[root@mythtv tmp]# tzap -c channels.conf -a 2 -f 0 -d 0 "Ten HD"
using '/dev/dvb/adapter2/frontend0' and '/dev/dvb/adapter2/demux0'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal b8b8 | snr c8c8 | ber 0001fffe | unc 00000000 | 
status 00 | signal b8b8 | snr d5d5 | ber 0001fffe | unc 00000000 | 
status 00 | signal b7b7 | snr d3d3 | ber 0001fffe | unc 00000000 | 
status 00 | signal b7b7 | snr d4d4 | ber 0001fffe | unc 00000000 | 

[root@mythtv tmp]# tzap -c channels.conf -a 0 -f 0 -d 0 "Ten HD"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
tuning to 219500000 Hz
video pid 0x0202, audio pid 0x0000
status 00 | signal c8c8 | snr ffff | ber 0001fffe | unc 00000000 | 
status 1f | signal c9c9 | snr ffff | ber 0000000e | unc 00000000 |
FE_HAS_LOCK
status 1f | signal c9c9 | snr fefe | ber 00000014 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal c9c9 | snr fefe | ber 00000010 | unc 00000000 |
FE_HAS_LOCK
status 1f | signal c9c9 | snr ffff | ber 00000012 | unc 00000000 |
FE_HAS_LOCK

/var/log/messages is attached from a "modprobe dvb_usb_m920x" onwards. Of
the last two lines the first is the firmware load for the TDA10046 in the
LR540. The second is the load for the TDA10045 in the Nova-T. The only lines
that appear when tuning the LR540 are:

May 22 12:55:53 mythtv kernel: tda1004x: setting up plls for 48MHz sampling
clock
May 22 12:55:55 mythtv kernel: tda1004x: found firmware revision 29 -- ok

CH


------=_NextPart_000_019D_01C8BC0B.44C989E0
Content-Type: text/plain;
	name="var-log-messages.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="var-log-messages.txt"

May 22 12:41:23 mythtv kernel: dvb-usb: found a 'LifeView TV Walker Twin =
DVB-T USB2.0' in warm state.
May 22 12:41:23 mythtv kernel: dvb-usb: will pass the complete MPEG2 =
transport stream to the software demuxer.
May 22 12:41:23 mythtv kernel: DVB: registering new adapter (LifeView TV =
Walker Twin DVB-T USB2.0)
May 22 12:41:23 mythtv kernel: DVB: registering frontend 2 (Philips =
TDA10046H DVB-T)...
May 22 12:41:23 mythtv kernel: dvb-usb: will pass the complete MPEG2 =
transport stream to the software demuxer.
May 22 12:41:23 mythtv kernel: DVB: registering new adapter (LifeView TV =
Walker Twin DVB-T USB2.0)
May 22 12:41:23 mythtv kernel: DVB: registering frontend 3 (Philips =
TDA10046H DVB-T)...
May 22 12:41:23 mythtv kernel: input: IR-receiver inside an USB DVB =
receiver as /class/input/input17
May 22 12:41:23 mythtv kernel: dvb-usb: schedule remote query interval =
to 100 msecs.
May 22 12:41:23 mythtv kernel: dvb-usb: LifeView TV Walker Twin DVB-T =
USB2.0 successfully initialized and connected.
May 22 12:41:23 mythtv kernel: usbcore: registered new interface driver =
dvb_usb_m920x
May 22 12:41:28 mythtv kernel: usbcore: deregistering interface driver =
dvb_usb_m920x
May 22 12:41:28 mythtv kernel: dvb-usb: generic DVB-USB module =
successfully deinitialized and disconnected.
May 22 12:41:28 mythtv kernel: dvb-usb: LifeView TV Walker Twin DVB-T =
USB2.0 successfully deinitialized and disconnected.
May 22 12:42:29 mythtv kernel: dvb-usb: found a 'LifeView TV Walker Twin =
DVB-T USB2.0' in warm state.
May 22 12:42:29 mythtv kernel: dvb-usb: will pass the complete MPEG2 =
transport stream to the software demuxer.
May 22 12:42:29 mythtv kernel: DVB: registering new adapter (LifeView TV =
Walker Twin DVB-T USB2.0)
May 22 12:42:29 mythtv kernel: DVB: registering frontend 2 (Philips =
TDA10046H DVB-T)...
May 22 12:42:29 mythtv kernel: dvb-usb: will pass the complete MPEG2 =
transport stream to the software demuxer.
May 22 12:42:29 mythtv kernel: DVB: registering new adapter (LifeView TV =
Walker Twin DVB-T USB2.0)
May 22 12:42:29 mythtv kernel: DVB: registering frontend 3 (Philips =
TDA10046H DVB-T)...
May 22 12:42:29 mythtv kernel: input: IR-receiver inside an USB DVB =
receiver as /class/input/input18
May 22 12:42:29 mythtv kernel: dvb-usb: schedule remote query interval =
to 100 msecs.
May 22 12:42:29 mythtv kernel: dvb-usb: LifeView TV Walker Twin DVB-T =
USB2.0 successfully initialized and connected.
May 22 12:42:29 mythtv kernel: usbcore: registered new interface driver =
dvb_usb_m920x
May 22 12:42:39 mythtv kernel: tda1004x: setting up plls for 48MHz =
sampling clock
May 22 12:42:41 mythtv kernel: tda1004x: found firmware revision 29 -- =
ok
May 22 12:42:58 mythtv kernel: tda1004x: found firmware revision 2c -- ok
------=_NextPart_000_019D_01C8BC0B.44C989E0
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_NextPart_000_019D_01C8BC0B.44C989E0--
