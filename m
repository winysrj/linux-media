Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:50311 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752556AbZDFNsy (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Apr 2009 09:48:54 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta2.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KHO00GW8MDEPT10@mta2.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 06 Apr 2009 09:48:51 -0400 (EDT)
Date: Mon, 06 Apr 2009 09:48:50 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge WinTV-HVR-4000 / Nova-HD-S2
In-reply-to: <49D5CF7C.2060704@yahoo.co.nz>
To: Kevin Wells <wells_kevin@yahoo.co.nz>
Cc: Jonas Kvinge <linuxtv@closetothewind.net>,
	linux-media@vger.kernel.org
Message-id: <49DA0842.7030306@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <49D56335.2020506@closetothewind.net> <49D5CF7C.2060704@yahoo.co.nz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Wells wrote:
> Jonas Kvinge wrote:
>> Whats the command to extract the firmware from the new driver release at
>> http://www.wintvcd.co.uk/drivers/88x_2_123_27056_WHQL.zip
>>
>> The driver at http://www.wintvcd.co.uk/drivers/88x_2_122_26109_WHQL.zip
>> is no longer available, so the link on
>> http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-4000 is broken.
>>   
> Hi Jonas,
> 
> I can't remember the exact command off the top of my head. But I can
> tell you how to work it out.
> 
> The problem is how to determine the offset to use. Look at this hex dump
> from the start of each firmware file:
> 
>     dvb-fe-cx24116-1.20.79.0.fw:
>         00000000  02 11 f9 ec 33 50 03 12
> 
>     dvb-fe-cx24116-1.22.82.0.fw:
>         00000000  02 11 fb ec 33 50 03 12
> 
>     dvb-fe-cx24116-1.23.86.1.fw:
>         00000000  02 12 02 ec 33 50 03 12
> 
> Note the magic `33 50 03 12` bytes that appear at offset 4 in each
> firmware file. You can use that to determine the offset of the firmware
> in the `hcw88bda.sys` file (at least for the existing firmware files).
> 
> I used `hd hcw88bda.sys | more` and typed `/33 50 03 12` in `more` to
> find the offset. Make sure to subtract 4 from the offset of the `33 50
> 03 12` bytes. Convert the offset from hex to decimal and use that as the
> `skip` amount for the `dd` command.
> 
> Verify the extracted firmware using `md5sum`.
> 
> Perhaps when you get it to work you could update the wiki page you
> mentioned.

This:

http://www.steventoth.net/linux/cx24116/


