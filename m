Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta3.srv.hcvlny.cv.net ([167.206.4.198]:33678 "EHLO
	mta3.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbZE0O4i (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 May 2009 10:56:38 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta3.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KKB00H115IDRSV0@mta3.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Wed, 27 May 2009 10:56:38 -0400 (EDT)
Date: Wed, 27 May 2009 10:56:37 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: [linux-dvb] EPG (Electronic Program Guide) Tools
In-reply-to: <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
To: linux-media@vger.kernel.org, linux-dvb@linuxtv.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>
Message-id: <4A1D54A5.40602@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <4A1C2C0F.9090808@gmail.com>
 <829197380905261105k6f1a8f9dl1bcd067863e85e67@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Where does the EPG come from?
>>
>> Is it incorporated into the output stream through PID's some how or is
>> it read from one of the other devices under adapter0?
>>
>> Are there simple command line tools to read it or do you have to write a
>> custom program to interpret it somehow?
>>
>> Could someone please point me in the right direction to get started?  If
>> no tools exist, perhaps links to either api or lib docs/samples?
>>
>>
>> Much appreciated.
>> Chris.
> 
> Hello Chris,
> 
> The ATSC EPG is sent via the ATSC PSIP protocol.  I do not know of any
> tools currently available to extract the information.  MeTV has a
> working implementation (with some bugs I have seen), and I was looking
> at getting it to work in Kaffeine at some point.
> 
> The spec is freely available here:
> 
> http://www.atsc.org/standards/a_65cr1_with_amend_1.pdf

Chris,

You'd expect to be able to get 3-4 days of advanced data to populate a guide 
with, in reality you can often get as little a six hours and that's it. The 
mandatory side of the spec is weak in this area. six hours is fine for Now / 
Next but of little use for anything else.

Depending on your needs, your mileage may vary.

Regards,

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
