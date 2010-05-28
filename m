Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750855Ab0E1WrR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 May 2010 18:47:17 -0400
Date: Fri, 28 May 2010 15:46:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, davidsen@tmr.com
Subject: Re: [Bugme-new] [Bug 16050] New: The ibmcam driver is not working
Message-Id: <20100528154635.129b621b.akpm@linux-foundation.org>
In-Reply-To: <bug-16050-10286@https.bugzilla.kernel.org/>
References: <bug-16050-10286@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Tue, 25 May 2010 23:02:23 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> https://bugzilla.kernel.org/show_bug.cgi?id=16050
> 
>                URL: https://bugzilla.redhat.com/show_bug.cgi?id=588900
>            Summary: The ibmcam driver is not working
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.34
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: davidsen@tmr.com
>         Regression: Yes
> 
> 
> This driver has been working, and around the 1st of May I updated my Fedora
> kernel (FC13-RC) to current. The camera stopped working, so I built the latest
> 2.6.34-rc version and verified the problem. When 2.6.34 final released I
> repeated the test and the driver is still not working.
> 
> Originally reported against Fedora (not going to be fixed in FC13) the
> information in the Fedora report may be enough to identify the problem. I can
> do a bit of test almost any day, but the cams are on a video monitoring system,
> so I'm not able to do long bisects and such.
> 

It's a 2.6.33 -> 2.6.34 regression, I think.  I don't know whether it's
a v4l problem or a USB one..

