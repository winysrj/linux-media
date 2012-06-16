Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35891 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2FPMG1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 08:06:27 -0400
Received: by eeit10 with SMTP id t10so1161777eei.19
        for <linux-media@vger.kernel.org>; Sat, 16 Jun 2012 05:06:26 -0700 (PDT)
Message-ID: <1339848379.2439.18.camel@Route3278>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sat, 16 Jun 2012 13:06:19 +0100
In-Reply-To: <4FDBDE70.1080302@iki.fi>
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi>
	 <1339806912.13364.35.camel@Route3278> <4FDBD966.2030505@iki.fi>
	 <4FDBDE70.1080302@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-06-16 at 04:16 +0300, Antti Palosaari wrote:
> I did example for you, here you are :)
> 
> On 06/16/2012 03:55 AM, Antti Palosaari wrote:
> > On 06/16/2012 03:35 AM, Malcolm Priestley wrote:
> >> On Sat, 2012-06-16 at 01:54 +0300, Antti Palosaari wrote:
> >>> Hello Malcolm,
> >>>
> >>> On 06/16/2012 01:11 AM, Malcolm Priestley wrote:
> >>>> Hi Antti
> >>>>
> >>>> You can't have dvb_usb_device_properties as constant structure pointer.
> >>>>
> >>>> At run time it needs to be copied to a private area.
> >>>
> >>> Having constant structure for properties was one of main idea of whole
> >>> change. Earlier it causes some problems when driver changes those values
> >>> - for example remote configuration based info from the eeprom.
> >>>
> >>>> Two or more devices of the same type on the system will be pointing to
> >>>> the same structure.
> >>>
> >>> Yes and no. You can define struct dvb_usb_device_properties for each
> >>> USB ID.
> >>>
> >>>> Any changes they make to the structure will be common to all.
> >>>
> >>> For those devices having same USB ID only.
> >>> Changing dvb_usb_device_properties is *not* allowed. It is constant and
> >>> should be. That was how I designed it. Due to that I introduced those
> >>> new callbacks to resolve needed values dynamically.
> >> Yes, but it does make run-time tweaks difficult.
> >>
> >>> If there is still something that is needed to resolve at runtime I am
> >>> happy to add new callback. For example PID filter configuration is
> >>> static currently as per adapter and if it is needed to to reconfigure at
> >>> runtime new callback is needed.
> >> I will look at the PID filter later, it defaulted to off.
> >>
> >> However, in my builds for ARM devices it is defaulted on. I will be
> >> testing this later. I can't see any problems.
> >>
> >>>
> >>> Could you say what is your problem I can likely say how to resolve it.
> >>>
> >>
> >> Well, the problem is, I now need two separate structures for LME2510 and
> >> LME2510C as in the existing driver, the hope was to merge them as one.
> >> The only difference being the stream endpoint number.
> >
> > Then you should use .get_usb_stream_config() instead of static stream
> > configuration. That is now supported.
> >
> > I have found one logical error in my current implementation.
> > get_usb_stream_config gets frontend as a parameter, but it is called
> > frontend == NULL when attaching adapters and after that frontend is real
> > value when called (just before streaming is started). Now what happens
> > if we has multiple adapters? We cannot know which adapter is requested
> > during attach since FE is NULL :)
> > But that is problem case only if you have multiple adapters. I will find
> > out better solution next few days. It is ugly now.
> > You can just skip fe checking or something. See AF9015 for example.
> >
> >> Currently, it is implemented in identify_state on dvb_usb_v2.
> >>
> >> The get_usb_stream_config has no access to device to to allow a run-time
> >> change there.
> >
> > Hmmm, what you try to say? As FE is given as a pointer, you have also
> > adapter and device. Those are nested, device is root, then adapter is
> > under that and finally frontend are under the adapter.
> >
> >
> > .
> > └── device
> >      ├── adapter0
> >      │   ├── frontend0
> >      │   ├── frontend1
> >      │   └── frontend2
> >      └── adapter1
> >          ├── frontend0
> >          ├── frontend1
> >          └── frontend2
> >
> >
> > regards
> > Antti
> 
> static int lme2510_get_usb_stream_config(struct dvb_frontend *fe,
> 		struct usb_data_stream_properties *stream)
> {
> 	struct dvb_usb_adapter *adap;
> 	struct lme2510_state *state;
> 
> 	stream->type = USB_BULK;
> 	stream->count = 10;
> 	stream->u.bulk.buffersize = 4096;
> 
> // ugly part begins
> 	if (fe == NULL)
> 		return 0;
> 	adap = fe->dvb->priv;
> 	state = adap->dev->priv;
> // ugly part ends
> 
> 	if (state->chip_id == lme2510c)
> 		stream->endpoint = 8;
> 	else
> 		stream->endpoint = 6;
> 
> 	return 0;
> }
> 
> Ugly part between comments is what I am going to change, but currently 
> it works as is.
> 
This doesn't work because the code will return the stream->endpoint
unset and then try to initialise usb_urb_init.

It would be far better to have get_usb_stream_config point to adapter
and point to adap->fe[adap->active_fe] inside if need be.

This is also the case with af9015, the code is extracting adapter
through another module.

Regards


Malcolm




