Return-path: <linux-media-owner@vger.kernel.org>
Received: from studserv.stud.uni-hannover.de ([130.75.176.2]:41602 "EHLO
	studserv.stud.uni-hannover.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757065AbZD3L4x (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Apr 2009 07:56:53 -0400
Message-ID: <20090430135641.91441beqhfo80o4k@www.stud.uni-hannover.de>
Date: Thu, 30 Apr 2009 13:56:41 +0200
From: Soeren.Moch@stud.uni-hannover.de
To: linux-media@vger.kernel.org
Subject: Re: Nova-T 500 does not survive reboot
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Apr 29 22:42:41 favia kernel: [   72.272045] ehci_hcd 0000:07:01.2:  
> force halt; handhake ffffc20000666814 00004000 00000000 -> -110
> [...]
> Do you know if the issue is the same with a Nova-TD stick? If it is,
> then I could be able to use debugging as an excuse to buy one, and then
> add 2 tuners to the system when all is done :o)

I had the same "ehci_hcd force halt" error when I was debugging the
Nova-TD dual-stream-switchon-problem:
http://www.mail-archive.com/linux-media@vger.kernel.org/msg04643.html

Reducing the urb count to 1 (as included in the patch) solved the
"ehci_hcd force halt" issue for me.

S:oren



