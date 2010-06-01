Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:44395 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0FARUp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Jun 2010 13:20:45 -0400
Message-ID: <4C054105.6020806@tmr.com>
Date: Tue, 01 Jun 2010 13:19:01 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 16050] New: The ibmcam driver is not working
References: <bug-16050-10286@https.bugzilla.kernel.org/> <20100528154635.129b621b.akpm@linux-foundation.org> <4C04C942.6000900@redhat.com>
In-Reply-To: <4C04C942.6000900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans de Goede wrote:
> Hi,
>
> On 05/29/2010 12:46 AM, Andrew Morton wrote:
>>
>> (switched to email.  Please respond via emailed reply-to-all, not via 
>> the
>> bugzilla web interface).
>>
>> On Tue, 25 May 2010 23:02:23 GMT
>> bugzilla-daemon@bugzilla.kernel.org wrote:
>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=16050
>>>
>>>                 URL: https://bugzilla.redhat.com/show_bug.cgi?id=588900
>>>             Summary: The ibmcam driver is not working
>>>             Product: Drivers
>>>             Version: 2.5
>>>      Kernel Version: 2.6.34
>>>            Platform: All
>>>          OS/Version: Linux
>>>                Tree: Mainline
>>>              Status: NEW
>>>            Severity: normal
>>>            Priority: P1
>>>           Component: USB
>>>          AssignedTo: greg@kroah.com
>>>          ReportedBy: davidsen@tmr.com
>>>          Regression: Yes
>>>
>>>
>>> This driver has been working, and around the 1st of May I updated my 
>>> Fedora
>>> kernel (FC13-RC) to current. The camera stopped working, so I built 
>>> the latest
>>> 2.6.34-rc version and verified the problem. When 2.6.34 final 
>>> released I
>>> repeated the test and the driver is still not working.
>>>
>>> Originally reported against Fedora (not going to be fixed in FC13) the
>>> information in the Fedora report may be enough to identify the 
>>> problem. I can
>>> do a bit of test almost any day, but the cams are on a video 
>>> monitoring system,
>>> so I'm not able to do long bisects and such.
>>>
>>
>> It's a 2.6.33 ->  2.6.34 regression, I think.  I don't know whether it's
>> a v4l problem or a USB one..
>>
>
> It may very well be a regression, I don't know. But in general the 
> usbvideo drivers
> (of which the ibmcam is one) have been unmaintained for a long while, 
> and they are
> still v4l1 drivers. I've been slowly working on converting all old 
> v4l1 usb webcam
> drivers to the gspca usb webcam driver framework, removing a lot of 
> code duplication
> (and other cruft such as controls being controlled through module 
> parameters)
> from these drivers and making them v4l2 drivers in the progress.
>
> I really bough 2 ibmcam driver using webcams in the US and had them 
> shipped to the
> Netherlands esp. for this purpose. I hope to have a new gspca 
> subdriver to replace
> ibmcam soon.
>
> I know this is not really a fix for the problems with the existing 
> ibmcam driver, but
> as it is destined to be replaced soon anyways I think this is the best 
> way forward.
>
I tried the 2.6.34-11.fc13.x86_64 kernel, and the cameras "sort of" work 
again, I had to change the size being used in the motion.conf file to 
match what I found in the messages log, then I get imaging again, but 
the kernel has multiple OOPS issues, which I have sent off to the 
kerneloops folks. I don't feel comfortable using that kernel, even if it 
doesn't actually die (or hasn't yet).

In case you don't have this information, here is a line from lsusb:
  Bus 003 Device 002: ID 0545:8080 Xirlink, Inc. IBM C-It Webcam

Hopefully the items you have ordered are the same model.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

