Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:54681 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbGEPpV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jul 2015 11:45:21 -0400
Date: Sun, 5 Jul 2015 17:45:06 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Andy Furniss <adf.lists@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <55994284.6080209@gmail.com>
Message-ID: <alpine.BSF.2.20.1507051721550.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <5598FDDC.7020804@gmail.com> <alpine.BSF.2.20.1507051323270.71755@nic-i.leissner.se> <55991C3D.4020305@gmail.com> <alpine.BSF.2.20.1507051542470.72900@nic-i.leissner.se>
 <55994284.6080209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> Peter Fassberg wrote:
>> 
>>> Peter Fassberg wrote:
>>>> 
>>>>>> I'm trying to get PCTV TripleStick 292e working in a
>>>>>> Raspberry Pi B+ environment.
>>>>>> 
>>>>>> I have no problem getting DVB-T to work, but I can't tune to
>>>>>> any DVB-T2 channels. I have tried with three different
>>>>>> kernels: 3.18.11, 3.18.16 and 4.0.6.  Same problem.  I also
>>>>>> cloned the media_build under 4.0.6 to no avail.
>>>>>> 
>>>>>> The same physical stick works perfectly with DVB-T2 in an
>>>>>> Intel platform using kernel 3.16.0.

> OK - strange, is the issue reproducable with the current version of w_scan?

Yes, it is.

I used the latest I could find: w_scan version 20141122 (compiled for DVB API 5.10)

Excerpt from scanning:

198500: (time: 02:02.219)
205500: (time: 02:04.269)
         (0.250sec): SC (0x3)
         (0.250sec) signal
         (0.920sec):  (0x0)
         (1.180sec): SC (0x3)
         (1.840sec):  (0x0)
         (2.100sec): SC (0x3)
         (2.760sec):  (0x0)
         (3.020sec): SC (0x3)
         (3.680sec):  (0x0)
         (3.940sec): SC (0x3)
212500: (time: 02:08.619)

As you can see it do find Signal and Carrier, but no Lock.  Without debug (-v) it doesn't show anything.



// Peter

