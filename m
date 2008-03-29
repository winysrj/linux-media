Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.156])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bokola@gmail.com>) id 1JfjkT-0000Zv-Mc
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 23:42:11 +0100
Received: by fg-out-1718.google.com with SMTP id 22so803016fge.25
	for <linux-dvb@linuxtv.org>; Sat, 29 Mar 2008 15:42:02 -0700 (PDT)
Message-ID: <854d46170803291542w51a3f500r102a6bcbde4910cc@mail.gmail.com>
Date: Sat, 29 Mar 2008 23:42:01 +0100
From: "Faruk A" <fa@elwak.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <854d46170803251343t5676ddebpa752941c20a0b9a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_33627_15394099.1206830521966"
References: <854d46170803181612wa79a469m9faf56b929577583@mail.gmail.com>
	<47E0B346.2090701@gmx.net>
	<854d46170803211001r7a11027cnbe8df40455cb6e9@mail.gmail.com>
	<854d46170803251343t5676ddebpa752941c20a0b9a2@mail.gmail.com>
Subject: Re: [linux-dvb] TT Connect S2-3650 CI unsupported device but
	partially working
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

------=_Part_33627_15394099.1206830521966
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi!

I've been messing with this card all day and i found out that there
was something missing in my
vdr build script. I forgot to apply vdr patches.

After i compiled vdr-1.6 and multiproto ( changeset <=3D7207). I can
finally watch channels in vdr.

remote control 100% working
DiseqC, DVB-S and DVBS-2 working in vdr.

Minus side:
No CI support
vdr needs help from szap once ( i have to run szap once after i insmod
drivers if not vdr won't lock "stb0899_read_status: Unsupported
delivery system")
DVB-S and DVBS-2 can't work together, you can either use DVB-S or
DVBS-2 to switch mode you have close vdr and run szap in DVB-S or
DVBS-2.
There are packet losses from the TS.

I have even test the new pctv452e.c posted by Dominik Kuhlen on Mar 16
http://www.linuxtv.org/pipermail/linux-dvb/2008-March/024571.html

Plus side:
TS packet losses FIXED :)
Works with multiproto changeset 7208 and above
No need for szap after insmod drivers

Minus side:
it hard to lock channels withs this new driver or is it new multiproto
changesets? you have to switch to many different channels and in the
end it locks.
scan and szap doesn't seem to work with latest multiproto "ioctl
DVBFE_GET_INFO failed: Operation not supported"
maybe i need new versions ? is there any other patched versions ?

Thanks you Dominik Kuhlen, Andr=E9 Weidemann and everybody here @
Linux-DVB you guys rock :)

I have attached patch for this card, its basically Andr=E9 Weidemann's
s2-3600 patch i changed all the
3600 references to 3650_ci and changed the product id.

Make sure to apply the patch for the PCTV 452e first!

Best regards,
Faruk

------=_Part_33627_15394099.1206830521966
Content-Type: application/x-bzip2;
 name=patch-tt-connect-s2-3650-ci.diff.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_feeriryf0
Content-Disposition: attachment;
 filename=patch-tt-connect-s2-3650-ci.diff.bz2

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
DozkYdFCAOYnzqKAIHrKj/i7kinChISNkeUI
------=_Part_33627_15394099.1206830521966
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
------=_Part_33627_15394099.1206830521966--
