Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KphA1-0003M3-Ou
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 12:29:55 +0200
From: Darron Broad <darron@kewl.org>
To: Christophe Thommeret <hftom@free.fr>
In-reply-to: <200810141133.36559.hftom@free.fr> 
References: <200810141133.36559.hftom@free.fr>
Date: Tue, 14 Oct 2008 11:29:49 +0100
Message-ID: <1985.1223980189@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200810141133.36559.hftom@free.fr>, Christophe Thommeret wrote:

hi

>Hi,
>
>This patch makes cx24116 to behave like other dvb-s frontends.

Unlike most DVB-S cards the those with a cx24116 use S2API
this makes them somewhat different.

>This is needed especially because QAM_AUTO is used in a lot of scan files.

What scan files are you referring to? The
cx24116 only does PSK, not AM. QAM_AUTO
doesn't sound right. the cx24116 can't
auto detect anything, but that's another
story...

if you are seeing problems with the S2API then
ensure that you issue a DTV_CLEAR prior to programming
the correct parameters for a particular delivery
system.

if you are seeing problems with the legacy
API then there could be a problem with the legacy
to S2API cache sync, you need to give more details
for this to be investigated.

cya!

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
