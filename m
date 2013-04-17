Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48592 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936043Ab3DQTSx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 15:18:53 -0400
Message-ID: <516EF569.8070709@iki.fi>
Date: Wed, 17 Apr 2013 22:18:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Steven Toth <stoth@linuxtv.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Darron Broad <darron@kewl.org>, linux-media@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [RFC] [media] dvb-core: check ->msg_len for diseqc_send_master_cmd()
References: <20130402075102.GA11233@longonot.mountain> <20130417120314.GX6692@mwanda>
In-Reply-To: <20130417120314.GX6692@mwanda>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2013 03:03 PM, Dan Carpenter wrote:
> Any feedback on this?
>
> I forgot to CC Steven Toth last time because he would know about the
> cx24116 driver.  I've looked at it again and it still looks like
> cx24116_send_diseqc_msg() is copying garbage into the
> state->dsec_cmd.args[] array.

It looks fine. I have thought that same few times earlier too. Thank you.

Reviewed-by: Antti Palosaari <crope@iki.fi>



>
> regards,
> dan carpenter
>
> On Tue, Apr 02, 2013 at 10:51:02AM +0300, Dan Carpenter wrote:
>> I'd like to send this patch except that it "breaks"
>> cx24116_send_diseqc_msg().  The cx24116 driver accepts ->msg_len values
>> up to 24 but it looks like it's just copying 16 bytes past the end of
>> the ->msg[] array so it's already broken.
>>
>> cmd->msg_len is an unsigned char.  The comment next to the struct
>> declaration says that valid values are are 3-6.  Some of the drivers
>> check that this is true, but most don't and it could cause memory
>> corruption.
>>
>> Some examples of functions which don't check are:
>> ttusbdecfe_dvbs_diseqc_send_master_cmd()
>> cx24123_send_diseqc_msg()
>> ds3000_send_diseqc_msg()
>> etc.
>>
>> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
>> index 57601c0..3d1eee6 100644
>> --- a/drivers/media/dvb-core/dvb_frontend.c
>> +++ b/drivers/media/dvb-core/dvb_frontend.c
>> @@ -2265,7 +2265,13 @@ static int dvb_frontend_ioctl_legacy(struct file *file,
>>
>>   	case FE_DISEQC_SEND_MASTER_CMD:
>>   		if (fe->ops.diseqc_send_master_cmd) {
>> -			err = fe->ops.diseqc_send_master_cmd(fe, (struct dvb_diseqc_master_cmd*) parg);
>> +			struct dvb_diseqc_master_cmd *cmd = parg;
>> +
>> +			if (cmd->msg_len >= 3 && cmd->msg_len <= 6)
>> +				err = fe->ops.diseqc_send_master_cmd(fe, cmd);
>> +			else
>> +				err = -EINVAL;
>> +
>>   			fepriv->state = FESTATE_DISEQC;
>>   			fepriv->status = 0;
>>   		}


-- 
http://palosaari.fi/
