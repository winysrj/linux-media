Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:45692 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab2ETUz2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 16:55:28 -0400
Message-ID: <4FB95A3B.9070800@iki.fi>
Date: Sun, 20 May 2012 23:55:23 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
CC: Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [RFCv1] DVB-USB improvements [alternative 2]
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I did some more planning and made alternative RFC.
As the earlier alternative was more like changing old functionality that 
new one goes much more deeper.

As a basic rule I designed it to reduce stuff from the current struct 
dvb_usb_device_properties. Currently there is many nested structs 
introducing same callbacks. For that one I dropped all frontend and 
adapter level callbacks to device level. Currently struct contains 2 
adapters and 3 frontends - which means we have 2 * 3 = 6 "similar" 
callbacks and only 1 is used. It wastes some space since devices having 
more than one adapter or frontend are rather rare. Making callback 
selection inside individual driver is very trivial even without a 
designated callback. Here is common example from the use of 
.frontend_attach() callback in case of only one callback used:
static int frontend_attach(struct dvb_usb_adapter *adap)
{
   if (adap->id == 0)
     return frontend_attach_1();
   else
     return frontend_attach_2();
}

Functionality enhancement mentioned earlier RFC are valid too:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg46352.html

As I was a little bit lazy I wrote only quick skeleton code to represent 
new simplified "struct dvb_usb_device_properties":

struct dvb_usb_device_properties = {
   /* download_firmware() success return values to signal what happens 
next */
   #define RECONNECTS_USB                  (1 << 0)
   #define RECONNECTS_USB_USING_NEW_ID     (1 << 1)

  .size_of_priv = sizeof(struct 'state'),

   /* firmware download */
   .identify_state(struct dvb_usb_device *d, int *cold),
   .get_firmware_name(struct dvb_usb_device *d, char *firmware_name),
   .download_firmware(struct dvb_usb_device *d, const struct firmware *fw),
   .allow_dynamic_id = true,

   .power_ctrl(struct dvb_usb_device *d, int onoff),
   .read_config(struct dvb_usb_device *d, u8 mac[6]),
   .get_adapter_count(struct dvb_usb_device *d, int *count),

   .frontend_attach(struct dvb_usb_adapter *adap),
   .tuner_attach(struct dvb_usb_adapter *adap),

   .init(struct dvb_usb_device *d),

   .get_rc(struct dvb_rc *),
   .i2c_algo = (struct i2c_algorithm),

   .frontend_ctrl(struct dvb_frontend *fe, int onoff),
   .get_stream_props(struct usb_data_stream_properties *),
   .streaming_ctrl(struct dvb_usb_adapter *adap, int onoff),

   .generic_bulk_ctrl_endpoint = (int),
   .generic_bulk_ctrl_endpoint_response = (int),

   .devices = (struct dvb_usb_device)[],
};

struct dvb_usb_device dvb_usb_devices {
   char *name = "name",
   .rc_map = RC_MAP_EMPTY,
   .device_id = (struct usb_device_id),
}


It is likely Wednesday I am going to start implementing that one unless 
some big issues are raised. Making simple test code as a 
proof-of-concept  should not be very many days of work.

regards
Antti
-- 
http://palosaari.fi/
