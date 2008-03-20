Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from f12.mail.ru ([194.67.57.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1JcFMM-00049d-Uh
	for linux-dvb@linuxtv.org; Thu, 20 Mar 2008 08:38:53 +0100
From: Igor <goga777@bk.ru>
To: Claes Lindblom <claesl@gmail.com>
Mime-Version: 1.0
Date: Thu, 20 Mar 2008 10:38:11 +0300
In-Reply-To: <47E212A4.5060400@gmail.com>
References: <47E212A4.5060400@gmail.com>
Message-Id: <E1JcFLn-000Ef8-00.goga777-bk-ru@f12.mail.ru>
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

> > How long (seconds, minutes...) this file ? 
> > please, update your MPlayer - take the svn version.
> > and finally please try to use dvbstream
> >
> > ./dvbstream -o 8192 > your.file
> >
> > Igor
> >
> >   
> Maybe around 10 seconds long.

ok

> I have updated MPlayer with the latest svn 

ok, it's right

>and also the latest x264 
> codec and the result is still the same with.

it's not need, because inside MPlayer already included the fresh ffmpeg - decoder for h264

 
> I don't understand how this dvbstream example works because of what I 
> understand, dvbstream uses rtp streaming?

not only for rtp streaming, dvbstrem can record the files, too

> I'm running on a 2.6.24 kernel and Slamd 64 distribution. All standard 
> channels works fine, but DVB-S2 is the main
> issue to solve.

so, it's better to write to Mplayer-dvb mailing list about your issue, and to upload your sample to Mplayer's ftp-server  ftp://upload.mplayerhq.hu/MPlayer/incoming

Igor


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
