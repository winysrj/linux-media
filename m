Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from py-out-1112.google.com ([64.233.166.176])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JZ30r-0003h7-5q
	for linux-dvb@linuxtv.org; Tue, 11 Mar 2008 12:51:34 +0100
Received: by py-out-1112.google.com with SMTP id a29so2609776pyi.0
	for <linux-dvb@linuxtv.org>; Tue, 11 Mar 2008 04:50:11 -0700 (PDT)
Message-ID: <19a3b7a80803110450t123fb1b8k9848de7c8739fb44@mail.gmail.com>
Date: Tue, 11 Mar 2008 12:50:11 +0100
From: "Christoph Pfister" <christophpfister@gmail.com>
To: "=?ISO-8859-1?Q?Guillaume_Membr=E9?=" <guillaume.ml@gmail.com>
In-Reply-To: <4758d4170803081118x1090f435j39f66822e28fa6a0@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <4758d4170803081118x1090f435j39f66822e28fa6a0@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated scan file for fr-noos-numericable
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

Hi,

2008/3/8, Guillaume Membr=E9 <guillaume.ml@gmail.com>:
> Hello
>
>  Attached is a scan file for the french cable operator "Numericable".
>  Hope this helps :)

<snip>
diff -r 3cde3460d120 util/scan/dvb-c/fr-noos-numericable
--- a/util/scan/dvb-c/fr-noos-numericable	Tue Mar 11 12:40:20 2008 +0100
+++ b/util/scan/dvb-c/fr-noos-numericable	Tue Mar 11 12:41:03 2008 +0100
@@ -1,41 +1,90 @@
 # Cable en France
 # freq sr fec mod
 C 123000000 6875000 NONE QAM64
+C 123125000 6875000 NONE QAM64
 C 131000000 6875000 NONE QAM64
+C 131125000 6875000 NONE QAM64
<snip>

Nearly every entry is duplicated (two frequencies are too close to
each other --> both "lead" to the same transponder ...).

>  Regards
>
> Guillaume

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
