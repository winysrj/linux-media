Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:51292 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752975Ab1JJWi5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Oct 2011 18:38:57 -0400
References: <201110101552.35977.lyle@sent.com>
In-Reply-To: <201110101552.35977.lyle@sent.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: saa7164[0]: can't get MMIO memory @ 0x0 or 0x0
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 10 Oct 2011 18:38:32 -0400
To: Lyle Sigurdson <lyle@sent.com>, linux-media@vger.kernel.org
Message-ID: <e8dafcd9-eb83-4f88-a936-0b96ee350bb4@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Lyle Sigurdson <lyle@sent.com> wrote:

>Hi all, and thanks for all your work.  But, I'm having a problem.
>
>Tuner card: Hauppauge! HVR-2250
>Mainboard: MSNV-939
>Distro: Slackware64 13.1 (kernel 2.6.33.4)
>
>When I modprobe saa7164:
>bowman kernel: saa7164[0]: can't get MMIO memory @ 0x0 or 0x0
>bowman kernel: CORE saa7164[0] No more PCIe resources for subsystem:
>0070:8851
>bowman kernel: saa7164: probe of 0000:04:00.0 failed with	error -22
>
>It turns out that pci_resource_start and pci_resource_len are both
>returning 
>null.
>
>What could be the cause of this?  Is there a solution? 
>
>   Lyle.	
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

Try upping your kernel's vmalloc space

1. cat /proc/meminfo | grep -i vmalloc

Observe the vmalloctotal you have and convert from kB to MB.

2. Add a vmalloc=NNN to your kernel commandline on boot.  NNN should be the number of megabytes of address space to allow.  Try 64 or 128 megabytes more than your current setting.

Regards,
Andy 
