Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:35160 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271AbZLDSDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Dec 2009 13:03:17 -0500
Received: by ewy19 with SMTP id 19so3121020ewy.1
        for <linux-media@vger.kernel.org>; Fri, 04 Dec 2009 10:03:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912031403l6b828821q87f407fa95bc25f9@mail.gmail.com>
References: <1259695756.5239.2.camel@desktop>
	 <loom.20091202T230047-299@post.gmane.org>
	 <37219a840912021508s75535fa6v83006d3bad0c301@mail.gmail.com>
	 <1259874920.2151.13.camel@desktop>
	 <41ef408f0912031347j6b9a704flc6d9c302f4e0517@mail.gmail.com>
	 <829197380912031403l6b828821q87f407fa95bc25f9@mail.gmail.com>
Date: Fri, 4 Dec 2009 13:03:23 -0500
Message-ID: <37219a840912041003o4d8ebe27wbe3f1c47f55ba7dc@mail.gmail.com>
Subject: Re: af9015: tuner id:179 not supported, please report!
From: Michael Krufky <mkrufky@kernellabs.com>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Bert Massop <bert.massop@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 3, 2009 at 5:03 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> On Thu, Dec 3, 2009 at 4:47 PM, Bert Massop <bert.massop@gmail.com> wrote:
>> Hi Jan,
>>
>> The datasheet for the TDA18218 can be obtained from NXP:
>> http://www.nxp.com/documents/data_sheet/TDA18218HN.pdf
>>
>> That's all the information I have at the moment, maybe Mike has some
>> other information (like the Application Note mentioned in the
>> datasheet, that claims to contain information on writing drivers, but
>> cannot be found anywhere).
>>
>> Best regards,
>>
>> Bert
>
> Took a quick look at that datasheet.  I would guess between that
> datasheet and a usbsnoop, there is probably enough there to write a
> driver that basically works for your particular hardware if you know
> what you are doing.  The register map is abbreviated, but probably
> good enough...
>
> Devin

The datasheet is missing too much important information needed to
write a fully featured driver for the part, and I wouldn't recommend
using a usbsnoop for this type of tuner, but be my guest and prove me
wrong.

You might be able to get it working, but you'll end up with tons of
binary blobs hardcoded for each frequency, unless you use a
programming guide.  Unfortunately, I don't have one that I can share
:-/

I think you would be much better off purchasing supported hardware, instead.

Good luck, though...

-Mike
