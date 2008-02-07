Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from fmmailgate02.web.de ([217.72.192.227])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hubblest@web.de>) id 1JN9ul-0004Xw-NQ
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 17:47:55 +0100
Received: from smtp07.web.de (fmsmtp07.dlan.cinetic.de [172.20.5.215])
	by fmmailgate02.web.de (Postfix) with ESMTP id 77F9ECFD35BF
	for <linux-dvb@linuxtv.org>; Thu,  7 Feb 2008 17:47:25 +0100 (CET)
Received: from [84.180.203.138] (helo=selma)
	by smtp07.web.de with asmtp (TLSv1:AES128-SHA:128)
	(WEB.DE 4.109 #226) id 1JN9uH-00070r-00
	for linux-dvb@linuxtv.org; Thu, 07 Feb 2008 17:47:25 +0100
From: Peter Meszmer <hubblest@web.de>
To: linux-dvb@linuxtv.org
Date: Thu, 7 Feb 2008 17:47:23 +0100
References: <47AB228E.3080303@gmail.com>
In-Reply-To: <47AB228E.3080303@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802071747.24437.hubblest@web.de>
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

Am Donnerstag, 7. Februar 2008 schrieb Eduard Huguet:
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

Hello,

yes, DVB-S is working. I'm sitting here in Germany, using Astra 19.2E and =

Hotbird 13.0E. Scanning is possible with Kaffeine and scan (dvbscan on my =

Gentoo-box from media-tv/linuxtv-dvb-apps). So you should check your =

equipment. :)

Als far as I know, you can either use Tino's or ZZam's patch.

Best regards,
Peter Meszmer

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
