Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:49861 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab2HKAPJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Aug 2012 20:15:09 -0400
Message-ID: <5025A3FD.8020001@iki.fi>
Date: Sat, 11 Aug 2012 03:14:53 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: CrazyCat <crazycat69@yandex.ru>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manu Abraham <manu@linuxtv.org>
Subject: Re: [PATCH] DVB-S2 multistream support
References: <59951342221302@web18g.yandex.ru> <50258758.8050902@redhat.com>
In-Reply-To: <50258758.8050902@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/2012 01:12 AM, Mauro Carvalho Chehab wrote:
> Em 13-07-2012 20:15, CrazyCat escreveu:

>>   #define DTV_ISDBS_TS_ID		42
>>
>>   #define DTV_DVBT2_PLP_ID	43
>> +#define DTV_DVBS2_MIS_ID	43
>
> It would be better to define it as:
>
> #define DTV_DVBS2_MIS_ID	DTV_DVBT2_PLP_ID
>
> Even better, we should instead find a better name that would cover both
> DVB-T2 and DVB-S2 program ID fields, like:
>
> #define DTV_DVB_MULT		43
> #define DTV_DVBT2_PLP_ID	DTV_DVB_MULT
>
> And use the new symbol for both DVB-S2 and DVB-T2, deprecating the
> legacy symbol.

Also DTV_ISDBS_TS_ID means same. All these three DTV_ISDBS_TS_ID, 
DTV_DVBT2_PLP_ID and DTV_DVBS2_MIS_ID are same thing - just named 
differently between standards. I vote for common name TS ID (I have said 
that already enough many times...).

Research paper [1] ISDB-S says:
"
New technologies like the trellis-coded 8PSK (TC8PSK) modulation scheme 
were adopted for this section to improve transmission capacity as much 
as possible and to enable multiple transport streams (TSs) to be handled 
by one carrier. This channel coding system has consequently become a 
system standard known for its flexibility and extendibility.
"
"
It enables multiple MPEG-TSs to be transmitted with one transponder, and 
because transmission systems can be switched for each TS signal, it 
enables TS signals produced by each broadcaster to be transmitted 
independently.
"

[1] http://www.tijbc.com/pruebas-7419/I0782925.pdf

regards
Antti

-- 
http://palosaari.fi/
