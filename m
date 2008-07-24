Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ayden.softclick-it.de ([217.160.202.102])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tobi@to-st.de>) id 1KLyuk-0001gP-5S
	for linux-dvb@linuxtv.org; Thu, 24 Jul 2008 13:23:19 +0200
Message-ID: <4888662A.80001@to-st.de>
Date: Thu, 24 Jul 2008 13:23:22 +0200
From: Tobias Stoeber <tobi@to-st.de>
MIME-Version: 1.0
To: Tim Farrington <timf@iinet.net.au>
References: <488860FE.5020500@iinet.net.au> <4888623F.5000108@to-st.de>
	<488863EF.8000402@iinet.net.au>
In-Reply-To: <488863EF.8000402@iinet.net.au>
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

Hi Tim,

Tim Farrington schrieb:
> Do you mean GOPchop won't open MPEG2-TS?

Yes, that's what I suppose. That it won't open MPEG2-TS.

> What I'm after is some tool/means which will accurately display a format 
> descriptor for
> a MPEG(x) file/stream.
> 
> MPEG2-TS is what is supposed to be the format, but how can I discover if 
> it really is?

Well, you could possibly try

mplayer -identify -vo null -ao null file.mpg

Cheers, Tobias



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
