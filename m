Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qg0-f41.google.com ([209.85.192.41]:32913 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751697AbbGPMI4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Jul 2015 08:08:56 -0400
Received: by qged69 with SMTP id d69so1915380qge.0
        for <linux-media@vger.kernel.org>; Thu, 16 Jul 2015 05:08:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <793F9B08F3534CF1A955E5FB54C25D59@wincomm.com.tw>
References: <c29a3c94d042b15780c33b68f71d16fc@www.kernellabs.com>
	<CALzAhNV7EadNu6Yx78zVxwtx9u01PkrGAoyguvq=ZmLdtKZmew@mail.gmail.com>
	<CALzAhNUohn47x6fF2i8W0CtDSz9VmhtZSCkNp2BzJXvgm9raCQ@mail.gmail.com>
	<793F9B08F3534CF1A955E5FB54C25D59@wincomm.com.tw>
Date: Thu, 16 Jul 2015 08:08:55 -0400
Message-ID: <CALzAhNXv8g-cuiE0qYSu18AXksQvZY1U1JTVvYGZpPbHfoas4g@mail.gmail.com>
Subject: Re: www.kernellabs.com Contact: Hauppauge hvr1275 TV Tuner card linux problem
From: Steven Toth <stoth@kernellabs.com>
To: tonyc@wincomm.com.tw
Cc: Linux-Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Dear : Steven Toth
> Thanks for your professional answer
> Thanks a lot
> Best Regards

You are welcome!

>> It looks like Hauppauge have released an updated HVR-1275 card, as
>> indicated by the updated PCI-SubDevice ID 2A38. The hardware has
>> changed and the driver needs to be modified to support these changes.
>>
>> Modprobing with option=19 isn't going to help.
>
> I've reached out to Hauppauge for comment on the new H/W. Stay tuned.

A sample HVR-1275 arrived yesterday, thank you Hauppauge.

I'll add driver support for this in the coming week, DTV only, its on
my todo list.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
