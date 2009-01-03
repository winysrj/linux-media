Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJ24a-0005vT-Jd
	for linux-dvb@linuxtv.org; Sat, 03 Jan 2009 09:41:33 +0100
Received: by bwz11 with SMTP id 11so14395057bwz.17
	for <linux-dvb@linuxtv.org>; Sat, 03 Jan 2009 00:40:59 -0800 (PST)
Date: Sat, 3 Jan 2009 09:40:55 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090103084055.GA3553@gmail.com>
References: <20090102230759.GA3017@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090102230759.GA3017@gmail.com>
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: Re: [linux-dvb] BUG cx88 don't work on S2API/2.6.28 amd64 (disseqc
	?)
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

On Sat, Jan 03, 2009 at 12:07:59AM +0100, Gregoire Favre wrote:

Could it be a similar problem as seen in :
http://www.linuxtv.org/pipermail/linux-dvb/2008-December/030707.html ?

> just to be sure I don't have an hardware problem I came back to a 2.6.27
> kernel on which I can compil multiproto : all my DVB cards works
> perfectly there.
> =

> Under 2.6.28 and today's v4l-dvb hg source the cx88 cards don't tune at
> all (geniatech budget and Hauppauge HVR-4000).
> =

> I have three diseqcs for all cards I have, which are each connected to
> three quad lnb (or quattro : those which are like four different lnb and
> need diseqc signals to choose l/h h/v), for example I set up VDR like
> this :
> =

> S13.0E 11700 V  9750 t v W15 [E0 10 38 F0] W15 t
> S13.0E 99999 V 10600 t v W15 [E0 10 38 F1] W15 T
> S13.0E 11700 H  9750 t V W15 [E0 10 38 F2] W15 t
> S13.0E 99999 H 10600 t V W15 [E0 10 38 F3] W15 T
> S19.2E 11700 V  9750 t v W15 [E0 10 38 F4] W15 t
> S19.2E 99999 V 10600 t v W15 [E0 10 38 F5] W15 T
> S19.2E 11700 H  9750 t V W15 [E0 10 38 F6] W15 t
> S19.2E 99999 H 10600 t V W15 [E0 10 38 F7] W15 T
> S28.2E 11700 V  9750 t v W15 [E0 10 38 F8] W15 t
> S28.2E 99999 V 10600 t v W15 [E0 10 38 F9] W15 T
> S28.2E 11700 H  9750 t V W15 [E0 10 38 FA] W15 t
> S28.2E 99999 H 10600 t V W15 [E0 10 38 FB] W15 T
> =

> I can't tune with the cx88 cards using S2API neither with VDR nor
> szap(.*).
> =

> from lspci :
> 04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
> 04:02.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and=
 Audio Decoder (rev 05)
> 04:02.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=
 Decoder [Audio Port] (rev 05)
> 04:02.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=
 Decoder [MPEG Port] (rev 05)
> 04:02.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=
 Decoder [IR Port] (rev 05)
> 04:05.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and=
 Audio Decoder (rev 03)
> 04:05.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio=
 Decoder [MPEG Port] (rev 03)
> =

> If they are any more info I could give to help solve this really annoying
> bug, I would be happy to give them.
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
