Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ayden.softclick-it.de ([217.160.202.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tobi@to-st.de>) id 1KLyea-0000Dr-TW
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:06:38 +0200
Message-ID: <4888623F.5000108@to-st.de>
Date: Thu, 24 Jul 2008 13:06:39 +0200
From: Tobias Stoeber <tobi@to-st.de>
MIME-Version: 1.0
To: Tim Farrington <timf@iinet.net.au>
References: <488860FE.5020500@iinet.net.au>
In-Reply-To: <488860FE.5020500@iinet.net.au>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] dvb mpeg2?
Reply-To: tobi@to-st.de
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

Tim Farrington schrieb:
> Can you please give me some guidance as to how to discover
> what format is output from the v4l-dvb driver.
> 
> The DVB-T standard is, as I understand it, MPEG2,
> however with kaffeine, me-tv, mplayer if I record to a file,
> (dump from the raw data stream),
> it appears to be stored as a MPEG1 file.
> If I use GOPchop, it will not open any of these files,
> as it will only open MPEG2 files.

Well if I remember it right, a DVB stream (in MPEG2) is MPEG2-TS and 
GOPchop will handle MPEG2-PS!

Cheers, Tobias


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
