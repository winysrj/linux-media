Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f128.mail.ru ([194.67.57.128])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JWBe1-0004PS-Vu
	for linux-dvb@linuxtv.org; Mon, 03 Mar 2008 15:28:00 +0100
From: Igor <goga777@bk.ru>
To: Claes Lindblom <claesl@gmail.com>
Mime-Version: 1.0
Date: Mon, 03 Mar 2008 17:26:24 +0300
References: <47CBEC8D.4050306@gmail.com>
In-Reply-To: <47CBEC8D.4050306@gmail.com>
Message-Id: <E1JWBcW-000EkI-00.goga777-bk-ru@f128.mail.ru>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb]
	=?koi8-r?b?QXp1cmVXYXZlIFZQIDEwNDEgRFZCLVMyIHByb2Js?=
	=?koi8-r?b?ZW0=?=
Reply-To: Igor <goga777@bk.ru>
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

> mplayer /dev/dvb/adapter1/dvr0
> 
> mplayer says...
> 
> TS file format detected.
> VIDEO MPEG2(pid=515) AUDIO MPA(pid=652) NO SUBS (yet)!  PROGRAM N. 0
> VIDEO:  MPEG2  544x576  (aspect 3)  25.000 fps  15000.0 kbps (1875.0 kbyte/s)
> 
> 
> and the picture is shown.


you can try with dvbsnoop or dvbstream

http://allrussian.info/thread.php?postid=182975#post182975

dvbstream -o 8192 | mplayer -
or
dvbsnoop -s ts -b -tsraw | mplayer -

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
