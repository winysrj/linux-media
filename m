Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.tmr.com ([64.65.253.246]:57170 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752244Ab0E2DTx (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 23:19:53 -0400
Message-ID: <4C0087AA.3030909@tmr.com>
Date: Fri, 28 May 2010 23:19:06 -0400
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
Sounds right, there's quite a bit of version information in the redhat 
BZ entry I noted, and I thought it was a Fedora issue at first. Then 
when Fedora support said it wasn't going to be fixed for FC13 I tried 
the kernel.org source instead. There are some initial comments from 
zaitcev@redhat.com saying there were patches in git to make it work with 
fswebcam (don't use it), but it doesn't seem to with cheese, motion, or 
xawtv, so I'm unsure how "fixed" it is.

I'm ready to try stable releases as they come out, or git releases if 
need be. I have issues getting time on build machine or time of video 
server to do bisect, unfortunately. I looked at the patches all the way 
back to 2.6.27, and ibmcam looks inert, so the changes in v4l would be 
my first guess. Sorry I can't do more.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

