Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:52951 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797Ab0AXXob (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Jan 2010 18:44:31 -0500
Message-ID: <4B5CDB53.6030009@iki.fi>
Date: Mon, 25 Jan 2010 01:44:19 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: mchehab@infradead.org, linux-kernel@vger.kernel.org,
	jirislaby@gmail.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media: dvb-usb/af9015, fix disconnection crashes
References: <1264007972-6261-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1264007972-6261-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/20/2010 07:19 PM, Jiri Slaby wrote:
> When both remote controller and receiver intfs are handled by
> af9015, .probe do nothing for remote intf, but when .disconnect
> is called for both of them it touches intfdata every time. For
> remote it crashes obviously (as intfdata are unset).
>
> Altough there is test against data being NULL, it is not enough.
> It is because someone before us does not set intf drvdata to
> NULL. (In this case the hid layer.) But we cannot rely on intf
> being NULL anyway.
>
> Fix that by checking bInterfaceNumber in af9015_usb_device_exit
> and do actually nothing if it is not 0.

I was a little bit surprised when saw this error, why it haven't 
detected earlier. When I initially added interface check for .probe it 
was surely needed, it was creating two instances without that check in 
that time. When I now test this patch with debugs enabled I don't see 
.probe and .disconnect be called for this HID interface (interface 1) at 
all and thus checks not needed. I have Fedora Kernel 2.6.31.12 running 
with latest v4l-dvb. Is there now some kind of check added recently 
which blocks .probe and disconnect from HID interface?

regards
Antti
-- 
http://palosaari.fi/
