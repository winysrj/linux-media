Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:51106 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZFOOs1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 10:48:27 -0400
Received: from host143-65.hauppauge.com
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KLA00IHYBGNWDU0@mta4.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 15 Jun 2009 10:41:12 -0400 (EDT)
Date: Mon, 15 Jun 2009 10:41:10 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: s5h1411_readreg: readreg error (ret == -5)
In-reply-to: <1244851654.3777.3.camel@pc07.localdom.local>
To: linux-media@vger.kernel.org
Cc: hermann pitton <hermann-pitton@arcor.de>,
	Mike Isely <isely@isely.net>, Andy Walls <awalls@radix.net>,
	Roger <rogerx@sdf.lonestar.org>
Message-id: <4A365D86.1070803@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <1244446830.3797.6.camel@localhost2.local>
 <Pine.LNX.4.64.0906102257130.7298@cnc.isely.net>
 <4A311A64.4080008@kernellabs.com>
 <Pine.LNX.4.64.0906111343220.17086@cnc.isely.net>
 <1244759335.9812.2.camel@localhost2.local>
 <Pine.LNX.4.64.0906121531100.6470@cnc.isely.net>
 <1244841123.3264.55.camel@palomino.walls.org>
 <Pine.LNX.4.64.0906121627000.6470@cnc.isely.net>
 <1244846370.3803.44.camel@pc07.localdom.local>
 <1244851654.3777.3.camel@pc07.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

hermann pitton wrote:
> [snip]
>> The most undiscovered configurations seem to be such ones about antenna
>> inputs and their switching. Again according to Hartmut, and he did not
>> know exactly what is going on here, some for us and him at this point
>> unknown checksums are used to derive even that information :(
>>
>> For what I can see, and I might be of course still wrong, we can also
>> not determine plain digital tuner types, digital demodulator types of
>> any kind and the type of possibly present second and third tuners, but
>> at least their addresses, regularly shared by multiple chips, become
>> often visible. (some OEMs have only 0xff still for all that)
> 
> forgot, and not any LNB supplies behind some i2c bridges, shared or not
> on whatever.

The use of Hauppauge eeproms I consider advisory at best. Yes, they have 
reasonably good fields to identify tuners, IR but a number of recent silicon 
additions (last 3 years) to the product line is not fully implemented in the 
eeproms. Some of the important feature decisions is done purely in software 
based on sub id for example.

In general I agree with Hermann's comments, that is,  where possible making 
maximum use of the eeprom.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
