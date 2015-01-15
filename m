Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:39921 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbAOLUf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 06:20:35 -0500
Received: by mail-pd0-f171.google.com with SMTP id y13so15803520pdi.2
        for <linux-media@vger.kernel.org>; Thu, 15 Jan 2015 03:20:35 -0800 (PST)
Message-ID: <54B7A27E.1030406@gmail.com>
Date: Thu, 15 Jan 2015 20:20:30 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>, linux-media@vger.kernel.org
CC: m.chehab@samsung.com
Subject: Re: [RFC/PATCH] dvb-core: add template code for i2c binding model
References: <1417776573-16182-1-git-send-email-tskd08@gmail.com> <54B569F9.2050105@iki.fi>
In-Reply-To: <54B569F9.2050105@iki.fi>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Moikka,
thank you for the comment.

On 2015年01月14日 03:54, Antti Palosaari wrote:
>> --- a/drivers/media/dvb-core/dvb_frontend.h
>> +++ b/drivers/media/dvb-core/dvb_frontend.h
>> @@ -415,6 +415,7 @@ struct dtv_frontend_properties {
>>   struct dvb_frontend {
>>       struct dvb_frontend_ops ops;
>>       struct dvb_adapter *dvb;
>> +    struct i2c_client *fe_cl;
> 
> IMHO that is ugly as hell. You should not add any hardware/driver things
> to DVB frontend, even more bad this adds I2C dependency to DVB frontend,
> how about some other busses... DVB frontend is *logical* entity
> representing the DVB device to system. All hardware specific things
> belongs to drivers - not the frontend at all.

Currently, the i2c_client pointer is distributed/copied among
each demod drivers plus adapter drivers,
so I thought it would be better to unify them into one place,
but since there seems to be no good (common) place to store it,
I'll consider your advice and remove this fe_cl member.

Regards,
akihiro
