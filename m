Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:36105 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322Ab1EFMXX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2011 08:23:23 -0400
Message-ID: <4DC3E82A.7040202@redhat.com>
Date: Fri, 06 May 2011 09:23:06 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Steve Kerrison <steve@stevekerrison.com>
CC: Andreas Oberritter <obi@linuxtv.org>, linux-media@vger.kernel.org,
	Antti Palosaari <crope@iki.fi>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] Sony CXD2820R DVB-T/T2/C demodulator
 driver
References: <E1QHwSm-0006hA-A9@www.linuxtv.org>	 <4DC3C6FA.8070505@linuxtv.org> <1304678539.8670.29.camel@ares>
In-Reply-To: <1304678539.8670.29.camel@ares>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 06-05-2011 07:42, Steve Kerrison escreveu:
> Hi Andreas,
> 
> From cxd2820r_priv.h:
> 
>> +/*
>> + * FIXME: These are totally wrong and must be added properly to the API.
>> + * Only temporary solution in order to get driver compile.
>> + */
>> +#define SYS_DVBT2             SYS_DAB
>> +#define TRANSMISSION_MODE_1K  0
>> +#define TRANSMISSION_MODE_16K 0
>> +#define TRANSMISSION_MODE_32K 0
>> +#define GUARD_INTERVAL_1_128  0
>> +#define GUARD_INTERVAL_19_128 0
>> +#define GUARD_INTERVAL_19_256 0
> 
> 
> I believe Antti didn't want to make frontent.h changes until a consensus
> was reached on how to develop the API for T2 support.

Yeah.

Andreas/Antti,

It seems more appropriate to remove the above hack and add Andreas patch.
I've reviewed it and it seemed ok on my eyes, provided that we also update
DVB specs to reflect the changes.

In special, the new DVB command should be documented:
	+#define DTV_DVBT2_PLP_ID	43


Thanks,
Mauro
