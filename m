Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1Jxh0i-0004qT-DT
	for linux-dvb@linuxtv.org; Sun, 18 May 2008 13:25:05 +0200
Received: by fg-out-1718.google.com with SMTP id e21so1418543fga.25
	for <linux-dvb@linuxtv.org>; Sun, 18 May 2008 04:25:00 -0700 (PDT)
Message-ID: <854d46170805180424r1ca63161h51f6f5e43c78d45f@mail.gmail.com>
Date: Sun, 18 May 2008 13:24:58 +0200
From: "Faruk A" <fa@elwak.com>
To: "Jelle De Loecker" <skerit@kipdola.com>
In-Reply-To: <482FF520.4070303@kipdola.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <482CC0F0.30005@kipdola.com>
	<E1JwrWW-0006Ye-00.goga777-bk-ru@f139.mail.ru>
	<482D1AB7.3070101@kipdola.com> <20080518121250.7dc0eaac@bk.ru>
	<482FF520.4070303@kipdola.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Technotrend S2-3200 Scanning
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

> Yes, thank you, I finally got szap2 to actually catch a signal and get a
> lock on it.
>
> But since only szap2 works - what do I do now?
> How can I watch the stream? (I tried to run "mplayer -fs
> /dev/dvb/adapter0/vdr0 but that never worked)
> Or how can I get it to work in MythTV? Do I have to wait for the new
> utilities, which would seem rather strange since they're not used by mythtv,
> right?
>
> Thank you,
>
> Jelle De Loecker

This means you did the channel scan and saved channel.conf file in
/home/username/.szap

szap -rp "BBC World"   (you can replace BBC World with any channel in
your channel.conf) and make sure you get FE_HAS_LOCK before you start
mplayer.

mplayer /dev/dvb/adapter0/dvr0

mythtv: there is multiproto patch for mythtv-svn. I tried it but it
always failed med after 1 hour of compiling it's nothing to do with
the patch anyway here is the link to the patch.

http://pansy.at/gernot/mythtv-multiproto-hack.diff.gz

easiest way is to use vdr, I'm using vdr-1.6.0-1 stable version.
if you want to use the stable version you have to search for this
patch [ANNOUNCE] DVB-S2 + H.264 support for VDR-1.5.18 in vdr mailing
list and patch the vdr source.

There is vdr developer version 1.7.0 which support multiproto but you
still going to need H.264 support patch which can be found at vdr
mailing list.

Faruk

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
