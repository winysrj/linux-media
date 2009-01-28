Return-path: <linux-media-owner@vger.kernel.org>
Received: from dyn60-31.dsl.spy.dnainternet.fi ([83.102.60.31]:37613 "EHLO
	shogun.pilppa.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754858AbZA1XI7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Jan 2009 18:08:59 -0500
Date: Thu, 29 Jan 2009 01:08:53 +0200 (EET)
From: Mika Laitio <lamikr@pilppa.org>
To: n37 <n37lkml@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Broken Tuning on Wintv Nova HD S2
In-Reply-To: <b1dab3a10901280209w291507b2lfdba81b60cb16e36@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0901290104440.10175@shogun.pilppa.org>
References: <497F7117.9000607@dark-green.com>
 <b1dab3a10901280209w291507b2lfdba81b60cb16e36@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I also can confirm this. Reverting to a previous revision restores
> proper tuning to vertical transponders.

I can also confirm it with hvr-4000 and latest drivers v4l-dvb drivers 
from linuxtv org. Before I reverted this patch, I could not get lock 
with vdr for example to:

Sky News;BT:11597:vC56:S19.2E:22000:305+131:306=eng:579:0:28707:1:1026:0
Al 
Jazeera;CANALSATELLITE:11567:vC56:S19.2E:22000:55:56=ara:0:0:9021:1:1024:0

while this worked

Eurosport;SES 
Astra:12226:hC34:S19.2E:27500:101:103=deu:102:0:31200:1:1091:0

Once I reverted that patch, all channels showed up nicely.

Mika

>
> On Tue, Jan 27, 2009 at 10:39 PM, gimli <gimli@dark-green.com> wrote:
>> Hi,
>>
>> the following changesets breaks Tuning to Vertical Transponders :
>>
>> http://mercurial.intuxication.org/hg/s2-liplianin/rev/1ca67881d96a
>> http://linuxtv.org/hg/v4l-dvb/rev/2cd7efb4cc19
>>
>> For example :
>>
>> DMAX;BetaDigital:12246:vC34M2O0S0:S19.2E:27500:511:512=deu:32:0:10101:1:1092:0
>>
>>
>> cu
>>
>> Edgar ( gimli ) Hucek
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
