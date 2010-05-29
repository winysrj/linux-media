Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:43194 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab0E2NLt (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 29 May 2010 09:11:49 -0400
Message-ID: <4C011267.2040103@tmr.com>
Date: Sat, 29 May 2010 09:11:03 -0400
From: Bill Davidsen <davidsen@tmr.com>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
	bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 16050] New: The ibmcam driver is not working
References: <bug-16050-10286@https.bugzilla.kernel.org/> <20100528154635.129b621b.akpm@linux-foundation.org>
In-Reply-To: <20100528154635.129b621b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andrew Morton wrote:
> (switched to email.  Please respond via emailed reply-to-all, not via the
> bugzilla web interface).
>
> On Tue, 25 May 2010 23:02:23 GMT
> bugzilla-daemon@bugzilla.kernel.org wrote:
>
>   
>> https://bugzilla.kernel.org/show_bug.cgi?id=16050
>>
>>                URL: https://bugzilla.redhat.com/show_bug.cgi?id=588900
>>            Summary: The ibmcam driver is not working
>>            Product: Drivers
>>            Version: 2.5
>>     Kernel Version: 2.6.34
>>           Platform: All
>>         OS/Version: Linux
>>               Tree: Mainline
>>             Status: NEW
>>           Severity: normal
>>           Priority: P1
>>          Component: USB
>>         AssignedTo: greg@kroah.com
>>         ReportedBy: davidsen@tmr.com
>>         Regression: Yes
>>
>>
>> This driver has been working, and around the 1st of May I updated my Fedora
>> kernel (FC13-RC) to current. The camera stopped working, so I built the latest
>> 2.6.34-rc version and verified the problem. When 2.6.34 final released I
>> repeated the test and the driver is still not working.
>>
>> Originally reported against Fedora (not going to be fixed in FC13) the
>> information in the Fedora report may be enough to identify the problem. I can
>> do a bit of test almost any day, but the cams are on a video monitoring system,
>> so I'm not able to do long bisects and such.
>>
>>     
>
> It's a 2.6.33 -> 2.6.34 regression, I think.  I don't know whether it's
> a v4l problem or a USB one..
>
>   
I noted this problem in Fedora kernels:

2.6.33.2-41.fc13.x86_64 - worked
2.6.33.2-57.fc13.x86_64 - fails

The first was on my video server 4/21 when I left for a trip to the midwest,
and worked perfectly with the "motion" app for the entire ten days. When I
installed the current update on 5/2 or so it stopped working. I did go back
and boot the older kernel and it still works, not some bizarre hardware thing.

After boot I have /dev/video0 as the ibmcam, but after first attempted use
the device is gone. Since it worked in older kernels I rebooted and tried
running it in an older VM (fc9) using USB passthru to KVM. That also didn't
work. Does that tell anyone more than it tells me?



-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

