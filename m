Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.work.de ([212.12.32.20])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <abraham.manu@gmail.com>) id 1KiiEH-000314-6P
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 06:13:25 +0200
Message-ID: <48DB0FDA.1000702@gmail.com>
Date: Thu, 25 Sep 2008 08:13:14 +0400
From: Manu Abraham <abraham.manu@gmail.com>
MIME-Version: 1.0
To: Christophe Thommeret <hftom@free.fr>
References: <4724.24.120.242.223.1222313000.squirrel@webmail.xs4all.nl>
	<48DB0C1E.6020605@gmail.com> <200809250604.44125.hftom@free.fr>
In-Reply-To: <200809250604.44125.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
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

Christophe Thommeret wrote:
> Le Thursday 25 September 2008 05:57:18 Manu Abraham, vous avez =E9crit :
>> Hans Verkuil wrote:
>>> Just work with Steve to convert the current devices in the multiproto
>>> tree to use this API. If there is anything missing kick Steve and he'll
>>> have to add whatever is needed. That's *his* responsibility and he
>>> accepted that during the discussions.
>> With the multiproto tree, you _don't_need_ to convert any devices to use
>> the new infrastructure, whereas with S2API you need to do that. This is
>> a major drawback. In the multiproto tree, all devices work just without
>> any conversion of any kind, also it is completely backward compatible.
>>
>> The aspect of backward compatibility and drivers not getting converted
>> had been a major issue, when the original DVB-S2 discussions came up.
>> This had been a design goal for the multiproto tree.


Please do not trim CC's.

> I'm not sure to get you Manu.
> Do you mean that existing drivers have to be "converted" to work with s2a=
pi ?

Yes, one of the existing drivers had to be converted. eg: CinergyT2

Also, the stb0899 driver (from the multiproto tree) also needs to be
converted, as far as anyone who is able to see, or from the posts
themselves.

The CX24116 is already existing in the multiproto tree, from Steven
himself. I did not pull this driver into the tree that i used for
testing because of all those mails Steven wrote: just wanted to stay
clear of it. But somebody else is having the same tree. Eventhough many
people had asked me to pull that driver in, because of all those mails,
i just stood clear of it.

You can read it from the public archives here on the same.

Regards,
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
