Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:54924 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbZDSUGN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Apr 2009 16:06:13 -0400
Message-ID: <49EB8431.70202@iki.fi>
Date: Sun, 19 Apr 2009 23:06:09 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Armin Schenker <sar@snafu.de>
Subject: Re: Add Elgato EyeTV DTT deluxe to dibcom driver
References: <E63C5667-D18B-4D13-9D88-15293E1B12B2@snafu.de>
In-Reply-To: <E63C5667-D18B-4D13-9D88-15293E1B12B2@snafu.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Armin Schenker kirjoitti:
> -        .num_device_descs = 11,
> +        .num_device_descs = 12,

> -    struct dvb_usb_device_description devices[11];
> +    struct dvb_usb_device_description devices[12];

I don't comment about this patch but general.

I didn't realized this value is allowed to increase when adding new 
devices. Due to that there is now three dvb_usb_device_properties in 
af9015 which makes driver a little bit complex.

What we should do? Can I remove code from af9015 and increase 
dvb_usb_device_description count to about 30? What is biggest suitable 
value we want use, how much memory one entry will take.

regards
Antti
-- 
http://palosaari.fi/
