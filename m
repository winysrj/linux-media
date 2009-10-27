Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:54182 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251AbZJ0OQ6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Oct 2009 10:16:58 -0400
Received: by ewy4 with SMTP id 4so195171ewy.37
        for <linux-media@vger.kernel.org>; Tue, 27 Oct 2009 07:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
References: <8d0bb7650910261544i4ebed975rf81ec6bc38076927@mail.gmail.com>
	 <a413d4880910261623x44d106f4h167a7dab80a4a3f8@mail.gmail.com>
Date: Tue, 27 Oct 2009 10:17:02 -0400
Message-ID: <83bcf6340910270717n12066fb8oa4870eb3214d7597@mail.gmail.com>
Subject: Re: Hauppage HVR-2250 Tuning problems
From: Steven Toth <stoth@kernellabs.com>
To: Another Sillyname <anothersname@googlemail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> I have done some searching online, and that's what led me to scan,
>> dvbscan and scte65scan, but none of the suggestions I've found so far
>> seem to help.  Does anyone have any suggestions as to where I can go
>> from here?  Could there be something wrong with the card itself?  Are
>> there any diagnostics I could run?
>>
>> Thanks in advance for any help that anyone can offer.

Dan,

I'm not aware of any digital cable issues currently.

1) Do you have any other tvtuners that can validate your signal is
working correctly? Specifically, for a number of identifiable
frequencies?

2) Is your cable plant standard cable, IRC, or HRC?

3) I suggest you put together a rudamentary $HOME/.azap/channels.conf
and experiment with azap, that works really well for me.

Here's a sample from my development channels.conf:
c112:723000000:QAM_256:288:289:713
c86:597000000:QAM_256:288:289:713

Try this with azap -r c86 or c112, what happens?

- Steve

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
