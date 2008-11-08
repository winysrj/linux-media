Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.gmx.net ([213.165.64.20])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <Bitte_antworten@will-hier-weg.de>)
	id 1KyofS-0005Ce-Ui
	for linux-dvb@linuxtv.org; Sat, 08 Nov 2008 15:20:06 +0100
Date: Sat, 08 Nov 2008 15:19:29 +0100
From: Bitte_antworten@will-hier-weg.de
Message-ID: <20081108141929.113700@gmx.net>
MIME-Version: 1.0
To: "Igor M. Liplianin" <liplianin@tut.by>
Cc: linux-dvb@linuxtv.org
Subject: [linux-dvb] Fwd: Re:  stb0899 drivers Pinnacle PCTV452
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

Hi Igor,

I just want to let you know that Dominik Kuhlen's patches  for Pinnacle's PCTV452 are just working fine for me.

Dirk
-------- Original-Nachricht --------
Datum: Mon, 3 Nov 2008 17:46:50 +0100
Von: "Faruk A" <fa@elwak.com>
An: Bitte_antworten@will-hier-weg.de
Betreff: Re: [linux-dvb] cinergyT2 renamed drivers (was Re: stb0899 drivers)

On Mon, Nov 3, 2008 at 3:07 PM,  <Bitte_antworten@will-hier-weg.de> wrote:
> Thanks Faruk.
> I've tried this version and it works (except NDR and MDR on Astra 19.2E) like multiproto does.
> Are there any plans to add this patch to the main repository or Igor's repository?
>
> Dirk

Hi!

I'm glad it worked for you, Igor knows about this patch but he is not
adding this because it changes other files
like stb0899, stb6100 ... which other cards uses like the popular s2-3200 card.
Here is quoted mail from Igor when testing the patch against his s2-3200.

"To me, nothing changed. There is no lock for 3255 and 44948 kSym/s
and there is packet losses for
27500 from time to time."

What they need is feedback from people like us, Please email Igor and
others or to the mailing list that the patch is working
fine with your device and it should be merged.

I only tested once i wrote some good stuff and some negative stuff, my
bad because i did'nt know that my card
was broken i think because of that Igor did'nt merged. I was the only
one who made feedback about the patch.

I have returned my card to where i bought it, when i get it back I'll
do more testing.



Dominik Kuhlen's Original mail:
http://www.linuxtv.org/pipermail/linux-dvb/2008-October/029830.html

Direct link to the patch: my_s2api_pctv452e.patch.bz2
http://www.linuxtv.org/pipermail/linux-dvb/attachments/20081018/032ac808/attachment-0001.bin

Faruk

-- 
"Feel free" - 5 GB Mailbox, 50 FreeSMS/Monat ...
Jetzt GMX ProMail testen: http://www.gmx.net/de/go/promail

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
