Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60775 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225Ab3CZKAt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Mar 2013 06:00:49 -0400
Message-ID: <515171A9.3070308@iki.fi>
Date: Tue, 26 Mar 2013 12:00:09 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: mchehab@redhat.com
CC: Wei Yongjun <weiyj.lk@gmail.com>, yongjun_wei@trendmicro.com.cn,
	linux-media@vger.kernel.org
Subject: Re: [PATCH -next] [media] af9035: fix missing unlock on error in
 af9035_ctrl_msg()
References: <CAPgLHd8Ow5eV=zrOJ7PxWtOFn2qLwVd_Ys2LNE3ddL4gf3EFQg@mail.gmail.com> <51516E76.8010508@iki.fi>
In-Reply-To: <51516E76.8010508@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

@Mauro, that bug is new and coming as I rebased AF9035 IR code to the 
new AF9035 non-stacked usb buffers, which introduces that mutex. Just 
apply it to the current master.

regards
Antti



On 03/26/2013 11:46 AM, Antti Palosaari wrote:
> On 03/26/2013 07:32 AM, Wei Yongjun wrote:
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Add the missing unlock before return from function af9035_ctrl_msg()
>> in the error handling case.
>>
>> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Acked-by: Antti Palosaari <crope@iki.fi>
> Reviewed-by: Antti Palosaari <crope@iki.fi>
>
>
>> ---
>>   drivers/media/usb/dvb-usb-v2/af9035.c | 17 +++++++++--------
>>   1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c
>> b/drivers/media/usb/dvb-usb-v2/af9035.c
>> index b1f7059..b638fc1 100644
>> --- a/drivers/media/usb/dvb-usb-v2/af9035.c
>> +++ b/drivers/media/usb/dvb-usb-v2/af9035.c
>> @@ -57,7 +57,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d,
>> struct usb_req *req)
>>           dev_err(&d->udev->dev, "%s: too much data wlen=%d rlen=%d\n",
>>                   __func__, req->wlen, req->rlen);
>>           ret = -EINVAL;
>> -        goto err;
>> +        goto exit;
>>       }
>>
>>       state->buf[0] = REQ_HDR_LEN + req->wlen + CHECKSUM_LEN - 1;
>> @@ -81,7 +81,7 @@ static int af9035_ctrl_msg(struct dvb_usb_device *d,
>> struct usb_req *req)
>>       ret = dvb_usbv2_generic_rw_locked(d,
>>               state->buf, wlen, state->buf, rlen);
>>       if (ret)
>> -        goto err;
>> +        goto exit;
>>
>>       /* no ack for those packets */
>>       if (req->cmd == CMD_FW_DL)
>> @@ -95,28 +95,29 @@ static int af9035_ctrl_msg(struct dvb_usb_device
>> *d, struct usb_req *req)
>>                   "(%04x != %04x)\n", KBUILD_MODNAME, req->cmd,
>>                   tmp_checksum, checksum);
>>           ret = -EIO;
>> -        goto err;
>> +        goto exit;
>>       }
>>
>>       /* check status */
>>       if (state->buf[2]) {
>>           /* fw returns status 1 when IR code was not received */
>> -        if (req->cmd == CMD_IR_GET || state->buf[2] == 1)
>> -            return 1;
>> +        if (req->cmd == CMD_IR_GET || state->buf[2] == 1) {
>> +            ret = 1;
>> +            goto exit;
>> +        }
>>
>>           dev_dbg(&d->udev->dev, "%s: command=%02x failed fw error=%d\n",
>>                   __func__, req->cmd, state->buf[2]);
>>           ret = -EIO;
>> -        goto err;
>> +        goto exit;
>>       }
>>
>>       /* read request, copy returned data to return buf */
>>       if (req->rlen)
>>           memcpy(req->rbuf, &state->buf[ACK_HDR_LEN], req->rlen);
>>   exit:
>> -err:
>>       mutex_unlock(&d->usb_mutex);
>> -    if (ret)
>> +    if (ret < 0)
>>           dev_dbg(&d->udev->dev, "%s: failed=%d\n", __func__, ret);
>>       return ret;
>>   }
>>
>>
>
>


-- 
http://palosaari.fi/
