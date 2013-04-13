Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60771 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160Ab3DMNQX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 13 Apr 2013 09:16:23 -0400
Message-ID: <51695A7B.4010206@iki.fi>
Date: Sat, 13 Apr 2013 16:15:39 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: =?UTF-8?B?RnJhbmsgU2Now6RmZXI=?= <fschaefer.oss@googlemail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 0/3] em28xx: clean up end extend the GPIO port handling
References: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
In-Reply-To: <1365846521-3127-1-git-send-email-fschaefer.oss@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/13/2013 12:48 PM, Frank Schäfer wrote:
> Patch 1 removes the unneeded and broken gpio register caching code.
> Patch 2 adds the gpio register defintions for the em25xx/em276x/7x/8x
> and patch 3 finally adds a new helper function for gpio ports with separate
> registers for read and write access.


I have nothing to say directly about those patches - they looked good at 
the quick check. But I wonder if you have any idea if it is possible to 
use some existing Kernel GPIO functionality in order to provide standard 
interface (interface like I2C). I did some work last summer in order to 
use GPIOLIB and it is used between em28xx-dvb and cxd2820r for LNA 
control. Anyhow, I was a little bit disappointed as GPIOLIB is disabled 
by default and due to that there is macros to disable LNA when GPIOLIB 
is not compiled.
I noticed recently there is some ongoing development for Kernel GPIO. I 
haven't looked yet if it makes use of GPIO interface more common...

regards
Antti

-- 
http://palosaari.fi/
