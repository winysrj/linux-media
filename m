Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:43662 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761145AbZCaOey (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 10:34:54 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHD0014RKI3XY30@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Tue, 31 Mar 2009 10:34:52 -0400 (EDT)
Date: Tue, 31 Mar 2009 10:34:51 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Wintv-1250 - EEPROM decoding - V4L DVB
In-reply-to: <49D1532C.4050106@videotron.ca>
To: Michel Dansereau <Michel.Dansereau@videotron.ca>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <49D22A0B.6040500@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49CFC642.3030408@videotron.ca> <49CFFECB.4080902@linuxtv.org>
 <49D1532C.4050106@videotron.ca>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Michel Dansereau wrote:
> Then my next question is: how different is my board from the one supported?
> Does the analog section work at this point? Sure does not for me!
> 
> Steven Toth wrote:
>>>        switch (dev->board) {
>>> /* removed        case CX23885_BOARD_HAUPPAUGE_HVR1250: */
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1500:
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1400:
>>>                if (dev->i2c_bus[0].i2c_rc == 0)
>>>                        hauppauge_eeprom(dev, eeprom+0x80);
>>>                break;
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1250: /*added*/
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1800:
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1200:
>>>        case CX23885_BOARD_HAUPPAUGE_HVR1700:
>>>                if (dev->i2c_bus[0].i2c_rc == 0)
>>>                        hauppauge_eeprom(dev, eeprom+0xc0);
>>>                break;
>>>        }
>>
>> Thanks.
>>
>> Hauppauge have various revs of the 1250 and the eeprom offset can 
>> change. It looks like your model is different the the stock HVR-1250 
>> I've seen.
>>
>> - Steve
> 

Please don't drop the mailing list off of replies. Linux wouldn't exist if we 
perpetuated this habit.

To answer your question, no significant differences. Analog won't work because I 
haven't done it. :)

The eeprom offset is the only notable difference at this point. I'll look into 
this, at some point.

- Steve
