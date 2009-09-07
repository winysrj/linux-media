Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ierton@gmail.com>) id 1MkZgX-0005ax-GD
	for linux-dvb@linuxtv.org; Mon, 07 Sep 2009 10:34:49 +0200
Received: by bwz9 with SMTP id 9so1797479bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 07 Sep 2009 01:34:16 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 7 Sep 2009 12:34:15 +0400
Message-ID: <aa09d86e0909070134s342bdb3ci773684a3ab1a0b4e@mail.gmail.com>
From: =?KOI8-R?B?88XSx8XKIO3J0s/Oz9c=?= <ierton@gmail.com>
To: linux-dvb@linuxtv.org, linux-media@vger.kernel.org
Subject: [linux-dvb] LinuxDVB dma-capable ringbuffer
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0504786324=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--===============0504786324==
Content-Type: multipart/alternative; boundary=000e0ce044b414bc5c0472f8b723

--000e0ce044b414bc5c0472f8b723
Content-Type: text/plain; charset=ISO-8859-1

Hello! I am developing driver for my company's device. This device is
designed with performance in mind and has capability of assigning separate
dma channels to hardware pid filters.  (relationship between dma channels
and hw pid filters is many-to-many. For example, i can request the device to
filter pids 3, 88 and 222 and redirect result either to single dma channel
number 5 or to separate channels 1, 2 and 3)

But i found that dmxdev's buffers of type dvb_ringbuffer are not designed
for dma input. For example, dmxdev.c uses vmalloc() to allocate memory.

Should i think about rewriting dmxdev.c or this job is already done in some
of current/unstable branches?

-- 
Thanks, Sergey

--000e0ce044b414bc5c0472f8b723
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello! I am developing driver for my company&#39;s device. This device is d=
esigned with performance in mind and has capability of assigning separate  =
dma channels to  hardware pid filters.=A0 (relationship between dma channel=
s and hw pid filters is many-to-many. For example, i can request the device=
 to filter pids 3, 88 and 222 and redirect result either to single dma chan=
nel number 5 or to separate channels 1, 2 and 3)<br>
<br>But i found that dmxdev&#39;s buffers of type dvb_ringbuffer are not de=
signed for dma input. For example, dmxdev.c uses vmalloc() to allocate memo=
ry.<br><br>Should i think about rewriting dmxdev.c or this job is already d=
one in some of current/unstable branches?<br>
<br clear=3D"all">-- <br>Thanks, Sergey<br>

--000e0ce044b414bc5c0472f8b723--


--===============0504786324==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============0504786324==--
