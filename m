Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:48522 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755823Ab2FYVIw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jun 2012 17:08:52 -0400
Message-ID: <4FE8D35E.7080802@iki.fi>
Date: Tue, 26 Jun 2012 00:08:46 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: cedric.dewijs@telfort.nl
CC: mchehab@infradead.org, linux-media@vger.kernel.org
Subject: Re: DiB0700 rc submit urb failed after reboot, ok after replug
References: <4FC4F2380000A8A7@mta-nl-6.mail.tiscali.sys>
In-Reply-To: <4FC4F2380000A8A7@mta-nl-6.mail.tiscali.sys>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/23/2012 10:43 AM, cedric.dewijs@telfort.nl wrote:
> [    6.517631] rc0: IR-receiver inside an USB DVB receiver as /devices/pci0000:00/0000:00:1d.7/usb2/2-4/rc/rc0
> [    6.517821] dvb-usb: schedule remote query interval to 50 msecs.
> [    6.517825] dvb-usb: Pinnacle PCTV 73e SE successfully initialized and
> connected.
> [    6.517951] dib0700: rc submit urb failed

I am almost sure it is that issue I fixed:

http://git.linuxtv.org/anttip/media_tree.git/commit/36bd9e4ba1de78bfb9f3bcf8b07c63a157da6499


Antti

-- 
http://palosaari.fi/


