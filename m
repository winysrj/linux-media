Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from joan.kewl.org ([212.161.35.248])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <darron@kewl.org>) id 1KpnHd-0002jz-7R
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 19:02:12 +0200
From: Darron Broad <darron@kewl.org>
To: Christophe Thommeret <hftom@free.fr>
In-reply-to: <200810141451.02941.hftom@free.fr> 
References: <200810141133.36559.hftom@free.fr> <1985.1223980189@kewl.org>
	<200810141451.02941.hftom@free.fr>
Date: Tue, 14 Oct 2008 18:02:03 +0100
Message-ID: <4473.1224003723@kewl.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] cx24116 DVB-S modulation fix
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

In message <200810141451.02941.hftom@free.fr>, Christophe Thommeret wrote:

LO

>Le Tuesday 14 October 2008 12:29:49 Darron Broad, vous avez =E9crit=A0:
>> In message <200810141133.36559.hftom@free.fr>, Christophe Thommeret wrote:
>>
>> hi
>>
>> >Hi,
>> >
>> >This patch makes cx24116 to behave like other dvb-s frontends.
>>
>> Unlike most DVB-S cards the those with a cx24116 use S2API
>> this makes them somewhat different.
>>
>> >This is needed especially because QAM_AUTO is used in a lot of scan file=
>s.
>>
>> What scan files are you referring to? The
>> cx24116 only does PSK, not AM. QAM_AUTO
>> doesn't sound right. the cx24116 can't
>> auto detect anything, but that's another
>> story...
>
>dvbscan initial tuning data files for DVB-S don't have an entry for=20
>modulation. So an app like kaffeine simply set modulation to QAM_AUTO.
>Why not QPSK, you ask? Simply because DVB-S standard allows QPSK and 16QAM.=
>

It doesn't include modulation because QPSK is implied.

>Maybe there is not a single 16QAM TP all over the world, but it's still a=20
>valid modulation for DVB-S.

As is said, the cx24116 only does PSK.

The driver should return unsupported for anything it can't do.

If someone out there actually uses 16-QAM (who are you?) and that person
switches to an adapter with a cx24116 they should be informed of error
when tuning 16-QAM, not acceptance of something it doesn't support.

>So, we set modulation to QAM_AUTO when it's unknown/unspecified, like in=20
>dvbscan files (those being also used by kaffeine). And it works pretty well=
>,=20
>just because most dvb-s can only do QPSK and so force modulation to QPSK=20
>instead of returning a notsup.
>See this as software QAM_AUTO :)

>P.S.
>This is with s2api.

When you use DVB-S delivery you should set the modulation to QPSK. If
an end-user out there really needs 16-QAM then you should allow them
the option to change it to QAM_16. I do not think this is going
inconvenience many people.

cya

--

 // /
{:)==={ Darron Broad <darron@kewl.org>
 \\ \ 


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
