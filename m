Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:53539 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbaIDXCi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Sep 2014 19:02:38 -0400
Received: from dyn3-82-128-191-243.psoas.suomi.net ([82.128.191.243] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1XPg32-0005Oy-M2
	for linux-media@vger.kernel.org; Fri, 05 Sep 2014 02:02:36 +0300
Message-ID: <5408EF8A.5040402@iki.fi>
Date: Fri, 05 Sep 2014 02:02:34 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/3] af9035: remove I2C client differently
References: <1409867023-8362-1-git-send-email-crope@iki.fi> <1409867023-8362-3-git-send-email-crope@iki.fi> <20140904225038.GA27825@minime.bse>
In-Reply-To: <20140904225038.GA27825@minime.bse>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 09/05/2014 01:50 AM, Daniel Gl�ckner wrote:
> On Fri, Sep 05, 2014 at 12:43:43AM +0300, Antti Palosaari wrote:
>> +	switch (state->af9033_config[adap->id].tuner) {
>> +	case AF9033_TUNER_IT9135_38:
>> +	case AF9033_TUNER_IT9135_51:
>> +	case AF9033_TUNER_IT9135_52:
>> +	case AF9033_TUNER_IT9135_60:
>> +	case AF9033_TUNER_IT9135_61:
>> +	case AF9033_TUNER_IT9135_62:
>> +		demod2 = 2;
>> +	default:
>> +		demod2 = 1;
>> +	}
>
> Missing break?
>

YES! will fix...
It does not have functionality error in that case, but sure it is wrong 
and may jump up later when some changes are done.

regards
Antti

-- 
http://palosaari.fi/
