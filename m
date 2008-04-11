Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <47FF6E6C.70008@anevia.com>
Date: Fri, 11 Apr 2008 15:58:04 +0200
From: Frederic CAND <frederic.cand@anevia.com>
MIME-Version: 1.0
To: Michael Krufky <mkrufky@linuxtv.org>
References: <47FF216F.6040207@anevia.com> <47FF67FA.80902@linuxtv.org>
	<47FF6971.70601@linuxtv.org>
In-Reply-To: <47FF6971.70601@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] MPEG2TS and HVR-1300
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

Michael Krufky a =E9crit :
> Steven Toth wrote:
>> Frederic CAND wrote:
>>> Hi all,
>>>
>>> we have here at our office an Hauppauge HVR 1300. It's working under =

>>> Linux 2.6.24 but we've not been able to make MPEG2/TS work. MPEG2/PS is =

>>> working fine though.
>>>
>>>  From what I read, it looks like the Conexant CX23416 chipset should =

>>> supports Transport Stream but we've not been able to use it. Are we =

>>> missing something ?
>> Last I heard transport mode was disabled in the firmware sometime ago by =

>> Conexant, in favor of some other feature being enabled.
>>
>> If you can find really early firmware for the PVR150 then you might try =

>> that. (Circa 3-4 years ago).
>>
> =

> Please note:  if you do find the older firmware, you will have to patch c=
x88-blackbird.c to allow firmware size 262144.
> =

> If this works for you, please post your results.
> =

> Regards,
> =

> Mike
> =


Sure, I will.

Regards.

-- =

CAND Frederic
Product Manager
ANEVIA

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
