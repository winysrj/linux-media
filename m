Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48040 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab2ASL5w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 06:57:52 -0500
Message-ID: <4F18053D.1050404@iki.fi>
Date: Thu, 19 Jan 2012 13:57:49 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVBv5 test report
References: <4F17422E.1030408@iki.fi> <4F17FFA3.4040103@redhat.com>
In-Reply-To: <4F17FFA3.4040103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2012 01:33 PM, Mauro Carvalho Chehab wrote:
> Em 18-01-2012 20:05, Antti Palosaari escreveu:
>> I tested almost all DVB-T/T2/C devices I have and all seems to be working, excluding Anysee models when using legacy zap.
>>
>> Anysee  anysee_streaming_ctrl() will fail because mutex_lock_interruptible() returns -EINTR in anysee_ctrl_msg() function when zap is killed using ctrl+c. This will led error returned to DVB-USB-core and log writing "dvb-usb: error while stopping stream."
>>
>> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/anysee.c
>>
>> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
>>
>> If I change mutex_lock_interruptible() =>  mutex_lock() it will work. I think it gets SIGINT (ctrl+c) from userland, but how this haven't been issue earlier?
>>
>> Anyone have idea what's wrong/reason here?
>
> No idea. That part of the code wasn't changed recently, AFAIK, and
> for sure it weren't affected by the frontend changes.
>
> I suspect that the bug was already there, but it weren't noticed
> before.

Yeah, that's what I suspect too. But it still looks weird since DVB USB 
generic dvb_usb_generic_rw() function uses same mutex logic and it is 
very widely used about all DVB USB drivers. The reason Anysee driver 
have own mutex is weird USB message sequence that is 1xSEND 2xRECEIVE, 
instead normal 1xSEND 1xRECEIVE.

I did skeleton code below clear the issue.

dvb_usb_generic_rw() {
    if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
       return ret;

    usb_bulk_msg(SEND BULK USB MESSAGE);
    usb_bulk_msg(RECEIVE BULK USB MESSAGE);

    mutex_unlock(&d->usb_mutex);
}

anysee_ctrl_msg() {
    if (mutex_lock_interruptible(&anysee_usb_mutex) < 0)
       return -EAGAIN;

    dvb_usb_generic_rw();
    usb_bulk_msg(RECEIVE BULK USB MESSAGE); // really!

    mutex_unlock(&anysee_usb_mutex);
}


>
> The fix seems to be as simple as:
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> index ddf282f..6e707b5 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> @@ -32,7 +32,8 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>   		if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
>   			ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
>   			if (ret<  0) {
> -				err("error while stopping stream.");
> +				if (ret != -EAGAIN)
> +					err("error while stopping stream.");
>   				return ret;
>   			}
>   		}
>
> And make sure to remap -EINTR as -EAGAIN, leaving to the
> userspace to retry it. Alternatively, the dvb frontend core
> or the anysee could retry it after a while for streaming
> stop.
>
> Another alternative that would likely work better would
> be to just use mutex_lock() for streaming stop, but this
> would require the review of all implementations for
> streaming_ctrl

I think some changes for DVB USB are needed because after 
.streaming_ctrl() fail it will not stream anything later attempts until 
device is re-plugged. Having this kind of effect in case of single 
driver callback failure is not acceptable.

regards
Antti
-- 
http://palosaari.fi/
