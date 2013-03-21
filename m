Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37818 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3CUXqI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Mar 2013 19:46:08 -0400
Message-ID: <514B9B9A.7010502@iki.fi>
Date: Fri, 22 Mar 2013 01:45:30 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [REVIEW PATCH 11/41] af9035: basic support for IT9135 v2 chips
References: <1362881013-5271-1-git-send-email-crope@iki.fi> <1362881013-5271-11-git-send-email-crope@iki.fi> <20130321185422.4c2c9696@redhat.com>
In-Reply-To: <20130321185422.4c2c9696@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/21/2013 11:54 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 10 Mar 2013 04:03:03 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>>   static struct ite_config af9035_it913x_config = {
>> -	.chip_ver = 0x01,
>> +	.chip_ver = 0x02,

>> @@ -1153,6 +1161,7 @@ static int af9035_tuner_attach(struct dvb_usb_adapter *adap)
>>   	case AF9033_TUNER_IT9135_38:
>>   	case AF9033_TUNER_IT9135_51:
>>   	case AF9033_TUNER_IT9135_52:
>> +		af9035_it913x_config.chip_ver = 0x01;
>
> Hmmm... aren't you missing a break here? If not, please add a comment, as
> otherwise reviewers think that this is a bug.

It is correct as it was set 0x02 by init. And variable was removed 
totally few patches later.


regards
Antti

-- 
http://palosaari.fi/
