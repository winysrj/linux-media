Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <christophpfister@gmail.com>) id 1JfFgf-00072t-2i
	for linux-dvb@linuxtv.org; Fri, 28 Mar 2008 15:36:11 +0100
Received: by mu-out-0910.google.com with SMTP id w9so479731mue.6
	for <linux-dvb@linuxtv.org>; Fri, 28 Mar 2008 07:36:04 -0700 (PDT)
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-dvb@linuxtv.org
Date: Fri, 28 Mar 2008 15:35:57 +0100
References: <200803212024.17198.christophpfister@gmail.com>
	<47ECCC5D.6080100@hot.ee>
In-Reply-To: <47ECCC5D.6080100@hot.ee>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803281535.57209.christophpfister@gmail.com>
Cc: Arthur Konovalov <kasjas@hot.ee>
Subject: Re: [linux-dvb] CI/CAM fixes for knc1 dvb-s cards
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

Am Freitag 28 M=E4rz 2008 schrieb Arthur Konovalov:
> Christoph Pfister wrote:
> > Hi,
> >
> > Can somebody please pick up those patches (descriptions inlined)?
> >
> > Thanks,
> >
> > Christoph
>
> Hi!
> I tried those patches, but got no picture and audio with my Terratec
> Cinergy 1200 DVB-C and TechniCAM CX Conax CAM (either FTA or scrambled).

But scrambled channels don't work without those patches either, right? (Hmm=
 - =

fta could be broken if the cam is in an invalid state - but it would still =

work without the cam; just that people don't think this is a regression =

because of the patches ... :)

<snip>
> dvb_ca adapter 1: DVB CAM detected and initialised successfully
> budget-av: cam inserted A
> dvb_ca adapter 1: DVB CAM detected and initialised successfully
<snip>
> Any idea to fix this?
> Please...

Paste the strace output of vdr or try kaffeine ...

Christoph

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
