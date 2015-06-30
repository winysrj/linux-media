Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.netup.ru ([77.72.80.15]:55872 "EHLO imap.netup.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752584AbbF3KhH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Jun 2015 06:37:07 -0400
Message-ID: <55926F51.2080808@netup.ru>
Date: Tue, 30 Jun 2015 13:28:33 +0300
From: Kozlov Sergey <serjk@netup.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: linux-media@vger.kernel.org, aospan1@gmail.com
Subject: Re: [PATCH V2 4/5] [media] cxd2841er: Sony CXD2841ER DVB-S/S2/T/T2/C
 demodulator driver
References: <1429092470-29697-1-git-send-email-serjk@netup.ru> <1429092470-29697-5-git-send-email-serjk@netup.ru> <20150514111545.306c14da@recife.lan>
In-Reply-To: <20150514111545.306c14da@recife.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

Thanks for your review.
I started work on V3 patch series, and found no information about 
roll-off handling in the CDX2841 demodulator chip documentation. It 
seemks that roll-off is handled automatically.

Best regards,
Sergey

14.05.2015 17:15, Mauro Carvalho Chehab пишет:
> Em Wed, 15 Apr 2015 13:07:49 +0300
> serjk@netup.ru escreveu:
>> +
>> +static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
>> +{
>> +	int ret = 0, i, timeout, carr_offset;
>> +	fe_status_t status;
>> +	struct cxd2841er_priv *priv = fe->demodulator_priv;
>> +	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
>> +	u32 symbol_rate = p->symbol_rate/1000;
>> +
>> +	dev_dbg(&priv->i2c->dev, "%s(): %s frequency=%d symbol_rate=%d\n",
>> +		__func__,
>> +		(p->delivery_system == SYS_DVBS ? "DVB-S" : "DVB-S2"),
>> +		 p->frequency, symbol_rate);
>
> I was unable to identify how ROLLOFF is handled for DVB-S2 in this code.
>

