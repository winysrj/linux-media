Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923Ab2AWRQe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 12:16:34 -0500
Message-ID: <4F1D95E7.50709@redhat.com>
Date: Mon, 23 Jan 2012 15:16:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVBv5 test report
References: <4F17422E.1030408@iki.fi> <4F17FFA3.4040103@redhat.com> <4F18053D.1050404@iki.fi> <4F181B19.4060300@redhat.com> <4F1D898A.8020802@iki.fi>
In-Reply-To: <4F1D898A.8020802@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 23-01-2012 14:23, Antti Palosaari escreveu:
> On 01/19/2012 03:31 PM, Mauro Carvalho Chehab wrote:
>> [PATCH] dvb-usb: Don't abort stop on -EAGAIN/-EINTR
>>
>> Note: this patch is not complete. if the DVB demux device is opened on
>> block mode, it should instead be returning -EAGAIN.
>>
>> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>>
>> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>> index ddf282f..215ce75 100644
>> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>> @@ -30,7 +30,9 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>>           usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
>>
>>           if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
>> -            ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
>> +            do {
>> +                ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
>> +            } while ((ret == -EAGAIN) || (ret == -EINTR));
>>               if (ret<  0) {
>>                   err("error while stopping stream.");
>>                   return ret;
>>
> 
> That fixes it. But it loops do {...} while around 100 times every I stop zap. Over 100 times is rather much...

Yes, this sounds too much. 

The issue here is caused by the usage of mutex_lock_interruptible() inside the
streaming_ctrl() callbacks, when the stream should stop.

The new wait_queue wakeup inside the code made the issue more visible, but it
could still happen without it, as a break could be hit during stream_ctl()
stop call anyway.

There are two possible fixes for it:

1) The above solution.

Eventually, a schedule() could be added there:
            do {
                ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
		if (ret == -EINTR)
			shedule();
            } while (ret == -EINTR);

2)

Don't use mutex_lock_interruptible inside the driver's streaming_ctrl, 
if the second parameter is 0 (stop).


IMHO, (1) is cleaner, due to a few reasons:

	- inside the drivers, the code will be symmetrical: it will call the same function for
both onoff = 1 and onoff = 0.

	- The patch is on just one place;

	- with (2), extra care is needed when merging patches, as regressions and
broken drivers could pass unnoticed.

> 
> And I think -EINTR is the only code to look, -EAGAIN is maybe for I2C and can be switched to native -EINTR also.

Drivers need to be checked, if only -EINTR is added there, as drivers may
be doing things like:

	if (mutex_lock_interruptible(...))
		return -EAGAIN;

Regards,
Mauro
