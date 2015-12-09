Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39195 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbbLITDk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 9 Dec 2015 14:03:40 -0500
Reply-To: timo.helkio@kapsi.fi
Subject: Re: DVBSky T980C ci not working with kernel 4.x
References: <201512081149525312370@gmail.com>
To: Nibble Max <nibble.max@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: =?UTF-8?Q?Timo_Helki=c3=b6?= <timo.helkio@kapsi.fi>
Message-ID: <56687B09.4050004@kapsi.fi>
Date: Wed, 9 Dec 2015 21:03:37 +0200
MIME-Version: 1.0
In-Reply-To: <201512081149525312370@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08.12.2015 05:49, Nibble Max wrote:
>
> Does this card work with the media code from dvbsky.net from kernel 4.x?
>
> On 2015-12-06 19:10:41, Timo_Helkiö <timo.helkio@kapsi.fi> wrote:
>>
>> Hi
>>
>>
>> Common interface in Dvbsky T980C is not working with Ubuntu 15.10 kernel
>> 4.2.0 and vanilla kernel 4.6 and latest dvb-drivers from Linux-media
>> git. With Ubuntu 15.04 and kernel 3.19 it is working. I have tryid to
>> find differences in drivers, but my knolege of c it is not possible.
>> Erros message is "invalid PC-card".
>>
>> I have also Tevii S470 with same PCIe bridge Conexant cx23885.
>>
>> How to debug this? I can do minor changes to drivers for testing it.
>>
>>    Timo Helkiö
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> Best Regards,
> Max
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{���bj)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
>

Yes, with drivers from dvbsky.net CI is working, but other card 
TechnoTrend TT-connect CT2-4650 CI stoped working totaly. It has same 
chips as Dvbsky T980C:

Demodulator: Silicon Labs Si2168-A20
Tuner: Silicon Labs Si2158-A20
CI chip: CIMaX SP2HF

Dvbsky-based driver uses precompiled sit2_op.o insteadt of s12168 module.

Who could merge these?

    Timo Helkiö
