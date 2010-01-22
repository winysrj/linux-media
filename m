Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:53059 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab0AVQSO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 11:18:14 -0500
Received: by ewy19 with SMTP id 19so1625191ewy.21
        for <linux-media@vger.kernel.org>; Fri, 22 Jan 2010 08:18:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B587B91.9070300@koala.ie>
References: <135ab3ff1001200926j9917d69x51eede94512fa664@mail.gmail.com>
	 <829197381001201000x58aadea5wab0948691d9a4c4f@mail.gmail.com>
	 <135ab3ff1001210155qad2c794rf6781c4ac28159c7@mail.gmail.com>
	 <d9def9db1001210407s6f14d637x1e32d34f7193a188@mail.gmail.com>
	 <4B587B91.9070300@koala.ie>
Date: Fri, 22 Jan 2010 17:18:08 +0100
Message-ID: <135ab3ff1001220818r3e10650fl80e873c441bffde4@mail.gmail.com>
Subject: Re: Drivers for Eyetv hybrid
From: Morten Friesgaard <friesgaard@gmail.com>
To: Simon Kenyon <simon@koala.ie>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Actually I don't understand why this em28xx driver is the only one
being patched, guess that reduces backward compability!? :-P

Well, I haven't given up, but no one has given me any pointers but /dev/null
If this em28xx module would be startable with the usb id "0fd9:0018",
I could tryout the old driver.
If you say the hardware design is completely different, I guess it
should still be possible to mount the usb device and fetch anything
from the device (e.g. tvtime -d /dev/usbdev). The driver would be a
matter of controlling the device to tune to the correct channel etc.

When new hardware is introduced, how do you guys break down the task
and implement a driver? (how much can be borrow from the mac os x
drivers?)

/Morten



On Thu, Jan 21, 2010 at 5:06 PM, Simon Kenyon <simon@koala.ie> wrote:
> On 21/01/2010 12:07, Markus Rechberger wrote:
>>
>> On Thu, Jan 21, 2010 at 10:55 AM, Morten Friesgaard
>> <friesgaard@gmail.com>  wrote:
>>
>>>
>>> To bad. I bought this tuner because of the cross platform compability :-/
>>>
>>> Well, it looks awfully alot like the TerraTec H5, would there be a
>>> driver this one?
>>> http://www.terratec.net/en/products/TerraTec_H5_83188.html
>>>
>>>
>>
>> just fyi. this Terratec device is not supported. We've been working on
>> a device with equivalent features
>> (DVB-T/C/AnalogTV/VBI/Composite/S-Video/FM-Radio/RDS/Remote Control)
>> http://support.sundtek.com/index.php/topic,4.0.html
>> We are also integrating additional flexible USB CI support for it.
>>
>> Best Regards,
>> Markus Rechberger
>>
>
> you just don't give up - do you?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
