Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from serv01.clev11.com ([67.15.157.8])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <erik@and.li>) id 1LTOoD-000240-7S
	for linux-dvb@linuxtv.org; Sat, 31 Jan 2009 23:59:31 +0100
Received: from [82.170.187.5] (port=27974 helo=VENUS)
	by serv01.clev11.com with esmtpa (Exim 4.69)
	(envelope-from <erik@and.li>) id 1LTOo2-00023G-MH
	for linux-dvb@linuxtv.org; Sat, 31 Jan 2009 16:59:18 -0600
From: "Erik de Jong" <erik@and.li>
To: <linux-dvb@linuxtv.org>
Date: Sat, 31 Jan 2009 23:59:24 +0100
Message-ID: <ANEHJIPPEOEEMNLANLDKKEDGDIAA.erik@and.li>
MIME-Version: 1.0
Subject: [linux-dvb] Having trouble getting TechnoTrend TT-Budget S-1500 +
	Mediaguard CAM to work
Reply-To: linux-media@vger.kernel.org
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

Hi all,

I'm trying to get my DVB-S + CAM to work, but I'm running into a dead end
and I have no idea how to further troubleshoot this.

My setup is as follows:

I'm based in the Netherlands
Satellite setup: 2 LNB's, 1 switch
DVB-S Tuner card: TechnoTrend TT-Budget S-1500 + TT-Budget CI
CAM Module: official CanalDigitaal Mediaguard (Rev1.2)
OS: Ubuntu 8.10
Kernel: 2.6.27-9
DVB-apps: version 1.1.1-3 (installed through package manager)

Now, in the interest of full-disclosure I should also mention that I have an
issue switching to the correct LNB, but as far as I know that shouldn't
impact this issue, and I prefer to tackle the CAM issue first. To
troubleshoot, I'm using the channels on the LNB that I _can_ listen to.

Actually the first symptom for me was that I couldn't see the encrypted
channels in Mytht, and the status showed that it couldn't complete a full
lock (where the last letter of the status is a lower case 'c' instead of an
upper case 'C'). Myth's log would simply tell me that the channel is
encrypted. Before posting on the mythtv list I wanted to make sure first
that the CAM actually works...

Here's what I've done so far (I basically followed the steps outlined on the
wiki):

0. The hardware

$ lspci -vnn
03:06.0 Multimedia controller [0480]: Philips Semiconductors SAA7146
[1131:7146] (rev 01)
        Subsystem: Technotrend Systemtechnik GmbH Device [13c2:1017]
        Flags: bus master, medium devsel, latency 32, IRQ 20
        Memory at fdcff000 (32-bit, non-prefetchable) [size=512]
        Kernel driver in use: budget_ci dvb
        Kernel modules: budget-ci, snd-aw2


1. Checked correct loading of modules

$ dmesg | grep DVB
[   14.416076] DVB: registering new adapter (TT-Budget/S-1500 PCI)
[   14.757749] DVB: registering frontend 0 (ST STV0299 DVB-S)...
[   15.384261] dvb_ca adapter 0: DVB CAM detected and initialised
successfully
[   26.908785] dvb_ca adapter 0: DVB CAM detected and initialised
successfully
[   27.800781] dvb_ca adapter 0: DVB CAM detected and initialised
successfully

This looks okayish, although I find the repeated initialisation messages
weird. They don't get repeated too often, if I look back it seems they are
mainly repeated two or three times while the machine is booting, and then
stop.


2. Created channels.conf for Astra 19.2E. There are FTA channels and
encrypted channels that I _should_ be able to watch ... a good enough test
set.

3. Tried to tune to channels

3a. FTA channel

$ szap -r -c ./channels-19E.conf 'Al Jazeera International'
reading channels from file './channels-19E.conf'
zapping to 149 'Al Jazeera International':
sat 0, frequency = 11508 MHz V, symbolrate 22000000, vpid = 0x02c8, apid =
0x02dc
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 00 | signal c080 | snr 9cc9 | ber 0000ff00 | unc fffffffe |
status 1f | signal ed86 | snr f34e | ber 00000302 | unc fffffffe |
FE_HAS_LOCK
status 1f | signal eebc | snr f33c | ber 00000000 | unc fffffffe |
FE_HAS_LOCK
status 1f | signal ed81 | snr f336 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

This is great! I can use mplayer to display the output from
/dev/dvb/adapter0/dvr0 without any issues
The only thing weird is that the 5th column (uncorrected blocks) is
constantly on fffffffe where I understood one would expect something low.
But it doesn't seem to cause any problem at all, so I'm either
misinterpreting this or it's just not an issue.

3b. Encrypted channel that I _should_ be able to watch

$ szap -r -c ./channels-19E.conf 'RTL4'
reading channels from file './channels-19E.conf'
zapping to 1125 'RTL4':
sat 0, frequency = 12343 MHz H, symbolrate 27500000, vpid = 0x0200, apid =
0x0050
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
status 01 | signal dcec | snr d7dc | ber 00002400 | unc fffffffe |
status 1f | signal e0de | snr ec94 | ber 0000020d | unc fffffffe |
FE_HAS_LOCK
status 1f | signal e0ee | snr ecc7 | ber 00000000 | unc fffffffe |
FE_HAS_LOCK

Here's where things get murky... it looks like it has a lock, now how to
check whether it is doing any decrypting?

Now, mplayer does detect a TS file format, but doesn't show anything. Seems
to be correct: I later read that mplayer cannot deal with encrypted
channels. So it looks like one of my assumptions was wrong. I had assumed
that the DVB kernel module would perform some DVB-fu, hand off the
datastream to the CAM, receive the unencrypted stream and output that to
/dev/.../dvr0, but this doesn't seem to be the case.

I have found some older references to ca_zap to deal with encrypted
channels, but this doesn't seem to exist anymore?

So I decided to go ahead and install Kaffeine (and the 60+ libraries needed
for that, I like to keep my install clean, but alas... can't be too picky on
a test machine, anyway Kaffeine seems to be a fine app!). Unfortunately,
Kaffeine has the same behavior: encrypted is fine, encrypted is not.

Also, Kaffeine doesn't seem to let me configure my CAM, which is what I have
seen referred to in some forums. Which makes me doubt that perhaps I have
missed a step somewhere.

That's where I am now. Any suggestions?

Oh, and apart from these issues, I'm impressed with the quality of the audio
as well as the video. And for FTA the experience was pretty much: out of
box -> works :-)

Thanks in advance for any help with this!

Erik.


_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
