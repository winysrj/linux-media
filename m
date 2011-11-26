Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpout04.highway.telekom.at ([195.3.96.117]:38110 "EHLO
	email.aon.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751956Ab1KZObu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 26 Nov 2011 09:31:50 -0500
Message-ID: <4ED0F84F.7000201@aon.at>
Date: Sat, 26 Nov 2011 15:31:43 +0100
From: Johann Klammer <klammerr@aon.at>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: PROBLEM: EHCI disconnects DVB & HDD
References: <4ECEFBA3.7010808@aon.at> <Pine.LNX.4.44L0.1111251022100.1951-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1111251022100.1951-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> Can you put the usbmon trace on a web server like pastebin.com?

Pastebin chickens out with: `413 Request Entity Too Large`
The dump is around 2.5 Mib. Most of it probably the dvb stream.
Have now recompiled the kernel with more debug output and will try to
reproduce the problem. From what I see by now, the HDD behaves flaky too.
