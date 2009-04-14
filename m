Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:40822 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbZDNPyc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Apr 2009 11:54:32 -0400
Received: by yx-out-2324.google.com with SMTP id 31so2720550yxl.1
        for <linux-media@vger.kernel.org>; Tue, 14 Apr 2009 08:54:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E492D0.3070101@orthfamily.net>
References: <49E40322.5040600@orthfamily.net>
	 <412bdbff0904140552m52c0106q960f7c0ee40757c@mail.gmail.com>
	 <49E492D0.3070101@orthfamily.net>
Date: Tue, 14 Apr 2009 11:54:31 -0400
Message-ID: <412bdbff0904140854x69a700a5pcbff84853ef9f8dd@mail.gmail.com>
Subject: Re: [linux-dvb] Pinnacle HD Stick (801e SE) and i2c issues
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: John Orth <john@orthfamily.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 14, 2009 at 9:42 AM, John Orth <john@orthfamily.net> wrote:
> Thank you for your prompt response, Devin.
>>
>> 1.  Are you sure the port on the PC supports USB 2.0?
>
> According to the M3A78-EM spec, all 6 USB ports are 2.0, so I don't think
> that is the issue.  I will double-check this, though.
>>
>> 2.  Which application are you using to test with?
>
> I am using MythTV to view video, the "scan" utility from the Ubuntu package
> dvb-apps, and I compiled "w_scan" from source.
>>
>> 3.  Are you doing anything with suspend/resume on the PC?
>
> Not at the moment.  The only power save feature I have enabled is turning
> off the monitor, but these issues occur before the system is idle long
> enough for that to take place.
>>
>> 4.  Are you plugged directly into the USB port, or are you using any
>> sort of USB extension cable?
>
> Yes, my 801e SE came with a short (~3") USB extension cable which I am using
> to snake the device out the back of the media shelf.  Not a huge deal if it
> needs to be removed, though.

Hmm...  Yeah, don't worry about the 3" cable that came with the 801e.
I just asked because I've seen 6 foot cables that had issues.

I suspect this is probably some issue with the USB host chipset.  The
error messages you provided suggest a problem sending commands to the
dib0700 USB bridge, so this does not appear to be related to the
s5h1411 or the xc5000.

I'll have to take a look at the code and see what I can figure out.
Do other high speed USB devices work with your host without any
problem (like USB hard drives, etc?)

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
