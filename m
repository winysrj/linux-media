Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53906 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755117Ab3BVDcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Feb 2013 22:32:55 -0500
References: <CADUyVi=ztr2uF8jb6urSMtJ0yKRFrLWHrCHYmgKX+-9BTRsRFQ@mail.gmail.com>
In-Reply-To: <CADUyVi=ztr2uF8jb6urSMtJ0yKRFrLWHrCHYmgKX+-9BTRsRFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 3.7/3.8 kernel won't boot with Hauppauge pvr-150
From: Andy Walls <awalls@md.metrocast.net>
Date: Thu, 21 Feb 2013 22:32:58 -0500
To: Ron Andreasen <dlanor78@gmail.com>, linux-media@vger.kernel.org
Message-ID: <ab89dced-9718-4e81-a2c9-1581e0528eb9@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ron Andreasen <dlanor78@gmail.com> wrote:

>I've been having trouble getting distros that have any kernel above the
>3.5
>series to boot (only tried 64-bit). I get a black screen with a bunch
>of
>text and the boot process goes no further. I don't know if this is
>usually
>okay, but I'm posting a link to a picture I took of my monitor with my
>cell
>phone. It's a bit blurry but hopefully it's still okay:
>
>http://imgur.com/viP1kWk,3YJXKbG
>
>The distros I've had this problem in are Kubuntu (I've tried several of
>the
>daily builds) which uses the 3.8.? (can't boot far enough to see)
>kernel,
>Cinnarch which uses the 3.7.3 kernel, and openSUSE 12.3 and I don't
>remember what version of the kernel that one used.
>
>My processor is a AMD Phenom(tm) 9850 Quad-Core Processor with all four
>cores unlocked. The output of lspci -vvv (in Kubuntu 12.10) can be
>found at
>[redacted]. I have 6 gb of ddr2 ram. Not sure
>what
>else I need to include so if you need more please let me know.
>
>When I was testing out Cinnarch I was able to boot by taking the
>Hauppauge
>PVR-150 out of the computer so I know for sure that's the hardware that
>was
>causing the problem. I haven't found any other way to boot with the
>card
>in. I tried different boot options. The ones I can remember are
>nomodeset
>and noacpi (or something like that). The distro I'm currently using is
>Kubuntu 12.10 and the kernel as of this writing is 3.5.0-24

For now rename the ivtv-alsa.ko module to ivtv-alsa.ko.orig 

If that doesn't allow a normal boot, blacklist the ivtv module in /etc/modprobe.d/blacklist.  That way your machine will at least boot.

It looks like the ivtv module is failing to initialize, starts to unload, and in the process of unloading, the cleanup path causes an Ooops.  

I should have time to look closer at it this weekend.

Regards,
Andy
