Return-path: <linux-media-owner@vger.kernel.org>
Received: from webmail.icp-qv1-irony-out2.iinet.net.au ([203.59.1.151]:34579
	"EHLO webmail.icp-qv1-irony-out2.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753686AbZBWWtF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2009 17:49:05 -0500
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
From: "sonofzev@iinet.net.au" <sonofzev@iinet.net.au>
To: linux-media@vger.kernel.org
Subject: running multiple DVB cards successfully.. what do I need to know?? (major and minor numbers??)
Reply-To: sonofzev@iinet.net.au
Date: Tue, 24 Feb 2009 07:49:00 +0900
Message-Id: <37843.1235429340@iinet.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




Hi All 

Some of you may have read some of my posts about an "incorrect firmware readback"
message appearing in my dmesg, shortly after a tuner was engaged. 

I have isolated this problem, but the workaround so far has not been pretty. 
On a hunch I removed my Dvico Fusion HDTV lite card from the system, running now
only with the Dvico Fusion Dual Express. 

The issue has gone, I am not getting the kdvb process hogging cpu cycles and this
message has stopped. 

I had tried both letting the kernel (or is it udev) assign the major and minor
numbers and I had tried to manually set them via modprobe.conf (formerly
modules.conf, I don't know if this is a global change or specific to Gentoo).... 

I had the major number the same for both cards, with a separate minor number for
each of the three tuners, this seems to be the same. 

Is this how I should be setting up for 2 cards or should I be using some other
type of configuration. 

cheers

Allan 
