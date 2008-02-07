Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail-out.m-online.net ([212.18.0.9])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <zzam@gentoo.org>) id 1JNCCM-00077Q-UP
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 20:14:14 +0100
From: Matthias Schwarzott <zzam@gentoo.org>
To: linux-dvb@linuxtv.org,
 Eduard Huguet <eduardhc@gmail.com>
Date: Thu, 7 Feb 2008 20:13:41 +0100
References: <47AB228E.3080303@gmail.com>
In-Reply-To: <47AB228E.3080303@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802072013.41966.zzam@gentoo.org>
Subject: Re: [linux-dvb] AVerMedia DVB-S Hybrid+FM and DVB-S Pro [A700]
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Donnerstag, 7. Februar 2008, Eduard Huguet wrote:
> Hi,
>     =BFHave you been able to make the DVB-S part work, so? I've been
> trying these days using ZZam's patch only (Tino's one also mentioned in
> the wiki doesn't apply for now), and I was completely unable to get a
> lock on any frequency.
>
> I thought it was because the driver was incomplete (without Tino's
> patch...), but if it works for you then I'll probably need to check my
> antenna, satellite, etc...
>
> My card is the DVB-S Pro simple (not hybrid), but I don't think this
> makes any difference.
>
> Best regards,
>   Eduard Huguet
>
>
> (PS: sorry for double posting. I forgot to change the subject  title
> before.)

Hi Eduard, Peter!

@Eduard:
Can you please compare the dmesg output (especially the eeprom dump) of you=
r =

card to the one listed on the wiki-page.

http://www.linuxtv.org/wiki/index.php/AVerMedia_AVerTV_DVB-S_Pro_(A700)

@Peter:
1. Maybe you want to start a page in the wiki dedicated to your card.
Or should we check for similarity and merge both of these cards into one pa=
ge?

At least I am interested in the eeprom content of your card.

I should request some schematics from Avermedia to maybe get gpio controlli=
ng =

correct. (Like resetting chips, ir ...)

Regards
Matthias

-- =

Matthias Schwarzott (zzam)

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
