Return-path: <linux-media-owner@vger.kernel.org>
Received: from lider.uludag.org.tr ([193.140.100.216]:51562 "EHLO
	lider.pardus.org.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbZJXHte (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Oct 2009 03:49:34 -0400
Message-ID: <4AE2B18A.5080507@pardus.org.tr>
Date: Sat, 24 Oct 2009 10:49:30 +0300
From: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: uvcvideo causes ehci_hcd to halt
References: <Pine.LNX.4.44L0.0910231809290.31680-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910231809290.31680-100000@netrider.rowland.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Stern wrote:
> Okay, that proves this really is a timing bug in the hardware.  But we
> can't go around putting 2-millisecond delays in the kernel!  Maybe you
> can test to see if smaller delays will fix the problem.  If 50
> microseconds or less doesn't work then it will be necessary to add a
> new timer to ehci-hcd.
>   

Okay I'll check with smaller values there but I couldn't get the meaning
of "if 50 us or less doesn't work then it will be necessary to add a new
timer to ehci-hcd".

Thanks.

