Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:50038 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725535AbeLBSpj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 2 Dec 2018 13:45:39 -0500
Subject: Re: [PATCH] pulse8-cec: return 0 when invalidating the logical
 address
To: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
References: <3bc19549-ea46-1273-11b9-49482e3574f0@xs4all.nl>
 <ad8d4315-59d7-f7eb-6c35-630c57a6b64b@mbox200.swipnet.se>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <e6e2ce0a-9917-f2ad-eb2c-6abd1386adf5@xs4all.nl>
Date: Sun, 2 Dec 2018 19:45:31 +0100
MIME-Version: 1.0
In-Reply-To: <ad8d4315-59d7-f7eb-6c35-630c57a6b64b@mbox200.swipnet.se>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/02/2018 04:25 PM, Torbjorn Jansson wrote:
> On 2018-11-14 14:25, Hans Verkuil wrote:
>> Return 0 when invalidating the logical address. The cec core produces
>> a warning for drivers that do this.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reported-by: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
>> ---
>> diff --git a/drivers/media/usb/pulse8-cec/pulse8-cec.c b/drivers/media/usb/pulse8-cec/pulse8-cec.c
>> index 365c78b748dd..b085b14f3f87 100644
>> --- a/drivers/media/usb/pulse8-cec/pulse8-cec.c
>> +++ b/drivers/media/usb/pulse8-cec/pulse8-cec.c
>> @@ -586,7 +586,7 @@ static int pulse8_cec_adap_log_addr(struct cec_adapter *adap, u8 log_addr)
>>   	else
>>   		pulse8->config_pending = true;
>>   	mutex_unlock(&pulse8->config_lock);
>> -	return err;
>> +	return log_addr == CEC_LOG_ADDR_INVALID ? 0 : err;
>>   }
>>
>>   static int pulse8_cec_adap_transmit(struct cec_adapter *adap, u8 attempts,
>>
> 
> 
> question, is below warning also fixed by this patch? or is it a different problem?
> note that this warning showed up without me unplugging the usb device.
> and cec-ctl have stopped working (again...)

Yes, same problem. Nothing to do with cec-ctl having stopped working.

The real problem is this (quoted from https://hverkuil.home.xs4all.nl/cec-status.txt,
end of the section "USB CEC Dongles"):

"I'm no systemd hero and sometimes it won't pick up the device, esp. at boot
time. I would be very happy if someone can take a good look at this and
come up with better ideas. As far as I can tell the CEC device is picked
up the first time it is connected to a USB port. But unplugging it, then
replugging it into the same USB port will not pick it up again. You need
to run inputattach manually in that case. It's something in udev/systemd,
but I have no idea how to fix it."

I have no time to chase this issue down. It probably requires contacting
some systemd mailinglist and talk to people who actually understand
systemd. If you want, you can give that a go.

Regards,

	Hans
