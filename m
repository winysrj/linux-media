Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54211 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab1COQMV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Mar 2011 12:12:21 -0400
Date: Tue, 15 Mar 2011 19:08:06 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Greg KH <greg@kroah.com>, security@kernel.org,
	acpi4asus-user@lists.sourceforge.net, linux-scsi@vger.kernel.org,
	rtc-linux@googlegroups.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
	open-iscsi@googlegroups.com, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [Security] [PATCH 00/20] world-writable files in sysfs and
 debugfs
Message-ID: <20110315160804.GA3380@albatros>
References: <cover.1296818921.git.segoon@openwall.com>
 <AANLkTikE-A=Fe-yRrN0opWwJGQ0f4uOzkyB3XCcEUrFE@mail.gmail.com>
 <1300155965.5665.15.camel@mulgrave.site>
 <20110315030956.GA2234@kroah.com>
 <1300189828.4017.2.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300189828.4017.2.camel@mulgrave.site>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Mar 15, 2011 at 07:50 -0400, James Bottomley wrote:
>      1. Did anyone actually check for capabilities before assuming world
>         writeable files were wrong?

I didn't check all these files as I haven't got these hardware :-)  But
as I can "chmod a+w" all sysfs files on my machine and they all become
sensible to nonroot writes, I suppose there is nothing preventing
nonroot users from writing to these buggy sysfs files.  As you can see,
there are no capable() checks in these drivers in open() or write().

>      2. Even if there aren't any capabilities checks in the implementing
>         routines, should there be (are we going the separated
>         capabilities route vs the monolithic root route)?

IMO, In any case old good DAC security model must not be obsoleted just
because someone thinks that MAC or anything else is more convenient for
him.  If sysfs is implemented via filesystem then it must support POSIX
permissions semantic.  MAC is very good in _some_ cases, but not instead
of DAC.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
