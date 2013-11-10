Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub0-omc2-s14.dub0.hotmail.com ([157.55.1.153]:23961 "EHLO
	dub0-omc2-s14.dub0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758577Ab3KJBiW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Nov 2013 20:38:22 -0500
Message-ID: <DUB113-W22427F964CF72CDA526865A7FC0@phx.gbl>
From: Tom - <xx_unknown_xx@hotmail.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: LIRC Kernel Bug (mceusb device)
Date: Sun, 10 Nov 2013 01:38:21 +0000
In-Reply-To: <DUB113-W114E7C7135E19D91F22E1B4A7FD0@phx.gbl>
References: <DUB113-W92F4F71262B8415945D78CA7FD0@phx.gbl>,<DUB113-W88119E2310F9258F5E067BA7FD0@phx.gbl>,<DUB113-W114E7C7135E19D91F22E1B4A7FD0@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=64631

Bug ID: 64631
Summary: LIRC Kernel bug (mceusb device)
Product: Drivers
Version: 2.5
Kernel Version: 3.12.0
Hardware: x86-64
OS: Linux
Tree: Mainline
Status: NEW
Severity: high
Priority: P1
Component: USB
Assignee: greg@kroah.com
Reporter: xx_unknown_xx@hotmail.com
Regression: No

BUG: unable to handle kernel NULL pointer dereference

My philips MCE USB receiver (mceusb device) does not work with Lirc and causes
a kernel error. System is ubuntu 12.04-mini 64 bit.

Please add me in CC. 		 	   		  