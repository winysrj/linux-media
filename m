Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:61694 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbZCENCX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Mar 2009 08:02:23 -0500
Message-ID: <49AFCD5B.4050100@kaiser-linux.li>
Date: Thu, 05 Mar 2009 14:02:19 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: kilgota@banach.math.auburn.edu
CC: Kyle Guinn <elyk03@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: RFC on proposed patches to mr97310a.c for gspca and v4l
References: <20090217200928.1ae74819@free.fr> <200902171907.40054.elyk03@gmail.com> <alpine.LNX.2.00.0903031746030.21483@banach.math.auburn.edu> <200903032050.13915.elyk03@gmail.com> <alpine.LNX.2.00.0903032247530.21793@banach.math.auburn.edu> <49AE3EA1.3090504@kaiser-linux.li> <49AE41DE.1000300@kaiser-linux.li> <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu>
In-Reply-To: <alpine.LNX.2.00.0903041248020.22500@banach.math.auburn.edu>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Theodore

kilgota@banach.math.auburn.edu wrote:
> 
> 
> On Wed, 4 Mar 2009, Thomas Kaiser wrote:
> As to the actual contents of the header, as you describe things,
> 
> 0. Do you have any idea how to account for the discrepancy between
> 
>>>  From usb snoop.
>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx 00 00
> and
>>> In Linux the header looks like this:
>>>
>>> FF FF 00 FF 96 64 xx 00 xx xx xx xx xx xx F0 00
> 
> (I am referring to the 00 00 as opposed to F0 00)? Or could this have 
> happened somehow just because these were not two identical sessions?

Doesn't remember what the differences was. The first is from Windoz 
(usbsnoop) and the second is from Linux.

> 
>>> 1. xx: don't know but value is changing between 0x00 to 0x07
> 
> as I said, this signifies the image format, qua compression algorithm in 
> use, or if 00 then no compression.

On the PAC207, the compression can be controlled with a register called 
"Compression Balance size". So, I guess, depending on the value set in 
the register this value in the header will show what compression level 
is set.

> 
>>> 2. xx: this is the actual pixel clock
> 
> So there is a control setting for this?

Yes, in the PAC207, register 2. (12 MHz divided by the value set).

> 
>>> 3. xx: this is changing according light conditions from 0x03 (dark) to
>>> 0xfc (bright) (center)
>>> 4. xx: this is changing according light conditions from 0x03 (dark) to
>>> 0xfc (bright) (edge)
>>> 5. xx: set value "Digital Gain of Red"
>>> 6. xx: set value "Digital Gain of Green"
>>> 7. xx: set value "Digital Gain of Blue"
> 
> Does anyone have any idea of how actually to use this information/ for 
> example, since a lot of cameras are reporting some kind of similar 
> looking information, does anyone know if there are any kinds of standard 
> scales for these entries? Just what are they supposed to signify, and 
> how exactly is one supposed to use such values, if they have been 
> presented? When I say "a lot of cameras," understand, I mean still 
> cameras as well as webcams, and cameras with a lot of different chipsets 
> in them, too. So this is a question whether there is any standard system 
> for the presentation of such data, and how it might constructively be 
> used in image processing. I have had questions about this kind of thing 
> for a long time, and I do not know where to look for the answers.

For the brightness, I guess, 0 means dark and 0xff completely bright 
(sensor is in saturation)?

Thomas

