Return-path: <linux-media-owner@vger.kernel.org>
Received: from fold.natur.cuni.cz ([195.113.57.32]:52495 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752319Ab3AXTVY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Jan 2013 14:21:24 -0500
Message-ID: <510189B1.606@fold.natur.cuni.cz>
Date: Thu, 24 Jan 2013 20:21:21 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
MIME-Version: 1.0
To: Chris Clayton <chris2553@googlemail.com>
CC: linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 3.8.0-rc4+ - Oops on removing WinTV-HVR-1400 expresscard TV Tuner
References: <51016937.1020202@googlemail.com>
In-Reply-To: <51016937.1020202@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Chris,
  try to include in kernel only acpiphp and omit pciehp. Don't use modules but include
them statically. And try, in addition, check whether "pcie_aspm=off" in grub.conf helped.

  The best would if you subscribe to linux-pci, and read my recent threads
about similar issues I had with express cards with Dell Vostro 3550. Further, there is
a lot of changes to PCI hotplug done by Yingahi Liu and Rafael Wysockij, just browse the
archives of linux-pci and see the pacthes and the discussion.
Martin

Chris Clayton wrote:
> Hi,
> 
> I've today taken delivery of a WinTV-HVR-1400 expresscard TV Tuner and got an Oops when I removed from the expresscard slot in my laptop. I will quite understand if the response to this report is "don't do that!", but in that case, how should one remove one of these cards?
> 
> I have attached three files:
> 
> 1. the dmesg output from when I rebooted the machine after the oops. I have turned debugging on in the dib700p and cx23885 modules via modules options in /etc/modprobe.d/hvr1400.conf;
> 
> 2. the .config file for the kernel that oopsed.
> 
> 3. the text of the oops message. I've typed this up from a photograph of the screen because the laptop was locked up and there was nothing in the log files. Apologies for any typos, but I have tried to be careful.
> 
> Assuming the answer isn't don't do that, let me know if I can provide any additional diagnostics, test any patches, etc. Please, however, cc me as I'm not subscribed.
> 
> Chris
