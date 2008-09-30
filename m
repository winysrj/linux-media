Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.181])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <slothpuck@gmail.com>) id 1KkkQJ-00028q-OF
	for linux-dvb@linuxtv.org; Tue, 30 Sep 2008 20:58:16 +0200
Received: by ik-out-1112.google.com with SMTP id c21so144688ika.1
	for <linux-dvb@linuxtv.org>; Tue, 30 Sep 2008 11:58:12 -0700 (PDT)
Message-ID: <c362cb880809301158t27afbe1fqd9c5d391e46ffdbe@mail.gmail.com>
Date: Tue, 30 Sep 2008 18:58:11 +0000
From: "Lee Jones" <slothpuck@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Trouble with tuning on Lifeview FlyDVB-T
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

Hello all :) !

I'm really writing this because it's a case of last resort, in an
effort to try to fix a long-standing problem. Namely, the tuning
problem I seem to have with a DVB T PCI card I have in my PC. It's a
lifeview flydvb-t. In fact, it's this one as listed on linuxtv's
website;

http://www.linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#LifeView
http://www.linuxtv.org/wiki/index.php/Image:LR301.jpg

The computer the card is in is a 64-bit system, running slamd64 which
is a slackware port to 64 bit systems. The version is 12.1, running
kernel version 2.6.24.5 .

http://www.slamd64.com/

The firmware for this card is in /lib/firmware, I don't see any errors
in dmesg about missing firmware files for the card.

The problem I am having is regarding tuning. Namely, the card seems to
miss channels while tuning. The ariel input is working ok as another
DVB-T unit (an Artec T1, USB) finds all channels with no problems, as
does a plain old fashioned digital freeview box.

I live in the UK ,and I'm using the rowridge transmitter. I've
successfully downloaded and compiled the dvbapps from linuxtv  (
dvb-apps-60131cfbbb2e )

----
The problems seem to occur with scanning, however. While tuning, I get
several lines which look like this:
>>> tune to: 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE
WARNING: >>> tuning failed!!!
>>> tune to: 562166670:INVERSION_AUTO:BANDWIDTH_8_MHZ:FEC_3_4:FEC_3_4:QAM_16:TRANSMISSION_MODE_2K:GUARD_INTERVAL_1_32:HIERARCHY_NONE (tuning failed)
----

After completion, some channels are missing (e.g. BBC1 is there, but
ITV or BBC4 aren't; they are there on a normal freeview box for
example) . After a lot of googling, I eventually found a program
called w_scan ( http://www.edafe.org/vdr/wscan.html ) . Its
documentation mentioned using the -x option in w_scan to create an
initial tuning data file, which I tried. I then tried using the
dvbutils' scan command on that initial tuning data file which w_scan
produced.

This still produced some "WARNING:>>>tuning failed!!!" messages but
appears to have found the 'missing 'channels. But then using the
dvbutils' program tzap seemed to tell a different story. Some channels
existed but yet didn't produce *any* data (I could confirm that they
are working and are on-air, again a normal digital freeview box
works).

For example:
$ tzap -r "BBC ONE"
Produces:
tuning to 489833330 Hz
video pid 0x0258, audio pid 0x0259
status 01 | signal 9f9f | snr 0000 | ber 0000bef8 | unc ffffffff |
status 1f | signal 9f9f | snr f3f3 | ber 0000057a | unc ffffffff | FE_HAS_LOCK
status 1f | signal 9f9f | snr fefe | ber 0000002c | unc 00000011 | FE_HAS_LOCK
status 1f | signal 9f9f | snr fefe | ber 00000022 | unc 00000000 | FE_HAS_LOCK

(in another window, at the same time)
$ cat /dev/dvb/adapter/dvr0
Produces lots of different characters, so I can see data coming in.
Saying cat /dev/dvb/adapter/dvr0 > test.mpg produces a watchable mpeg
file.

but

If I try this:
$ tzap -r "BBC FOUR"
Produces:
tuning to 562000000 Hz
video pid 0x0000, audio pid 0x0000
status 00 | signal 0000 | snr ffff | ber 0001fffe | unc 00000000 |
status 1f | signal 9d9d | snr 0000 | ber 00012966 | unc ffffffff | FE_HAS_LOCK
status 1f | signal 9c9c | snr 9f9f | ber 00000794 | unc ffffffff | FE_HAS_LOCK
status 1f | signal 9c9c | snr fefe | ber 00000038 | unc ffffffff | FE_HAS_LOCK
status 1f | signal 9c9c | snr fefe | ber 00000022 | unc 00000000 | FE_HAS_LOCK

(in another window at the same time)

$ cat /dev/dvb/adapter0/dvr0

Produces this ---------------------->

Nothing!

Not a single byte of data, yet apparently the signal has lock;
"FE_HAS_LOCK". Saying cat /dev/dvb/adapter/dvr0 > test.mpg produces a
file of 0 bytes.

I can go straight back to tzap -r "BBC ONE" and data once again is generated.

I can't find any answer for this at all anywhere!

Can anyone help?

Thanks

ljones

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
