Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49288 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874Ab1KKWwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Nov 2011 17:52:00 -0500
Received: by iage36 with SMTP id e36so4592890iag.19
        for <linux-media@vger.kernel.org>; Fri, 11 Nov 2011 14:51:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
References: <CAB33W8dW0Yts_dxz=WyYEK9-bcoQ_9gM-t3+aR5s-G_5QswOyA@mail.gmail.com>
	<CAB33W8eMEG6cxM9x0aGRe+1xx6TwvjBZL4KSdRY4Ti2sTHk9hg@mail.gmail.com>
	<CAL9G6WXq_MSu+6Ogjis43bsszDri0y5JQrhHrAQ8tiTKv09YKQ@mail.gmail.com>
Date: Sat, 12 Nov 2011 09:51:59 +1100
Message-ID: <CAATJ+ftr76OMckcpf_ceX4cPwv0840C9HL+UuHivAtub+OC+jw@mail.gmail.com>
Subject: Re: AF9015 Dual tuner i2c write failures
From: Jason Hecker <jwhecker@gmail.com>
To: Josu Lazkano <josu.lazkano@gmail.com>
Cc: Tim Draper <veehexx@gmail.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I concur.  I have been using Malcolm Priestly's patches with both my
AF9015 dual tuner cards (which are PCI but still look like USB to the
kernel) for a few weeks now and have (finally!) got consistently
perfect recordings in MythTV simultaneously with both tuners on a
card. Malcolm, when do you think you'll submit these patches to the
tree for inclusion?  Is there anything else to test?

I agree about the power cycling.  Every time I reboot I disconnect the
AC supply for 20secs to be sure the cards are power cycled properly -
you do the same thing by pulling out the stick.

On 12 November 2011 09:16, Josu Lazkano <josu.lazkano@gmail.com> wrote:
> 2011/11/11 Tim Draper <veehexx@gmail.com>:
>> Hi all,
>>
>> i've recently bought an AF9015 usb module from ebay, and am struggling
>> to get it working correctly. i've been recommended to post here on the
>> mythtv MailingList.
>>
>> i'm running mytbuntu 11.04 x64, and the mythbackend service shows
>> af9013: I2C read failed reg:d607
>> af9015: command failed:1
>> and will refuse to establish a lock. so far i've only been able to
>> find a temporary fix to this by re-inserting the USB stick (ie: it has
>> to loose power on the USB stick)
>>
>> i've been googling a fair bit, and i've only found somewhat old info
>> reguarding (firmware?) source code that is no longer available (it has
>> been merged into another codeset), and thus the patch file is not
>> applicable to it....
>> http://ubuntuforums.org/showpost.php?p=9712937&postcount=126 is what
>> i'm working from.
>>
>> i am confident the device does work as if i test it immediately after
>> being re-inserted i get both tuners working fine. after a while though
>> i start seeing the above errors in the mythtv logs, and i am no longer
>> able to tune into channels.
>>
>> just to be clear, i am sure the issue is down to a firmware/driver
>> issue, and not a config or a problem is yet to be discovered as the
>> last few nights of googling does show this as an issue on certain
>> devices.
>>
>> how do i get this issue sorted?
>> thanks for any help!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Hello Tim, Malcolm is working on a patch and it is working, maybe it
> is not finished but I am using it on MythTV.
>
> I can send it, but I prefer to wait a reply from Malcolm, he is great!
>
> Best regards.
>
> --
> Josu Lazkano
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
