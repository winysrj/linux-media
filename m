Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mx34.mail.ru ([194.67.23.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <goga777@bk.ru>) id 1LGTth-00029g-3t
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 08:47:45 +0100
Received: from [92.101.140.5] (port=9681 helo=localhost.localdomain)
	by mx34.mail.ru with asmtp id 1LGTt7-000PMO-00
	for linux-dvb@linuxtv.org; Sat, 27 Dec 2008 10:47:09 +0300
Date: Sat, 27 Dec 2008 10:52:40 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Message-ID: <20081227105240.20a11714@bk.ru>
In-Reply-To: <495521F6.9060808@makhutov.org>
References: <20081222142937.GK12059@titan.makhutov-it.de>
	<8103ad500812221220k2ebee308x673c2ead22c27204@mail.gmail.com>
	<495521F6.9060808@makhutov.org>
Mime-Version: 1.0
Subject: Re: [linux-dvb] TS continuity error (was - DVB-S2 stream
 partitially broken for Astra HD+ on 19.2E with SkyStar HD (stb0899))
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

> > under Windows you can use MPEG2Repair - it is a small tool that can
> > analyze the Transport Stream (TS) for errors. i suspect that the TS
> > created under Linux have (dis)continuity errors.
> 
> The stream has indeed some errors. I am not sure what kind of errors
> this are, but VDR complains about "TS continuity errors".
> 
> MPEG2Repair and TSDoctor are not able to repair the stream.
> 
> The errors are much more frequent on Astra HD+ than on Arte HD and the
> errors only occours with DVB-S2.
> 
> Here are some pieces of my VDR logfile:
> 
> 
> Astra HD+
> [...]
> Dec 26 19:04:09 gandalf vdr: [2669] TS continuity error (3)
> Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (7)
> Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (9)
> Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (13)


yes,  I can confirm that I have also this problem even with dvb-s2 h264 channels with standard definition ,  see my report
here http://www.linuxtv.org/pipermail/vdr/2008-November/018223.html (I have hvr4000)

It's really annoying problem. I think it doesn't have any link with ffmpeg as software decoder. Artem - have you the same
problem under Windows with recording recorded under Linux with szap-s2 ?

Goga

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
