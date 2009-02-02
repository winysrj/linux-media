Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:31461 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287AbZBBUHT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Feb 2009 15:07:19 -0500
Message-ID: <49875273.6060902@iki.fi>
Date: Mon, 02 Feb 2009 22:07:15 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Lindsay Mathieson <lindsay.mathieson@gmail.com>
CC: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: TinyTwin (af9015) - tuner 0 not working
References: <49864b5b.104.2583.763472724@blackpaw.dyndns.org>
In-Reply-To: <49864b5b.104.2583.763472724@blackpaw.dyndns.org>
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lindsay Mathieson wrote:
> I've had a DigitalNow TinyTwin dual usb tuner working on my
> mythbox for a week now (latest v4l-dvb trunk).
> 
> A odd problem with the tuner has surfaced. Today Tuner 0
> stopped getting a lock on any channel. Signal strength is
> 95%+, Bit Errors are Zero.
> 
> However Tuner 1 is locking on and displaying channels just
> fine. Tuner 0 used to work fine. I've rebooted, but the
> problem hasn't gone away.
> 
> Any suggestions?

Have you tried replug stick? Hopefully it does not have burned.
Could you test whether this driver works:
http://linuxtv.org/hg/~anttip/af9015-mxl500x/
It uses different tuner driver.

regards
Antti
-- 
http://palosaari.fi/
