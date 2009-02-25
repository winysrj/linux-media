Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:36192 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757645AbZBYUXz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Feb 2009 15:23:55 -0500
Message-ID: <49A5A8D7.60109@iki.fi>
Date: Wed, 25 Feb 2009 22:23:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: schollsky@arcor.de
CC: linux-media@vger.kernel.org
Subject: Re: Old firmware - again af9013 4.65.0 ?!?
References: <10076348.1235591599750.JavaMail.ngmail@webmail09.arcor-online.net>
In-Reply-To: <10076348.1235591599750.JavaMail.ngmail@webmail09.arcor-online.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

schollsky@arcor.de wrote:
> af9013: firmware version:4.65.0
> usbcore: registered new interface driver dvb_usb_af9015
> 
> This is the same when installing no firmware, or installing the file from
> 
> http://www.otit.fi/~crope/v4l-dvb/af9015/af9015_firmware_cutter/firmware_files/4.95.0/
> 
> into /lib/firmware, which should load 4.95.0 firmware. 
> 
> What's going wrong?

It (firmware 4.65.0) must be somewhere where it is downloaded to the device.
Does it say it is loading fw from file?

firmware: requesting dvb-usb-af9015.fw
dvb-usb: downloading firmware from file 'dvb-usb-af9015.fw'

Run "updatedb" as root and then search where it is lurking by
"locate dvb-usb-af9015.fw". And remember also replug stick, take account 
that without re-plug it could be even downloaded by old windoze driver.

regards
Antti
-- 
http://palosaari.fi/
