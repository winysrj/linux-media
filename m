Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932379Ab2HQSsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Aug 2012 14:48:43 -0400
Message-ID: <502E91FF.2090609@redhat.com>
Date: Fri, 17 Aug 2012 15:48:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: CrazyCat <crazycat69@yandex.ru>
CC: Antti Palosaari <crope@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH] dvb_frontend: Multistream support
References: <53381345139167@web11e.yandex.ru> <502D37CF.7030608@iki.fi> <791451345225958@web24h.yandex.ru>
In-Reply-To: <791451345225958@web24h.yandex.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 17-08-2012 14:52, CrazyCat escreveu:
> 16.08.2012, 21:11, "Antti Palosaari" <crope@iki.fi>:
>> @Mauro, should we rename also DTV_ISDBS_TS_ID to DTV_ISDBS_TS_ID_LEGACY
>> to remind users ?
> 
> Maybe leave DTV_ISDBS_TS_ID and convert DTV_DVBT2_PLP_ID to  DTV_DVB_STREAM_ID ? and dvbt2_plp_id convert to dvb_stream_id.
> 
> Because DVB and ISDB different standards and look like stream id for ISDB is 16 bit, for DVB-S2/T2 8 bit.

Well, Frequency range in satellite standards are in kHz, while the frequencies on 
the other ones are in Hz. So, I don't think that the number of bits should limit
it. In a matter of fact, even on DVB-T/T2, DVB-S/S2, ... there are some fields
that gained more bits.

So, I don't see any issue on using DTV_DVB_STREAM_ID on all of them, even if
the number of bits are different.

Of course, the API documentation should be clear about the field differences.

Regards,
Mauro.
 

