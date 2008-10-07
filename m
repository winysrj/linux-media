Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp2e.orange.fr ([80.12.242.112])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1KnHfx-00008j-I5
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 20:52:54 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Tue, 7 Oct 2008 20:52:11 +0200
References: <44838.194.48.84.1.1223383227.squirrel@webmail.dark-green.com>
	<48EB5A9D.1090609@jcz.nl> <48EB956D.9010900@gmail.com>
In-Reply-To: <48EB956D.9010900@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200810072052.12369.hftom@free.fr>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] S2API vs Multiproto vs TT 3200
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

Le Tuesday 07 October 2008 18:59:25 Manu Abraham, vous avez =E9crit=A0:

> I do plan to have a port of the STB0899 + STV090x.

Hi Manu,

That's good news.

> The reason why i do =

> say a port and still maintain multiproto:

Well, I really hope you won't join Markus desperate way of breaking Linux D=
VB =

community.

> S2API is incapable of handling =

> DVB-S2 ACM (with 16/32APSK) as it is, ie, doesn't support DVBFE_GET_INFO
> for notification of MODCOD changes.
>
> Similar to a patch that i had posted for handling diversity some days?
> back.
>
> With regards to the cx24116, this is of no concern as it doesn't support
> 16/32APSK in any event.
>
> Or is there any bugfix to S2API which updates the DVBFE_GET_EVENT ioctl ?

S2API is now merged and thus is given to the whole community. And YOU are p=
art =

of this community, so the new API is yours also. If you want to submit =

fixes/patches, you have of course the rights to do so, and if it's a good o=
ne =

(and i'm pretty sure it will) i will second it for adoption.

Best Regards, Manu.

-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
