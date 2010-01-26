Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39215 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967Ab0AZAAx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2010 19:00:53 -0500
Date: Mon, 25 Jan 2010 16:00:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Patrick Boettcher <pb@linuxtv.org>, fuffi.il.fuffo@gmail.com
Subject: Re: [Bugme-new] [Bug 15087] New: hauppauge nova-t 500 remote
 controller cause usb halt with Via usb controller
Message-Id: <20100125160042.1007c4d8.akpm@linux-foundation.org>
In-Reply-To: <bug-15087-10286@http.bugzilla.kernel.org/>
References: <bug-15087-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Mon, 18 Jan 2010 21:06:57 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=15087
> 
>            Summary: hauppauge nova-t 500 remote controller cause usb halt
>                     with Via usb controller
>            Product: Drivers
>            Version: 2.5
>     Kernel Version: 2.6.32
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: blocking
>           Priority: P1
>          Component: USB
>         AssignedTo: greg@kroah.com
>         ReportedBy: fuffi.il.fuffo@gmail.com
>         Regression: Yes
> 
> 
> This is a know problem with this dvb-t card.
> If the ir receiver is disabled via modprobe option (adding this parameter in
> modprobe.conf: "#options dvb_usb disable_rc_polling=1") I cannot use it but the
> card works perfectly, but if I try to activate it (removing that option) and i
> launch the lircd daemon, I obtain a "usb halt" as described below in this old
> message in the linux-media ml.
> 
> klogd: ehci_hcd 0000:04:00.2: force halt; handhake f8018014 00004000
> 00000000 -> -110
> 
> Here, the writer find the commit that cause this regression:
> http://osdir.com/ml/linux-media/2009-08/msg00185.html
> Here is explained when it was introduced:
> http://osdir.com/ml/linux-media/2009-08/msg00182.html
> 
> It seems that this problem is present only with a via usb controller,
> unfortunately i have this one:
> 
>  lspci | grep -i via
> 01:08.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 62)
> 01:08.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 62)
> 01:08.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 65)
> 
> Tell me if you need additional info.
> I'm using a 2.6.32 kernel on arch linux.
> Other relevant modprobe options:
> options dib3000mc buggy_sfn_workaround=1
> options dib7000p buggy_sfn_workaround=1
> alias net-pf-10 off
> 

This is a regression.  You have to chase links a bit, but it was
bisected down to a particular commit in
http://linuxtv.org/hg/v4l-dvb/rev/561b447ade77.
