Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ti-out-0910.google.com ([209.85.142.184])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1KqYZU-0006j0-PL
	for linux-dvb@linuxtv.org; Thu, 16 Oct 2008 21:31:46 +0200
Received: by ti-out-0910.google.com with SMTP id w7so72920tib.13
	for <linux-dvb@linuxtv.org>; Thu, 16 Oct 2008 12:31:38 -0700 (PDT)
Date: Thu, 16 Oct 2008 21:31:31 +0200
To: linux-dvb@linuxtv.org
Message-ID: <20081016193131.GA4413@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] rmmod s2-mfe crash my 2.6.27
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hello,

I just wanted to try s2-mfe under 2.6.27, and something really strange
happened : issuing a scripts/rmmod.pl unload crash my computer hard (so
hard I can't use any of the MagicSyRq keys).

My system has three cards :
04:01.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
04:02.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder (rev 05)
04:02.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [Audio Port] (rev 05)
04:02.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] (rev 05)
04:02.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [IR Port] (rev 05)
04:05.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video
and Audio Decoder (rev 03)
04:05.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and
Audio Decoder [MPEG Port] (rev 03)

I haven't tested s2-mfe with my "stable" 2.6.26 kernel which still run
multiproto (lipliandvb).
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
