Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:43508 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194Ab1H2Dyj (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 28 Aug 2011 23:54:39 -0400
Message-ID: <4E5B0D7C.60003@iki.fi>
Date: Mon, 29 Aug 2011 06:54:36 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: usb_set_intfdata usage for two subdrivers
References: <4E5ACF92.3020907@iki.fi> <20110829003617.GA8372@kroah.com>
In-Reply-To: <20110829003617.GA8372@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/29/2011 03:36 AM, Greg KH wrote:
> On Mon, Aug 29, 2011 at 02:30:26AM +0300, Antti Palosaari wrote:
>> I am trying to implement DVB USB device smartcard reader support
>> using USB-serial.
>
> Really?  Why?  That doesn't seem to make sense, please explain more.

Since it is old style serial smartcard reader, not CCID PC/SC as new 
readers. I see it a little bit overkill to register virtual HCI and 
virtual CCID device though it sounds interesting.

There is already one such similar driver, iuu_phoenix, but without DVB 
support ;) Consider situation I have iuu_phoenix integrated to USB DVB 
device. Both using same USB enpoint, sharing hardware resources of 
communication.

>> The main problem is now that both DVB-USB and
>> USB-serial uses interface data (usb_set_intfdata / usb_get_intfdata)
>> for state.
>>
>> Is there any common solution to resolve issue easily?
>
> No two drivers can bind to the same USB interface, so of course they
> would interfere.
>
> Care to explain the problem in more detail to see if there is a better
> way to do all of this?
>
> greg k-h


regards
Antti

-- 
http://palosaari.fi/
