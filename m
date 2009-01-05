Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJqBu-0004cj-Ps
	for linux-dvb@linuxtv.org; Mon, 05 Jan 2009 15:12:27 +0100
Received: by bwz11 with SMTP id 11so16148344bwz.17
	for <linux-dvb@linuxtv.org>; Mon, 05 Jan 2009 06:11:53 -0800 (PST)
Date: Mon, 5 Jan 2009 15:10:53 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090105141053.GB32196@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] cx25840-core.c don't compil today
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

compilation of today v4l-hg fails at :

  CC [M]  /usr/src/CVS/v4l-dvb/v4l/cx23885-417.o
  CC [M]  /usr/src/CVS/v4l-dvb/v4l/cx25840-core.o
/usr/src/CVS/v4l-dvb/v4l/cx25840-core.c:186: error: duplicate 'static'
make[2]: *** [/usr/src/CVS/v4l-dvb/v4l/cx25840-core.o] Error 1
make[1]: *** [_module_/usr/src/CVS/v4l-dvb/v4l] Error 2
make[1]: Leaving directory `/usr/src/linux-2.6.28-gentoo'
make: *** [default] Error 2
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
