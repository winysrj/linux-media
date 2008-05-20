Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wa-out-1112.google.com ([209.85.146.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <primijos@gmail.com>) id 1JyJeM-0005se-95
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 06:40:36 +0200
Received: by wa-out-1112.google.com with SMTP id n7so1988803wag.13
	for <linux-dvb@linuxtv.org>; Mon, 19 May 2008 21:40:29 -0700 (PDT)
Message-ID: <aea1a9c0805192140m3dddb857o8fcd1be710c74b66@mail.gmail.com>
Date: Tue, 20 May 2008 06:40:28 +0200
From: "=?ISO-8859-1?Q?Jos=E9_Oliver_Segura?=" <primijos@gmail.com>
To: linux-dvb <linux-dvb@linuxtv.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] using more than one tuner simultaneously -> problem
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

       I have a working configuration with one Hauppauge nova-t stick
and I'm able to tune/watch all the channels available in my area
without any problem. Yesterday I bought a dual-tuner pinnacle usb
stick and I've not been able to use more than one tuner (of the three
I have available now) simultaneously. All three tuners are detected,
initialized and registered without any problem; using tzap to tune any
of the frontends works perfectly (FE_HAS_LOCK, status=1f, unc=0000,
ber=000), the problem comes whenever I try to _simultaneously_ use
another of the tuners, it doesn't matter which one of them (either
another in the same stick, or two tuners one from each stick). At that
point, the second tzap/tuner is unable to tune, and the first one
-that was tuned ok- fails: femon shows FE_HAS_LOCK, but status goes to
1b (loses viterbi bit)) and ber goes to 0x1ffff...

       I have performed tests with multiple setups (only the dual
tuner, the single tuner + dual tuner with independent antennas,
atenuators/no atenuators, etc.) but the problem is always there: as
soon as I start a second tuning process, any previous tuning + the
current tuning fails. I've searched the lists for lots of keywords,
but I've not been able to find any discussion related, it looks like
nobody has this problem when using more than one tuner, am I wrong?
Any help about this will be welcome... the situation is getting
serious (here, in Spain, since last week, Prison Break and House M.D.
are broadcasted simultaneously on tuesdays :) )

       Just to give some more clues... the tuners are connected to a
PCMCIA USB2.0 controller, not directly to USB ports in my laptop
(originally, the laptop only had USB1.1 slots), I'm using a Fedora 6
installation with latest drivers (downloades/compiled/installed
yesterday without any problem) and kernel 2.6.22:

[root@mediacenter ~]# uname -a
Linux mediacenter 2.6.22.14-72.fc6 #1 SMP Wed Nov 21 15:12:59 EST 2007
i686 i686 i386 GNU/Linux

       Any help will be welcome, thanks in advance.

       Best,
       Jose

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
