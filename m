Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34957 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055Ab2HFMLe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 6 Aug 2012 08:11:34 -0400
Message-ID: <501FB469.1020009@iki.fi>
Date: Mon, 06 Aug 2012 15:11:21 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Malcolm Priestley <tvboxspy@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] lmedm04 v2.05 conversion to dvb-usb-v2
References: <1344175824.18047.7.camel@router7789> <501E84D6.1040402@redhat.com>
In-Reply-To: <501E84D6.1040402@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/05/2012 05:36 PM, Mauro Carvalho Chehab wrote:
> Em 05-08-2012 11:10, Malcolm Priestley escreveu:
>> Conversion of lmedm04 to dvb-usb-v2

You were faster than I :) Thanks!

http://blog.palosaari.fi/2012/08/naked-hardware-1-dm04-usb-20-satellite.html


>> functional changes are that callbacks have been moved to fe_ioctl_override.
>
> Don't do that: fe_ioctl_override has a broken design and only handles DVBv3
> ioctl's. So, if userspace is using DVBv5, this will cause a regression.
>
> Antti,
>
> IMO, the best thing to do is to either remove fe_ioctl_override or to print
> a warning when a driver calls it, in order to warn developers that they're
> using a legacy callback that could cause the driver to not work properly.

I agree that.

regards
Antti


-- 
http://palosaari.fi/
