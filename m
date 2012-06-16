Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:37202 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751515Ab2FPU1Q (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 16:27:16 -0400
Message-ID: <4FDCEC1F.2080008@iki.fi>
Date: Sat, 16 Jun 2012 23:27:11 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi>    <1339806912.13364.35.camel@Route3278> <4FDBD966.2030505@iki.fi>    <4FDBDE70.1080302@iki.fi> <1339848379.2439.18.camel@Route3278>   <4FDCABDA.2000000@iki.fi> <1339870370.1865.37.camel@Route3278>  <4FDCD35D.6020808@iki.fi> <1339877826.2697.4.camel@Route3278>
In-Reply-To: <1339877826.2697.4.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2012 11:17 PM, Malcolm Priestley wrote:
> On Sat, 2012-06-16 at 21:41 +0300, Antti Palosaari wrote:
>
>>
>> That is what you want to do:
>> ****************************
>> CALLBACK(struct dvb_usb_adapter *adap)
>> {
>>     struct dvb_frontend *fe = adap->fe[adap->active_fe];
>>     // now we have pointer to adap and fe
>> }
>>
>> That is what I want to do:
>> **************************
>> CALLBACK(struct dvb_frontend *fe)
>> {
>>     struct dvb_usb_adapter *adap = fe->dvb->priv;
>>     // now we have pointer to adap and fe
>> }
> I just don't like the idea of deliberately sending a NULL object to
> a callback.

Same here, I mentioned that many times I will fix it. And it is now 
fixed, just fetch latest changes.

>
>
> Ha ... I know what is causing the crash....its in usb_urb.c
>
>
> int usb_urb_init(struct usb_data_stream *stream,
> 		struct usb_data_stream_properties *props)
> {
> 	int ret;
>
> 	if (stream == NULL || props == NULL)
> 		return -EINVAL;
>
> 	memcpy(&stream->props, props, sizeof(*props));
>
> 	usb_clear_halt(stream->udev, usb_rcvbulkpipe(stream->udev,
> 			stream->props.endpoint));
>
> The usb_clear_halt with 0 endpoint.
>
> It can tweaked by sending a valid endpoint.

Aaah, that explains. Anyhow, I am almost sure usb_clear_halt() will not 
crash but return error in worst case. You are likely using that endpoint 
in your driver elsewhere and it is crashing as next operation to 
endpoint fails. Error in some USB control routines of your driver? It 
could be also error handling error in dvb usb routines, the idea is to 
stop device registration and un-register all if there is error. But I 
haven't tested all the error branches.

Anyhow, check recent patches and I think you are happy.

regards
Antti

-- 
http://palosaari.fi/


