Return-path: <linux-media-owner@vger.kernel.org>
Received: from relais.videotron.ca ([24.201.245.36]:8939 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764189AbZCaXX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Mar 2009 19:23:58 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from localhost.localdomain ([70.81.178.230])
 by VL-MO-MR002.ip.videotron.ca
 (Sun Java(tm) System Messaging Server 6.3-4.01 (built Aug  3 2007; 32bit))
 with ESMTP id <0KHE003008ZVYF10@VL-MO-MR002.ip.videotron.ca> for
 linux-media@vger.kernel.org; Tue, 31 Mar 2009 19:23:55 -0400 (EDT)
Message-id: <49D2A608.2070400@videotron.ca>
Date: Tue, 31 Mar 2009 19:23:52 -0400
From: Michel Dansereau <Michel.Dansereau@videotron.ca>
To: Steven Toth <stoth@linuxtv.org>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Wintv-1250 - EEPROM decoding - V4L DVB
References: <49CFC642.3030408@videotron.ca> <49CFFECB.4080902@linuxtv.org>
 <49D1532C.4050106@videotron.ca> <49D22A0B.6040500@linuxtv.org>
In-reply-to: <49D22A0B.6040500@linuxtv.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Steve,
    Point taken about dropping the mailing list.
    Thanks!
Michel

Steven Toth wrote:
> Michel Dansereau wrote:
>> Then my next question is: how different is my board from the one 
>> supported?
>> Does the analog section work at this point? Sure does not for me!
>>
>> Steven Toth wrote:
>>>>        switch (dev->board) {
>>>> /* removed        case CX23885_BOARD_HAUPPAUGE_HVR1250: */
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1500:
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1400:
>>>>                if (dev->i2c_bus[0].i2c_rc == 0)
>>>>                        hauppauge_eeprom(dev, eeprom+0x80);
>>>>                break;
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1250: /*added*/
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1800:
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1200:
>>>>        case CX23885_BOARD_HAUPPAUGE_HVR1700:
>>>>                if (dev->i2c_bus[0].i2c_rc == 0)
>>>>                        hauppauge_eeprom(dev, eeprom+0xc0);
>>>>                break;
>>>>        }
>>>
>>> Thanks.
>>>
>>> Hauppauge have various revs of the 1250 and the eeprom offset can 
>>> change. It looks like your model is different the the stock HVR-1250 
>>> I've seen.
>>>
>>> - Steve
>>
>
> Please don't drop the mailing list off of replies. Linux wouldn't 
> exist if we perpetuated this habit.
>
> To answer your question, no significant differences. Analog won't work 
> because I haven't done it. :)
>
> The eeprom offset is the only notable difference at this point. I'll 
> look into this, at some point.
>
> - Steve

