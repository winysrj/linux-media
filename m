Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756171Ab2EYScq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 14:32:46 -0400
Message-ID: <4FBFD041.9030306@redhat.com>
Date: Fri, 25 May 2012 15:32:33 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antti Palosaari <crope@iki.fi>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
References: <4FB95A3B.9070800@iki.fi> <4FB9BB75.9040703@redhat.com> <4FBFC4FD.50108@iki.fi>
In-Reply-To: <4FBFC4FD.50108@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 25-05-2012 14:44, Antti Palosaari escreveu:
> On 21.05.2012 06:50, Mauro Carvalho Chehab wrote:
>> Em 20-05-2012 17:55, Antti Palosaari escreveu:
>>> I did some more planning and made alternative RFC.
>>> As the earlier alternative was more like changing old functionality that new one goes much more deeper.
>>>
>>> As a basic rule I designed it to reduce stuff from the current struct dvb_usb_device_properties. Currently there is many nested structs introducing same callbacks. For that one I dropped all frontend and adapter level callbacks to device level. Currently struct contains 2 adapters and 3 frontends - which means we have 2 * 3 = 6 "similar" callbacks and only 1 is used. It wastes some space since devices having more than one adapter or frontend are rather rare. Making callback selection inside individual driver is very trivial even without a designated callback. Here is common example from the use of .frontend_attach() callback in case of only one callback used:
>>> static int frontend_attach(struct dvb_usb_adapter *adap)
>>> {
>>>    if (adap->id == 0)
>>>      return frontend_attach_1();
>>>    else
>>>      return frontend_attach_2();
>>> }
>>>
>>> Functionality enhancement mentioned earlier RFC are valid too:
>>> http://www.mail-archive.com/linux-media@vger.kernel.org/msg46352.html
>>>
>>> As I was a little bit lazy I wrote only quick skeleton code to represent new simplified "struct dvb_usb_device_properties":
>>>
>>> struct dvb_usb_device_properties = {
>>>    /* download_firmware() success return values to signal what happens next */
>>>    #define RECONNECTS_USB                  (1<<  0)
>>>    #define RECONNECTS_USB_USING_NEW_ID     (1<<  1)
>>>
>>>   .size_of_priv = sizeof(struct 'state'),
>>>
>>>    /* firmware download */
>>>    .identify_state(struct dvb_usb_device *d, int *cold),
>>>    .get_firmware_name(struct dvb_usb_device *d, char *firmware_name),
>>>    .download_firmware(struct dvb_usb_device *d, const struct firmware *fw),
>>>    .allow_dynamic_id = true,
>>>
>>>    .power_ctrl(struct dvb_usb_device *d, int onoff),
>>>    .read_config(struct dvb_usb_device *d, u8 mac[6]),
>>>    .get_adapter_count(struct dvb_usb_device *d, int *count),
>>>
>>>    .frontend_attach(struct dvb_usb_adapter *adap),
>>>    .tuner_attach(struct dvb_usb_adapter *adap),
>>>
>>>    .init(struct dvb_usb_device *d),
>>>
>>>    .get_rc(struct dvb_rc *),
>>>    .i2c_algo = (struct i2c_algorithm),
>>>
>>>    .frontend_ctrl(struct dvb_frontend *fe, int onoff),
>>>    .get_stream_props(struct usb_data_stream_properties *),
>>>    .streaming_ctrl(struct dvb_usb_adapter *adap, int onoff),
>>>
>>>    .generic_bulk_ctrl_endpoint = (int),
>>>    .generic_bulk_ctrl_endpoint_response = (int),
>>>
>>>    .devices = (struct dvb_usb_device)[],
>>> };
>>>
>>> struct dvb_usb_device dvb_usb_devices {
>>>    char *name = "name",
>>>    .rc_map = RC_MAP_EMPTY,
>>>    .device_id = (struct usb_device_id),
>>> }
>>
>> It looks OK to me. It may make sense to add an optional
>> per-device field, to allow drivers to add more board-specific
>> information, if they need, in order to avoid duplicating
>> things there.
>>
>> Another option would be for the drivers to do:
>>
>> struct dvb_usb_drive_foo dvb_usb_driver_foo {
>>     struct dvb_usb_device dvb_usb_devices dvb_usb_dev;
>>     int foo;
>>     long bar;
>>     ...
>> }
>>
>> And, inside the core, use the container_of() macro to go from
>> the device-specific table to struct dvb_usb_device.
>>
>> This way, simple drivers can do just:
>>
>> struct dvb_usb_drive_foo dvb_usb_driver_foo {
>>     struct dvb_usb_device dvb_usb_devices dvb_usb_dev;
>> }
>>
>> And complex drivers can add more stuff there.
> 
> I have now implemented some basic stuff. Most interesting is new way of map device id and properties for it. I found that I can use .driver_info field from the (struct usb_device_id) to carry pointer. I used it to carry all the other data to the DVB USB core. Thus that one big issue is now resolved. It reduces something like 8-9 kB of binary size which is huge improvement. Same will happen for every driver using multiple (struct dvb_usb_device_properties) - for more you are used more you save.
> 
> Here is 3 example drivers I have converted to that new style:
> http://palosaari.fi/linux/v4l-dvb/dvb-usb-2012-05-25/

It will be better if you inline a diff at the email, instead of pointing 
to the changed files.

Also, instead of doing:

static struct usb_device_id af9015_usb_table[] = {
	{ USB_DEVICE(USB_VID_AFATECH, USB_PID_AFATECH_AF9015_9015),
		.driver_info = (kernel_ulong_t) &((struct dvb_usb_driver_info) {
			.name = "Afatech AF9015 reference design",
			.props = &af9015_properties })},

I suggest you to add a macro for it, converting the above to something similar to:

	DVB_USB_DRIVER_INFO("Afatech AF9015 reference design", &af9015_properties),

or, even better, to:

	DVB_USB_DEVICE(USB_VID_AFATECH,
		       USB_PID_AFATECH_AF9015_9015,
		       "Afatech AF9015 reference design", 
		       &af9015_properties),

Btw, I still think that you should move things like RC type to be stored outside
the properties struct.

Regards,
Mauro
