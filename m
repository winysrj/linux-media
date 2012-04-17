Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:59891 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932338Ab2DQNo7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Apr 2012 09:44:59 -0400
Message-ID: <4F8D73D4.70509@schinagl.nl>
Date: Tue, 17 Apr 2012 15:44:52 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Florian Fainelli <f.fainelli@gmail.com>,
	linux-media@vger.kernel.org, marbugge@cisco.com, hverkuil@cisco.com
Subject: Re: [RFC] HDMI-CEC proposal
References: <4F86F3A6.9040305@gmail.com> <4F873CE7.4040401@schinagl.nl> <4F8D70A7.4050105@iki.fi>
In-Reply-To: <4F8D70A7.4050105@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Yes, the library to talk to the device is opensource, the hardware, not 
so much. :)

On 17-04-12 15:31, Anssi Hannula wrote:
> 12.04.2012 23:36, Oliver Schinagl kirjoitti:
>> Since a lot of video cards dont' support CEC at all (not even
>> connected), don't have hdmi, but work perfectly fine with dvi->hdmi
>> adapters, CEC can be implemented in many other ways (think media centers)
>>
>> One such exammple is using USB/Arduino
>>
>> http://code.google.com/p/cec-arduino/wiki/ElectricalInterface
>>
>> Having an AVR with v-usb code and cec code doesn't look all that hard
>> nor impossible, so one could simply have a USB plug on one end, and an
>> HDMI plug on the other end, utilizing only the CEC pins.
>>
>> This would make it more something like LIRC if anything.
> There already exists a device like this (USB CEC adapter with hdmi
> in/out) with open source userspace driver, developed for the XBMC Media
> Center (apparently MythTV is also supported):
>
> http://www.pulse-eight.com/store/products/104-usb-hdmi-cec-adapter.aspx
> http://libcec.pulse-eight.com/
> https://github.com/Pulse-Eight/libcec
>

