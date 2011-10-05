Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:51400 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658Ab1JEF6z (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 5 Oct 2011 01:58:55 -0400
Message-ID: <4E8BF21B.4010907@iki.fi>
Date: Wed, 05 Oct 2011 08:58:51 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-serial@vger.kernel.org, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org,
	=?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
	James Courtier-Dutton <james.dutton@gmail.com>,
	HoP <jpetrous@gmail.com>,
	=?ISO-8859-1?Q?Istv=E1n_V=E1radi?= <ivaradi@gmail.com>
Subject: Re: serial device name for smart card reader that is integrated to
 Anysee DVB USB device
References: <4E8B7901.2050700@iki.fi> <20111005045917.GB4700@kroah.com>
In-Reply-To: <20111005045917.GB4700@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/05/2011 07:59 AM, Greg KH wrote:
> On Wed, Oct 05, 2011 at 12:22:09AM +0300, Antti Palosaari wrote:
>> I have been looking for correct device name for serial smart card
>> reader that is integrated to Anysee DVB USB devices. Consider it
>> like old so called Phoenix reader. Phoenix is de facto protocol used
>> for such readers and there is whole bunch of different RS232
>> (/dev/ttyS#) or USB-serial (/dev/ttyUSB#) readers using that
>> protocol.
>>
>> Anyhow, that one is integrated to DVB USB device that is driven by
>> dvb_usb_anysee driver. As I understand, I need reserve new device
>> name and major number for my device. See Documentation/devices.txt
>
> Why not just use the usb-serial core and then you get a ttyUSB* device
> node "for free"?  It also should provide a lot of the basic tty
> infrastructure and ring buffer logic all ready to use.

Since I don't see how I can access same platform data from DVB USB  and 
USB-serial driver (usb_set_intfdata). I asked that earlier, see: 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg36027.html

regards
Antti

-- 
http://palosaari.fi/
