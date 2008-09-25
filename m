Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp23.orange.fr ([193.252.22.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hftom@free.fr>) id 1Kii6R-0002E1-9C
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 06:05:21 +0200
From: Christophe Thommeret <hftom@free.fr>
To: linux-dvb@linuxtv.org
Date: Thu, 25 Sep 2008 06:04:43 +0200
References: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
	<48DB0C1E.6020605@gmail.com>
In-Reply-To: <48DB0C1E.6020605@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809250604.44125.hftom@free.fr>
Cc: Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [linux-dvb] [ANNOUNCE] DVB API improvements
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

Le Thursday 25 September 2008 05:57:18 Manu Abraham, vous avez =E9crit=A0:
> Hans Verkuil wrote:
> > Just work with Steve to convert the current devices in the multiproto
> > tree to use this API. If there is anything missing kick Steve and he'll
> > have to add whatever is needed. That's *his* responsibility and he
> > accepted that during the discussions.
>
> With the multiproto tree, you _don't_need_ to convert any devices to use
> the new infrastructure, whereas with S2API you need to do that. This is
> a major drawback. In the multiproto tree, all devices work just without
> any conversion of any kind, also it is completely backward compatible.
>
> The aspect of backward compatibility and drivers not getting converted
> had been a major issue, when the original DVB-S2 discussions came up.
> This had been a design goal for the multiproto tree.

I'm not sure to get you Manu.
Do you mean that existing drivers have to be "converted" to work with s2api=
 ?



-- =

Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
