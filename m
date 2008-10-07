Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <stoth@linuxtv.org>) id 1KnDoC-0001Hd-7R
	for linux-dvb@linuxtv.org; Tue, 07 Oct 2008 16:45:09 +0200
Received: from steven-toths-macbook-pro.local
	(ool-18bfe594.dyn.optonline.net [24.191.229.148]) by
	mta4.srv.hcvlny.cv.net
	(Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
	with ESMTP id <0K8D00DRYIA6S5G0@mta4.srv.hcvlny.cv.net> for
	linux-dvb@linuxtv.org; Tue, 07 Oct 2008 10:44:33 -0400 (EDT)
Date: Tue, 07 Oct 2008 10:44:30 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <200810071134.06020.jareguero@telefonica.net>
To: Jose Alberto Reguero <jareguero@telefonica.net>
Message-id: <48EB75CE.30107@linuxtv.org>
MIME-version: 1.0
References: <200810061422.38176.jareguero@telefonica.net>
	<48EAB62C.8060208@linuxtv.org>
	<200810071134.06020.jareguero@telefonica.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Problems with new S2API and DVB-T
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

Jose Alberto Reguero wrote:
> El Martes, 7 de Octubre de 2008, Steven Toth escribi=F3:
>> Jose Alberto Reguero wrote:
>>> I am trying to use the new API for DVB-T and I have some problems. They
>>> are not way to set code_rate_HP, code_rate_LP, transmission_mode, and
>>> guard_interval , and the default values are 0, that are not the AUTO
>>> ones. Also the bandwidth is not treated well. The attached patch is a
>>> workaround that works for me.
>> Hi Jose,
>>
>> Thanks for your patch.
>>
>> I've taken a different approach and added support for
>> DTV_TRANSMISSION_MODE, DTV_HIERARCHY, DTV_GUARD_INTERVAL,
>> DTV_CODE_RATE_HP and DTV_CODE_RATE_LP, so this will probably help.
>>
>> In terms of the bandwidth changes, you realise that you have to
>> bandwidth in units of HZ via the S2API? If you're doing this then I do
>> not see why the bandwidth code is failing. We have some backward compat
>> code which should be cleanly taking care of this, proving you pass HZ
>> into the S2API.
>>
>> One interest point is that we may want to pick sensible defaults for the
>> cache values during initialisation (which doesn't currently happen).
>> Applications that rely on default behaviour could be failing... although
>> Kaffeine, Myth, VDR and tzap applications are not experiencing this issu=
e.
>>
>> http://linuxtv.org/hg/~stoth/s2
>>
>> Could you pull this tree and try again? (Remember to change your
>> bandwidth values to HZ, I.e. 8000000.
>>
>> Thanks again,
>>
>> Steve
> =

> It works ok.
> Thanks.

Thanks for testing Jose, regards.

- Steve


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
