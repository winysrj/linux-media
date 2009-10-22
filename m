Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.pardus.org.tr ([193.140.100.216]:59424 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494AbZJVK0Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 06:26:16 -0400
Message-ID: <4AE03477.1010902@pardus.org.tr>
Date: Thu, 22 Oct 2009 13:31:19 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910212131560.24481-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910212131560.24481-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote On 22-10-2009 04:36:
> On Thu, 22 Oct 2009, Laurent Pinchart wrote:
>   

Here's the outputs from /sys/kernel/debug/usb/ehci:

periodic:
----------------
size = 1024
   1:  qh1024-0001/f6ffe280 (h2 ep2 [1/0] q0 p8)

registers:
----------------
bus pci, device 0000:00:1d.7
EHCI Host Controller
EHCI 1.00, hcd state 0
ownership 00000001
SMI sts/enable 0x80080000
structural params 0x00104208
capability params 0x00016871
status 6008 Periodic Recl FLR
command 010000 (park)=0 ithresh=1 period=1024 HALT
intrenable 00
uframe 2fa0
port 1 status 001000 POWER sig=se0
port 2 status 001000 POWER sig=se0
port 3 status 001000 POWER sig=se0
port 4 status 001000 POWER sig=se0
port 5 status 001005 POWER sig=se0 PE CONNECT
port 6 status 001005 POWER sig=se0 PE CONNECT
port 7 status 001000 POWER sig=se0
port 8 status 001000 POWER sig=se0
irq normal 60 err 0 reclaim 16 (lost 0)
complete 60 unlink 1
