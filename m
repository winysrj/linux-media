Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:39260 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806Ab2FPSli (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 14:41:38 -0400
Message-ID: <4FDCD35D.6020808@iki.fi>
Date: Sat, 16 Jun 2012 21:41:33 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi>   <1339806912.13364.35.camel@Route3278> <4FDBD966.2030505@iki.fi>   <4FDBDE70.1080302@iki.fi> <1339848379.2439.18.camel@Route3278>  <4FDCABDA.2000000@iki.fi> <1339870370.1865.37.camel@Route3278>
In-Reply-To: <1339870370.1865.37.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/16/2012 09:12 PM, Malcolm Priestley wrote:
> On Sat, 2012-06-16 at 18:52 +0300, Antti Palosaari wrote:
>> On 06/16/2012 03:06 PM, Malcolm Priestley wrote:
>>> On Sat, 2012-06-16 at 04:16 +0300, Antti Palosaari wrote:
>>>> I did example for you, here you are :)
>>>>
>>>> On 06/16/2012 03:55 AM, Antti Palosaari wrote:
>>>>> On 06/16/2012 03:35 AM, Malcolm Priestley wrote:
>>>>>> On Sat, 2012-06-16 at 01:54 +0300, Antti Palosaari wrote:
>>>>>>> Hello Malcolm,
>>>>>>>
>>>>>>> On 06/16/2012 01:11 AM, Malcolm Priestley wrote:
>>>>>>>> Hi Antti
>>>>>>>>
>>>>>>>> You can't have dvb_usb_device_properties as constant structure pointer.
>>>>>>>>
>>>>>>>> At run time it needs to be copied to a private area.
>>>>>>>
>>>>>>> Having constant structure for properties was one of main idea of whole
>>>>>>> change. Earlier it causes some problems when driver changes those values
>>>>>>> - for example remote configuration based info from the eeprom.
>>>>>>>
>>>>>>>> Two or more devices of the same type on the system will be pointing to
>>>>>>>> the same structure.
>>>>>>>
>>>>>>> Yes and no. You can define struct dvb_usb_device_properties for each
>>>>>>> USB ID.
>>>>>>>
>>>>>>>> Any changes they make to the structure will be common to all.
>>>>>>>
>>>>>>> For those devices having same USB ID only.
>>>>>>> Changing dvb_usb_device_properties is *not* allowed. It is constant and
>>>>>>> should be. That was how I designed it. Due to that I introduced those
>>>>>>> new callbacks to resolve needed values dynamically.
>>>>>> Yes, but it does make run-time tweaks difficult.
>>>>>>
>>>>>>> If there is still something that is needed to resolve at runtime I am
>>>>>>> happy to add new callback. For example PID filter configuration is
>>>>>>> static currently as per adapter and if it is needed to to reconfigure at
>>>>>>> runtime new callback is needed.
>>>>>> I will look at the PID filter later, it defaulted to off.
>>>>>>
>>>>>> However, in my builds for ARM devices it is defaulted on. I will be
>>>>>> testing this later. I can't see any problems.
>>>>>>
>>>>>>>
>>>>>>> Could you say what is your problem I can likely say how to resolve it.
>>>>>>>
>>>>>>
>>>>>> Well, the problem is, I now need two separate structures for LME2510 and
>>>>>> LME2510C as in the existing driver, the hope was to merge them as one.
>>>>>> The only difference being the stream endpoint number.
>>>>>
>>>>> Then you should use .get_usb_stream_config() instead of static stream
>>>>> configuration. That is now supported.
>>>>>
>>>>> I have found one logical error in my current implementation.
>>>>> get_usb_stream_config gets frontend as a parameter, but it is called
>>>>> frontend == NULL when attaching adapters and after that frontend is real
>>>>> value when called (just before streaming is started). Now what happens
>>>>> if we has multiple adapters? We cannot know which adapter is requested
>>>>> during attach since FE is NULL :)
>>>>> But that is problem case only if you have multiple adapters. I will find
>>>>> out better solution next few days. It is ugly now.
>>>>> You can just skip fe checking or something. See AF9015 for example.
>>>>>
>>>>>> Currently, it is implemented in identify_state on dvb_usb_v2.
>>>>>>
>>>>>> The get_usb_stream_config has no access to device to to allow a run-time
>>>>>> change there.
>>>>>
>>>>> Hmmm, what you try to say? As FE is given as a pointer, you have also
>>>>> adapter and device. Those are nested, device is root, then adapter is
>>>>> under that and finally frontend are under the adapter.
>>>>>
>>>>>
>>>>> .
>>>>> └── device
>>>>>        ├── adapter0
>>>>>        │   ├── frontend0
>>>>>        │   ├── frontend1
>>>>>        │   └── frontend2
>>>>>        └── adapter1
>>>>>            ├── frontend0
>>>>>            ├── frontend1
>>>>>            └── frontend2
>>>>>
>>>>>
>>>>> regards
>>>>> Antti
>>>>
>>>> static int lme2510_get_usb_stream_config(struct dvb_frontend *fe,
>>>> 		struct usb_data_stream_properties *stream)
>>>> {
>>>> 	struct dvb_usb_adapter *adap;
>>>> 	struct lme2510_state *state;
>>>>
>>>> 	stream->type = USB_BULK;
>>>> 	stream->count = 10;
>>>> 	stream->u.bulk.buffersize = 4096;
>>>>
>>>> // ugly part begins
>>>> 	if (fe == NULL)
>>>> 		return 0;
>>>> 	adap = fe->dvb->priv;
>>>> 	state = adap->dev->priv;
>>>> // ugly part ends
>>>>
>>>> 	if (state->chip_id == lme2510c)
>>>> 		stream->endpoint = 8;
>>>> 	else
>>>> 		stream->endpoint = 6;
>>>>
>>>> 	return 0;
>>>> }
>>>>
>>>> Ugly part between comments is what I am going to change, but currently
>>>> it works as is.
>>>>
>>> This doesn't work because the code will return the stream->endpoint
>>> unset and then try to initialise usb_urb_init.
>>
>> So what? It happens only once when device is initialized. We do not need
>> to know endpoint at that phase as we do not stream yet.
> Please read your code you submit the urbs.
>
> int dvb_usb_adapter_stream_init(struct dvb_usb_adapter *adap)
> {
> 	int ret;
> 	struct usb_data_stream_properties stream_props;
>
> 	adap->stream.udev = adap->dev->udev;
> 	adap->stream.user_priv = adap;
>
> 	/* resolve USB stream configuration for buffer alloc */
> 	if (adap->dev->props->get_usb_stream_config) {
> 		ret = adap->dev->props->get_usb_stream_config(NULL,
> 				&stream_props);
> 		if (ret < 0)
> 			return ret;
> 	} else {
> 		stream_props = adap->props->stream;
> 	}
>
> 	/* FIXME: can be removed as set later in anyway */
> 	adap->stream.complete = dvb_usb_data_complete;
>
> 	return usb_urb_init(&adap->stream, &stream_props); <<<<----here
> }

It is initializing stream here - not submitting URBs. Basically we 
allocate streaming buffers for later use.

URBs are submitted when streaming is started.

>>> It would be far better to have get_usb_stream_config point to adapter
>>> and point to adap->fe[adap->active_fe] inside if need be.
>>
>> Why?
> Again read your code. why do we need frontend ? ... we want adapter.
>
> Always pointing to same adapter regardless of frontend number.

We need to know frontend too! We *must* configure adapter stream 
according to frontend used. There is devices having multiple frontends 
which needs different streaming parameters.

Just to be short: we need frontend in order to configure adapter stream 
as there is multiple frontend in same adapter.

Maybe your device has only one frontend per adapter but I have devices 
having 1, 2 and 3 frontends.

> static int af9015_get_usb_stream_config(struct dvb_frontend *fe,
> 		struct usb_data_stream_properties *stream)
> {
> 	struct dvb_usb_adapter *adap;
>
> 	deb_info("%s: fe=%p\n", __func__, fe);
>
> 	stream->type = USB_BULK;
> 	stream->count = 8;
> 	stream->endpoint = 0x84;
> 	stream->u.bulk.buffersize = TS_USB20_FRAME_SIZE;
>
> 	if (fe == NULL)
> 		return 0;
>
> 	 adap = fe->dvb->priv; <<< always same adapter

Even when you have two adapters? If so there is a bug somewhere.

> 	if (adap->id == 1)
> 		stream->endpoint = 0x85;
>
> 	if (adap->dev->udev->speed == USB_SPEED_FULL)
> 		stream->u.bulk.buffersize = TS_USB11_FRAME_SIZE;
>
> 	return 0;
> }
>
>> As we are going to configure stream based _frontend_ current needs we
>> just need to know frontend and nothing more or less. If you pass adapter
>> as a parameter then you don't know what is frontend in question as
>> adapter coould have multiple frontends.
>>
>> active_fe member variable is meant to be internal use of DVB USB
>> framework. You should not use it from the driver. You can see active
>> frontend id just looking current frontend id (fe->id).
>>
>>> This is also the case with af9015, the code is extracting adapter
>>> through another module.
>>
>> I don't understand what you mean.
>>
>> Also I would like to ask if you test code I given at all?
> Yes, system crash. Endpoint not set.

Then there is a bug. I suspect it could be that synchronise issue 
between USB stream feed and frontend control. Locking is needed and it 
is on my TODO. There is old patch which adds validly checking to avoid that:
commit: 2d04c13a507f5a01daa7422cd52250809573cfdb

Test to return from dvb_usb_ctrl_feed() if active_fe == -1.

>> You seems not to understand that callback - get_usb_stream_config() - is
>> there for configuring stream dynamically.
> With get_usb_stream_config as;
>
> 	int (*get_usb_stream_config) (struct dvb_usb_adapter *,
> 			struct usb_data_stream_properties *);
>
>
> If we really need the frontend we do this.
>
> static int driverxxx_get_usb_stream_config(struct dvb_usb_adapter *adap,
> 		struct usb_data_stream_properties *stream)
> {
> 	struct dvb_frontend *fe = adap->fe[adap->active_fe];

I don't understand why you want to pass adapter and abuse 
adap->active_fe variable which is meant to internal use of DVB USB.

Here is skeleton example what I try to say for you:

That is what you want to do:
****************************
CALLBACK(struct dvb_usb_adapter *adap)
{
   struct dvb_frontend *fe = adap->fe[adap->active_fe];
   // now we have pointer to adap and fe
}

That is what I want to do:
**************************
CALLBACK(struct dvb_frontend *fe)
{
   struct dvb_usb_adapter *adap = fe->dvb->priv;
   // now we have pointer to adap and fe
}


regards
Antti
-- 
http://palosaari.fi/


