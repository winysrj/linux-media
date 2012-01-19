Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40924 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942Ab2ASPxH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Jan 2012 10:53:07 -0500
Message-ID: <4F183C60.6010403@iki.fi>
Date: Thu, 19 Jan 2012 17:53:04 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVBv5 test report
References: <4F17422E.1030408@iki.fi> <4F17FFA3.4040103@redhat.com> <4F18053D.1050404@iki.fi> <4F181B19.4060300@redhat.com>
In-Reply-To: <4F181B19.4060300@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/19/2012 03:31 PM, Mauro Carvalho Chehab wrote:
> Em 19-01-2012 09:57, Antti Palosaari escreveu:
>> On 01/19/2012 01:33 PM, Mauro Carvalho Chehab wrote:
>>> Em 18-01-2012 20:05, Antti Palosaari escreveu:
>>>> I tested almost all DVB-T/T2/C devices I have and all seems to be working, excluding Anysee models when using legacy zap.
>>>>
>>>> Anysee  anysee_streaming_ctrl() will fail because mutex_lock_interruptible() returns -EINTR in anysee_ctrl_msg() function when zap is killed using ctrl+c. This will led error returned to DVB-USB-core and log writing "dvb-usb: error while stopping stream."
>>>>
>>>> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/anysee.c
>>>>
>>>> http://git.linuxtv.org/media_tree.git/blob/refs/heads/master:/drivers/media/dvb/dvb-usb/dvb-usb-urb.c
>>>>
>>>> If I change mutex_lock_interruptible() =>   mutex_lock() it will work. I think it gets SIGINT (ctrl+c) from userland, but how this haven't been issue earlier?
>>>>
>>>> Anyone have idea what's wrong/reason here?
>>>
>>> No idea. That part of the code wasn't changed recently, AFAIK, and
>>> for sure it weren't affected by the frontend changes.
>>>
>>> I suspect that the bug was already there, but it weren't noticed
>>> before.
>>
>> Yeah, that's what I suspect too. But it still looks weird since DVB USB generic
>> dvb_usb_generic_rw() function uses same mutex logic and it is very widely used
>> about all DVB USB drivers. The reason Anysee driver have own mutex is weird USB
>> message sequence that is 1xSEND 2xRECEIVE, instead normal 1xSEND 1xRECEIVE.
>
> I think that this is a sort of race issue: as you're taking more time at anysee,
> it is more likely to receive the break while stopping the stream.

I installed latest 3.2.1 Kernel and no that error seen so it is regression.
Linux localhost.localdomain 3.2.1 #1 SMP Thu Jan 19 16:07:04 EET 2012 
x86_64 x86_64 x86_64 GNU/Linux

Hardware does not stop streaming since streaming command is newer send - 
it is mutex protecting control messages that returns EINTR and command 
was terminated before it happens.


>> I did skeleton code below clear the issue.
>>
>> dvb_usb_generic_rw() {
>>     if ((ret = mutex_lock_interruptible(&d->usb_mutex)))
>>        return ret;
>>
>>     usb_bulk_msg(SEND BULK USB MESSAGE);
>>     usb_bulk_msg(RECEIVE BULK USB MESSAGE);
>>
>>     mutex_unlock(&d->usb_mutex);
>> }
>>
>> anysee_ctrl_msg() {
>>     if (mutex_lock_interruptible(&anysee_usb_mutex)<  0)
>>        return -EAGAIN;
>>
>>     dvb_usb_generic_rw();
>>     usb_bulk_msg(RECEIVE BULK USB MESSAGE); // really!
>>
>>     mutex_unlock(&anysee_usb_mutex);
>> }
>>
>>
>>>
>>> The fix seems to be as simple as:
>>>
>>> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>>> index ddf282f..6e707b5 100644
>>> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>>> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
>>> @@ -32,7 +32,8 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>>>            if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
>>>                ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
>>>                if (ret<   0) {
>>> -                err("error while stopping stream.");
>>> +                if (ret != -EAGAIN)
>>> +                    err("error while stopping stream.");
>>>                    return ret;
>>>                }
>>>            }
>>>
>>> And make sure to remap -EINTR as -EAGAIN, leaving to the
>>> userspace to retry it. Alternatively, the dvb frontend core
>>> or the anysee could retry it after a while for streaming
>>> stop.
>>>
>>> Another alternative that would likely work better would
>>> be to just use mutex_lock() for streaming stop, but this
>>> would require the review of all implementations for
>>> streaming_ctrl
>>
>> I think some changes for DVB USB are needed because after .streaming_ctrl()
>> fail it will not stream anything later attempts until device is re-plugged.
>> Having this kind of effect in case of single driver callback failure is not acceptable.
>
> After thinking a little about it, I think that the best thing to do here is to
> retry automatically, like the enclosed patch.
>
> The patch doesn't take into account the device mode. If it were opened
> in non-block mode, the right behaviour would likely to return -EAGAIN,
> and let userspace to retry it.
>
>> regards
>> Antti
>
> [PATCH] dvb-usb: Don't abort stop on -EAGAIN/-EINTR
>
> Note: this patch is not complete. if the DVB demux device is opened on
> block mode, it should instead be returning -EAGAIN.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> index ddf282f..215ce75 100644
> --- a/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> +++ b/drivers/media/dvb/dvb-usb/dvb-usb-dvb.c
> @@ -30,7 +30,9 @@ static int dvb_usb_ctrl_feed(struct dvb_demux_feed *dvbdmxfeed, int onoff)
>   		usb_urb_kill(&adap->fe_adap[adap->active_fe].stream);
>
>   		if (adap->props.fe[adap->active_fe].streaming_ctrl != NULL) {
> -			ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
> +			do {
> +				ret = adap->props.fe[adap->active_fe].streaming_ctrl(adap, 0);
> +			} while ((ret == -EAGAIN) || (ret == -EINTR));
>   			if (ret<  0) {
>   				err("error while stopping stream.");
>   				return ret;
>
> --

I have no knowledge which is correct and which is not. But as this is 
regression problem I wish to know actual reason until code changes are done.

I compiled latest 3.1.10 and 3.2.1 vanilla Kernels form kernel.org and 
those worked as expected.

regards
Antti
-- 
http://palosaari.fi/
