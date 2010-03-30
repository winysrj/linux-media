Return-path: <linux-media-owner@vger.kernel.org>
Received: from xenotime.net ([72.52.64.118]:58657 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754194Ab0C3SQp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Mar 2010 14:16:45 -0400
Received: from chimera.site ([71.245.98.113]) by xenotime.net for <linux-media@vger.kernel.org>; Tue, 30 Mar 2010 11:16:44 -0700
Message-ID: <4BB2400C.3060509@xenotime.net>
Date: Tue, 30 Mar 2010 11:16:44 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
MIME-Version: 1.0
To: Ricardo Maraschini <xrmarsx@gmail.com>
CC: linux-media@vger.kernel.org, dougsland@gmail.com,
	mchehab@infradead.org
Subject: Re: [PATCH] dib7000p.c: Fix for warning: the frame size of 1236 bytes
 is larger than 1024 bytes
References: <4BB23CB0.1080501@gmail.com>
In-Reply-To: <4BB23CB0.1080501@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/10 11:02, Ricardo Maraschini wrote:
> When compiling the last version of v4l-dvb tree I got the following message:
> 
> /data/Projects/kernel/v4l-dvb/v4l/dib7000p.c: In function 'dib7000p_i2c_enumeration':
> /data/Projects/kernel/v4l-dvb/v4l/dib7000p.c:1393: warning: the frame size of 1236 bytes is larger than 1024 bytes
> 
> I believe that this problem is related to stack size, because we are allocating memory for a big structure.
> I changed the approach to dinamic allocated memory and the warning disappears.
> The same problem appears on dib3000 as well, and I can fix that too if this patch get in.
> 
> Any comment on that?
> I'll appreciate to read any comment from more experienced code makers.


Hi,

There is one caller of dib7000p_i2c_enumeration() that does not check its
return value/error code.  See
drivers/media/dvb/dvb-usb/cxusb.c::cxusb_dualdig4_rev2_frontend_attach():

	dib7000p_i2c_enumeration(&adap->dev->i2c_adap, 1, 18,
				 &cxusb_dualdig4_rev2_config);


That is in my (similar) patch and I also posted a dib3000 patch.
Yes, it would be good if someone could review & merge them.

https://patchwork.kernel.org/patch/77891/
https://patchwork.kernel.org/patch/77892/

-- 
~Randy
