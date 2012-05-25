Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48259 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab2EYRsw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 13:48:52 -0400
Message-ID: <4FBFC602.2060806@iki.fi>
Date: Fri, 25 May 2012 20:48:50 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>,
	Patrick Boettcher <pboettcher@kernellabs.com>
Subject: Re: [RFCv1] DVB-USB improvements [alternative 2]
References: <4FB95A3B.9070800@iki.fi> <4FB9BB75.9040703@redhat.com> <4FBFC4FD.50108@iki.fi>
In-Reply-To: <4FBFC4FD.50108@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25.05.2012 20:44, Antti Palosaari wrote:
> I have now implemented some basic stuff. Most interesting is new way of
> map device id and properties for it. I found that I can use .driver_info
> field from the (struct usb_device_id) to carry pointer. I used it to
> carry all the other data to the DVB USB core. Thus that one big issue is
> now resolved. It reduces something like 8-9 kB of binary size which is
> huge improvement. Same will happen for every driver using multiple
> (struct dvb_usb_device_properties) - for more you are used more you save.

Argh, reduces 8-9kB from the *af9015* as it was defining three (struct 
dvb_usb_device_properties). Also line count reduces 350 lines and will 
reduce some more after all those planned callbacks are done.

> Here is 3 example drivers I have converted to that new style:
> http://palosaari.fi/linux/v4l-dvb/dvb-usb-2012-05-25/

Antti
-- 
http://palosaari.fi/
