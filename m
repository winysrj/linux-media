Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40578 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753814Ab3LCQCg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Dec 2013 11:02:36 -0500
Message-ID: <529E0099.6000408@iki.fi>
Date: Tue, 03 Dec 2013 18:02:33 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/2] af9035: fix broken I2C and USB I/O
References: <1385584128-2632-1-git-send-email-crope@iki.fi> <1385584128-2632-2-git-send-email-crope@iki.fi> <20131203130658.5c80d75b.m.chehab@samsung.com>
In-Reply-To: <20131203130658.5c80d75b.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03.12.2013 17:06, Mauro Carvalho Chehab wrote:
> Em Wed, 27 Nov 2013 22:28:48 +0200
> Antti Palosaari <crope@iki.fi> escreveu:
>
>> There was three small buffer len calculation bugs which caused
>> driver non-working. These are coming from recent commit:
>> commit 7760e148350bf6df95662bc0db3734e9d991cb03
>> [media] af9035: Don't use dynamic static allocation
>>
>> Signed-off-by: Antti Palosaari <crope@iki.fi>
>> ---
>>   drivers/media/usb/dvb-usb-v2/af9035.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
>> index c8fcd78..403bf43 100644
>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>> @@ -131,7 +131,7 @@ static int af9035_wr_regs(struct dvb_usb_device *d, u32 reg, u8 *val, int len)
>>   {
>>   	u8 wbuf[MAX_XFER_SIZE];
>>   	u8 mbox = (reg >> 16) & 0xff;
>> -	struct usb_req req = { CMD_MEM_WR, mbox, sizeof(wbuf), wbuf, 0, NULL };
>> +	struct usb_req req = { CMD_MEM_WR, mbox, 6 + len, wbuf, 0, NULL };
>>
>>   	if (6 + len > sizeof(wbuf)) {
>>   		dev_warn(&d->udev->dev, "%s: i2c wr: len=%d is too big!\n",
>> @@ -238,7 +238,7 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>>   		} else {
>>   			/* I2C */
>>   			u8 buf[MAX_XFER_SIZE];
>> -			struct usb_req req = { CMD_I2C_RD, 0, sizeof(buf),
>> +			struct usb_req req = { CMD_I2C_RD, 0, 5 + msg[0].len,
>
> You should check first if msg[0].len + 5 is not bigger than sizeof(buf).
>
>>   					buf, msg[1].len, msg[1].buf };
>>
>>   			if (5 + msg[0].len > sizeof(buf)) {

Could you explain why? Why it is not enough to check it later as it is 
done in line just top of that text?



>> @@ -274,8 +274,8 @@ static int af9035_i2c_master_xfer(struct i2c_adapter *adap,
>>   		} else {
>>   			/* I2C */
>>   			u8 buf[MAX_XFER_SIZE];
>> -			struct usb_req req = { CMD_I2C_WR, 0, sizeof(buf), buf,
>> -					0, NULL };
>> +			struct usb_req req = { CMD_I2C_WR, 0, 5 + msg[0].len,
>> +					buf, 0, NULL };
>
> Same here: you should check first if msg[0].len + 5 is not bigger than sizeof(buf).
>
>>
>>   			if (5 + msg[0].len > sizeof(buf)) {
>>   				dev_warn(&d->udev->dev,

Same here. I don't really see your point.

Antti


-- 
http://palosaari.fi/
