Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbZGTUER (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 16:04:17 -0400
Date: Mon, 20 Jul 2009 13:04:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: bugzilla-daemon@bugzilla.kernel.org,
	bugme-daemon@bugzilla.kernel.org, bugzilla.kernel.org@boris64.net
Subject: Re: [Bugme-new] [Bug 13709] New: b2c2-flexcop: no frontend driver
 found for this B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
Message-Id: <20090720130412.b186e5f1.akpm@linux-foundation.org>
In-Reply-To: <bug-13709-10286@http.bugzilla.kernel.org/>
References: <bug-13709-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).


Guys, this is reportedly a post-2.6.30 regression - I'll ask Rafael to
add it to the regression tracking list.

btw, does the flexcop driver have a regular maintainer?  Or someone who
wants to volunteer?  MAINTAINERS is silent about it..

Thanks.

On Sun, 5 Jul 2009 01:36:31 GMT
bugzilla-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=13709
> 
>            Summary: b2c2-flexcop: no frontend driver found for this
>                     B2C2/FlexCop adapter w/ kernel-2.6.31-rc2
>            Product: v4l-dvb
>            Version: unspecified
>     Kernel Version: 2.6.31-rc1
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: dvb-frontend
>         AssignedTo: v4l-dvb_dvb-frontend@kernel-bugs.osdl.org
>         ReportedBy: bugzilla.kernel.org@boris64.net
>         Regression: Yes
> 
> 
> Hi kernel people!
> 
> Since kernel-2.6.31-rc1 my Technisat SkyStar2 DVB card isn't
> working anymore, because no frontend driver is found.
> The frontend 'ST STV0299 DVB-S' is compiled into the kernel
> and _did_ work fine in pre-2.6.31 kernels.
> 
> 
> [lspci]
> ...
> 05:02.0 Network controller: Techsan Electronics Co Ltd B2C2 FlexCopII DVB chip
> / Technisat SkyStar2 DVB card (rev 02)
> [/lspci]
> 
> [dmesg]
> Working kernel-2.6.30.1:
> ------------------------
> ...
> b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded
> successfully
> b2c2_flexcop_pci 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> b2c2-flexcop: MAC address = 00:d0:d7:0f:30:58
> b2c2-flexcop: found 'ST STV0299 DVB-S' .
> b2c2-flexcop: initialization of 'Air2PC/AirStar 2 ATSC 3rd generation (HD5000)'
> at the 'PCI' bus controlled by a 'FlexCopIIb' complete
> ...
> 
> Non-working kernel-2.6.31-rc:
> ------------------------
> ...
> b2c2-flexcop: B2C2 FlexcopII/II(b)/III digital TV receiver chip loaded
> successfully
> b2c2_flexcop_pci 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
> b2c2-flexcop: MAC address = 00:d0:d7:0f:30:58
> b2c2-flexcop: no frontend driver found for this B2C2/FlexCop adapter
> b2c2_flexcop_pci 0000:05:02.0: PCI INT A disabled
> ...
> [/dmesg]
> 
> 
> I'll attach full dmesg+lspci.
> Please feel free to contact me if you need more infos.
> Thank you in advance ;)
> 
> -- 
> Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug.
