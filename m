Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KplXv-0005cb-6v
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 17:10:54 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta5.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8Q0076HI52I000@mta5.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 14 Oct 2008 11:10:16 -0400 (EDT)
Date: Tue, 14 Oct 2008 11:10:14 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200810141451.02941.hftom@free.fr>
To: Christophe Thommeret <hftom@free.fr>
Message-id: <48F4B656.6010404@linuxtv.org>
MIME-version: 1.0
References: <200810141133.36559.hftom@free.fr> <1985.1223980189@kewl.org>
	<200810141451.02941.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
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
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Christophe Thommeret wrote:
> Le Tuesday 14 October 2008 12:29:49 Darron Broad, vous avez =E9crit :
>> In message <200810141133.36559.hftom@free.fr>, Christophe Thommeret wrot=
e:
>>
>> hi
>>
>>> Hi,
>>>
>>> This patch makes cx24116 to behave like other dvb-s frontends.
>> Unlike most DVB-S cards the those with a cx24116 use S2API
>> this makes them somewhat different.
>>
>>> This is needed especially because QAM_AUTO is used in a lot of scan fil=
es.
>> What scan files are you referring to? The
>> cx24116 only does PSK, not AM. QAM_AUTO
>> doesn't sound right. the cx24116 can't
>> auto detect anything, but that's another
>> story...
> =

> dvbscan initial tuning data files for DVB-S don't have an entry for =

> modulation. So an app like kaffeine simply set modulation to QAM_AUTO.
> Why not QPSK, you ask? Simply because DVB-S standard allows QPSK and 16QA=
M. =

> Maybe there is not a single 16QAM TP all over the world, but it's still a =

> valid modulation for DVB-S.
> So, we set modulation to QAM_AUTO when it's unknown/unspecified, like in =

> dvbscan files (those being also used by kaffeine). And it works pretty we=
ll, =

> just because most dvb-s can only do QPSK and so force modulation to QPSK =

> instead of returning a notsup.
> See this as software QAM_AUTO :)

I've only glanced briefly at the patch but setting the modulation type =

to QAM_AUTO, and expecting the card to support it I think is a bad idea.

I can accept the argument that the current driver will not accept 16QAM, =

but that's not the problem being discussed. (I'll address this in a =

separate patch)

Call DTV_CLEAR should also default your rolloff to 3.5.

Let's investigate a better approach.

kaffeine should be working well already, with the current code. Unless =

it was recently broken - in which case please discuss.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
