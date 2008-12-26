Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from bane.moelleritberatung.de ([77.37.2.25])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <artem@makhutov.org>) id 1LGHPD-0005QG-1U
	for linux-dvb@linuxtv.org; Fri, 26 Dec 2008 19:27:28 +0100
Message-ID: <495521F6.9060808@makhutov.org>
Date: Fri, 26 Dec 2008 19:27:02 +0100
From: Artem Makhutov <artem@makhutov.org>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <20081222142937.GK12059@titan.makhutov-it.de>
	<8103ad500812221220k2ebee308x673c2ead22c27204@mail.gmail.com>
In-Reply-To: <8103ad500812221220k2ebee308x673c2ead22c27204@mail.gmail.com>
Subject: Re: [linux-dvb] DVB-S2 stream partitially broken for Astra HD+ on
 19.2E with SkyStar HD (stb0899)
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

Hello,

Konstantin Dimitrov schrieb:
> hi Artem,
> 
> under Windows you can use MPEG2Repair - it is a small tool that can
> analyze the Transport Stream (TS) for errors. i suspect that the TS
> created under Linux have (dis)continuity errors.

The stream has indeed some errors. I am not sure what kind of errors
this are, but VDR complains about "TS continuity errors".

MPEG2Repair and TSDoctor are not able to repair the stream.

The errors are much more frequent on Astra HD+ than on Arte HD and the
errors only occours with DVB-S2.

Here are some pieces of my VDR logfile:


Astra HD+
[...]
Dec 26 19:04:09 gandalf vdr: [2669] TS continuity error (3)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (7)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (9)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (13)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (12)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (15)
Dec 26 19:04:14 gandalf vdr: [2669] TS continuity error (14)
Dec 26 19:04:17 gandalf vdr: [2669] TS continuity error (0)
Dec 26 19:04:17 gandalf vdr: [2669] TS continuity error (6)
Dec 26 19:04:41 gandalf vdr: [2669] TS continuity error (8)
Dec 26 19:04:41 gandalf vdr: [2669] TS continuity error (11)
Dec 26 19:04:41 gandalf vdr: [2669] TS continuity error (6)
Dec 26 19:04:44 gandalf vdr: [2669] TS continuity error (3)
Dec 26 19:04:44 gandalf vdr: [2669] TS continuity error (8)
Dec 26 19:04:44 gandalf vdr: [2669] TS continuity error (4)
Dec 26 19:04:52 gandalf vdr: [2669] TS continuity error (6)
Dec 26 19:04:52 gandalf vdr: [2669] TS continuity error (11)
Dec 26 19:04:52 gandalf vdr: [2669] TS continuity error (2)
Dec 26 19:04:56 gandalf vdr: [2669] TS continuity error (7)
Dec 26 19:04:56 gandalf vdr: [2669] TS continuity error (0)
Dec 26 19:05:01 gandalf vdr: [2669] TS continuity error (5)
Dec 26 19:05:04 gandalf vdr: [2669] TS continuity error (14)
Dec 26 19:05:12 gandalf vdr: [2669] TS continuity error (0)
Dec 26 19:05:12 gandalf vdr: [2669] TS continuity error (9)
Dec 26 19:05:12 gandalf vdr: [2669] TS continuity error (4)
Dec 26 19:05:12 gandalf vdr: [2669] TS continuity error (13)
Dec 26 19:05:15 gandalf vdr: [2669] TS continuity error (4)
Dec 26 19:05:15 gandalf vdr: [2669] TS continuity error (6)
Dec 26 19:05:15 gandalf vdr: [2669] TS continuity error (5)
Dec 26 19:05:15 gandalf vdr: [2669] TS continuity error (8)
Dec 26 19:05:19 gandalf vdr: [2669] TS continuity error (6)
Dec 26 19:05:19 gandalf vdr: [2669] TS continuity error (8)
Dec 26 19:05:19 gandalf vdr: [2669] TS continuity error (7)
[...]

---

Arte HD:
[...]
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (10)
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (1)
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (1)
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (8)
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (5)
Dec 26 19:09:59 gandalf vdr: [2743] TS continuity error (12)
Dec 26 19:10:26 gandalf vdr: [2743] TS continuity error (6)
Dec 26 19:10:39 gandalf vdr: [2743] TS continuity error (0)
Dec 26 19:16:00 gandalf vdr: [2743] TS continuity error (13)
Dec 26 19:16:00 gandalf vdr: [2743] TS continuity error (4)
Dec 26 19:16:00 gandalf vdr: [2743] TS continuity error (1)
Dec 26 19:16:03 gandalf vdr: [2743] TS continuity error (4)
Dec 26 19:16:03 gandalf vdr: [2743] TS continuity error (7)
Dec 26 19:17:44 gandalf vdr: [2743] TS continuity error (2)
Dec 26 19:17:44 gandalf vdr: [2743] TS continuity error (9)
Dec 26 19:17:44 gandalf vdr: [2743] TS continuity error (4)
Dec 26 19:17:44 gandalf vdr: [2743] TS continuity error (11)
Dec 26 19:17:47 gandalf vdr: [2743] TS continuity error (11)
Dec 26 19:17:47 gandalf vdr: [2743] TS continuity error (14)
Dec 26 19:17:47 gandalf vdr: [2743] TS continuity error (5)
[...]

Any Ideas?

Thanks, Artem

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
