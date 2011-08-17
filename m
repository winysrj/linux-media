Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43144 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753730Ab1HQUgF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Aug 2011 16:36:05 -0400
Message-ID: <4E4C2631.6010405@iki.fi>
Date: Wed, 17 Aug 2011 23:36:01 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Josu Lazkano <josu.lazkano@gmail.com>
CC: Jose Alberto Reguero <jareguero@telefonica.net>,
	linux-media@vger.kernel.org
Subject: Re: Afatech AF9013
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com> <201108162227.00963.jareguero@telefonica.net> <4E4AD9B4.2040908@iki.fi> <201108170123.09647.jareguero@telefonica.net> <CAL9G6WW3Atz9Vj7xoWqrYQKKAsLL1Q9Hj+v6FYxYE5dqdPRjFQ@mail.gmail.com>
In-Reply-To: <CAL9G6WW3Atz9Vj7xoWqrYQKKAsLL1Q9Hj+v6FYxYE5dqdPRjFQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/17/2011 10:36 AM, Josu Lazkano wrote:
> I don't know how wide is the stream, but it could be a USB wide
> limitation. My board is a little ION based and I have some USB
> devices:
> $ lsusb
> Bus 001 Device 002: ID 1b80:e399 Afatech
> Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

I don't think so. Total under 50Mbit/sec stream should not be too much
for one USB2.0 root hub.

Which is chipset used ION (it is southbridge which contains usually USB
ports)?

> The problematic twin device is the "Afatech" one, there is an DVB-S2
> USB tuner, a bluetooth dongle, a IR receiver and a wireless
> mouse/keybord receiver.
> 
> Now I am at work, I will try to disconnect all devices and try with
> just the DVB-T device.
> 
> I use to try with MythTV if it works or not. Is there any other tool
> to test and debug more deep about USB or DVB wide?

You can look stream sizes using dvbtraffic tool. It is last line of
output which shows total stream size.

tzap can be used to tune channel. But it you can use some other app like
MythTV and then run dvbtraffic same time.

> I apreciate your help. Thanks and best regards.

regards
Antti

-- 
http://palosaari.fi/
