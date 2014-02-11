Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:57191 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBKUcu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 15:32:50 -0500
Received: by mail-wi0-f182.google.com with SMTP id f8so5296961wiw.3
        for <linux-media@vger.kernel.org>; Tue, 11 Feb 2014 12:32:49 -0800 (PST)
Message-ID: <1392150757.3378.14.camel@canaries32-MCP7A>
Subject: Re: [PATCH 2/2] af9035: Add remaining it913x dual ids to af9035.
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Antti Palosaari <crope@iki.fi>
Cc: linux-media@vger.kernel.org
Date: Tue, 11 Feb 2014 20:32:37 +0000
In-Reply-To: <52FA6113.300@iki.fi>
References: <1391951046.13992.15.camel@canaries32-MCP7A>
	 <52FA6113.300@iki.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2014-02-11 at 19:42 +0200, Antti Palosaari wrote:
> Moikka Malcolm!
> Thanks for the patch serie.
> 
> You removed all IDs from it913x driver. There is possibility to just 
> remove / comment out:
> 	MODULE_DEVICE_TABLE(usb, it913x_id_table);
> which prevents loading that driver automatically, but leaves possibility 
> to load it manually if user wants to fallback. I am fine either way you 
> decide to do it, just a propose.
Hi Antti

I am going post a patches to remove it.

The only reason why an user would want to fall back is
the use dvb-usb-it9137-01.fw firmware with USB_VID_KWORLD_2.

I left the USB_VID_KWORLD_2 ids in the driver.

I haven't found any issues with dvb-usb-it9135-01.fw

USB_VID_KWORLD_2 users could have trouble updating older kernels via
media_build.

Perhaps there should be a warning message in af9035 that users need to
change firmware.

Regards


Malcolm

