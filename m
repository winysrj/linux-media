Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52194 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2HPMTF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 08:19:05 -0400
Received: by lbbgj3 with SMTP id gj3so1437653lbb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Aug 2012 05:19:03 -0700 (PDT)
Message-ID: <502CE527.2070006@iki.fi>
Date: Thu, 16 Aug 2012 15:18:47 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: dvb-usb-v2 change broke s2250-loader compilation
References: <201208161233.43618.hverkuil@xs4all.nl>
In-Reply-To: <201208161233.43618.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2012 01:33 PM, Hans Verkuil wrote:
> Building the kernel with the Sensoray 2250/2251 staging go7007 driver enabled
> fails with this link error:
>
> ERROR: "usb_cypress_load_firmware" [drivers/staging/media/go7007/s2250-loader.ko] undefined!
>
> As far as I can tell this is related to the dvb-usb-v2 changes.
>
> Can someone take a look at this?
>
> Thanks!
>
> 	Hans

Yes it is dvb usb v2 related. I wasn't even aware that someone took that 
module use in few days after it was added for the dvb-usb-v2.

Maybe it is worth to make it even more common and move out of dvb-usb-v2...

regards
Antti


-- 
http://palosaari.fi/
