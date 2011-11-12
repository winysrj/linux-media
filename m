Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48990 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab1KLQZx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 12 Nov 2011 11:25:53 -0500
Message-ID: <4EBE9E0F.3060707@iki.fi>
Date: Sat, 12 Nov 2011 18:25:51 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 3/7] af9015/af9013 full pid filtering
References: <4ebe96f4.6359b40a.5cac.3970@mx.google.com>
In-Reply-To: <4ebe96f4.6359b40a.5cac.3970@mx.google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/12/2011 05:55 PM, Malcolm Priestley wrote:
> Allowing the pid to be enabled seems to suppress corrupted stream packets
> from the first frontend.  This is mainly caused by other high speed devices
> on the usb bus.
>
> Full pid filtering on all frontends.
> no_pid is defaulted to on.
> TS frame size it limited to 21, this because if we are only filtering
> pid 0000, it takes too long to fill up the buffer when tuning or
> scanning.

Could you explain that?
PID filter should not be used unless there is no USB1.1 or it is forced 
using DVB USB module param. PID filter is controlled by DVB USB.

Logic about PID-filtering was done way that it disables 2nd FE when 
USB1.1 is used since I did not see way to set PID filtering for FE1 and 
without filtering stream is too wide for USB1.1.

Does that patch force PID filter always on or what?


Antti

-- 
http://palosaari.fi/
