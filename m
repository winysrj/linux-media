Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m3OHrbY0017544
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 13:53:37 -0400
Received: from mail.hauppauge.com (mail.hauppauge.com [167.206.143.4])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m3OHqwcv016650
	for <video4linux-list@redhat.com>; Thu, 24 Apr 2008 13:53:07 -0400
Message-ID: <4810C8DA.9030601@linuxtv.org>
From: mkrufky@linuxtv.org
To: greg@kroah.com
Date: Thu, 24 Apr 2008 13:52:26 -0400
MIME-Version: 1.0
in-reply-to: <20080424170142.GA20017@kroah.com>
Content-Type: text/plain;
	charset="iso-8859-1"
Cc: video4linux-list@redhat.com
Subject: Re: [BUG] HVR-1500 Hot swap causes lockup
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Greg KH wrote:
> On Thu, Apr 24, 2008 at 10:40:24AM -0400, Michael Krufky wrote:
>   
>> On Thu, Apr 24, 2008 at 10:32 AM, Jon Lowe <jonlowe@aol.com> wrote:
>>     
>>> While not exactly the same, this bug MAY be related to my hot swap
poblem:
>>>
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/12519
>>>       
>> No relation.  Also, we're in 2.6.26 development, most 2.6.15 bugs are
>> entirely irrelevant.
>>
>> The problem is PCIe hotplugging  -- it doesn't work in Linux, at
>> least, not with Expresscards.  This issue is not specific to the
>> HVR1500 -- you'll see it on other similar Expresscards as well.
>>     
>
> Huh?  We had expresscard hotplugging working in Linux before any other
> operating system ever did.  It works for me just fine here on many
> machines, and does so for many thousands of users.
>
>   
>> I can only get the HVR1500 / HVR1500Q / HVR1400 to come up properly if
>> it is installed in the system when I boot up the PC.  Inserting it
>> after boot does absolutely nothing, and removing it after you booted
>> the system with it installed will leave the system unstable.
>>     
>
> Have you actually loaded the pci hotplug controller driver that is
> needed to get hotplugging of express cards to work properly?  :)
Now I am very glad that I cc'd you.

I'll google a bit to find the name of the "pci hotplug controller 
driver" module, then give this a try.

Hopefully the solution is this simple.

Thanks Greg!


Regards,

Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
