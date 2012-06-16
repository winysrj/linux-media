Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60953 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2FPURO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jun 2012 16:17:14 -0400
Received: by wibhj8 with SMTP id hj8so689760wib.1
        for <linux-media@vger.kernel.org>; Sat, 16 Jun 2012 13:17:13 -0700 (PDT)
Message-ID: <1339877826.2697.4.camel@Route3278>
Subject: Re: dvb_usb_v2: use pointers to properties[REGRESSION]
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media <linux-media@vger.kernel.org>
Date: Sat, 16 Jun 2012 21:17:06 +0100
In-Reply-To: <4FDCD35D.6020808@iki.fi>
References: <1339798273.12274.21.camel@Route3278> <4FDBBD36.9020302@iki.fi>
	   <1339806912.13364.35.camel@Route3278> <4FDBD966.2030505@iki.fi>
	   <4FDBDE70.1080302@iki.fi> <1339848379.2439.18.camel@Route3278>
	  <4FDCABDA.2000000@iki.fi> <1339870370.1865.37.camel@Route3278>
	 <4FDCD35D.6020808@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 2012-06-16 at 21:41 +0300, Antti Palosaari wrote:

> 
> That is what you want to do:
> ****************************
> CALLBACK(struct dvb_usb_adapter *adap)
> {
>    struct dvb_frontend *fe = adap->fe[adap->active_fe];
>    // now we have pointer to adap and fe
> }
> 
> That is what I want to do:
> **************************
> CALLBACK(struct dvb_frontend *fe)
> {
>    struct dvb_usb_adapter *adap = fe->dvb->priv;
>    // now we have pointer to adap and fe
> }
I just don't like the idea of deliberately sending a NULL object to
a callback.


Ha ... I know what is causing the crash....its in usb_urb.c


int usb_urb_init(struct usb_data_stream *stream,
		struct usb_data_stream_properties *props)
{
	int ret;

	if (stream == NULL || props == NULL)
		return -EINVAL;

	memcpy(&stream->props, props, sizeof(*props));

	usb_clear_halt(stream->udev, usb_rcvbulkpipe(stream->udev,
			stream->props.endpoint));

The usb_clear_halt with 0 endpoint.

It can tweaked by sending a valid endpoint.


Regards


Malcolm





