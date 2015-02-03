Return-path: <linux-media-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:53006 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbbBCW45 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 3 Feb 2015 17:56:57 -0500
Date: Tue, 3 Feb 2015 17:56:55 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] media:ic:Remove calls to msleep from the
 functions,ov7670_s_vflip and ov7670_s_hflip
Message-ID: <20150203175655.668b51ab@lwn.net>
In-Reply-To: <1422938417-21874-1-git-send-email-xerofoify@gmail.com>
References: <1422938417-21874-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon,  2 Feb 2015 23:40:17 -0500
Nicholas Krause <xerofoify@gmail.com> wrote:

> Removes the no longer required calls to msleep for the duration of 10 miliseconds
> in the functions,ov7670_s_vflip and ov7670_s_hflip respectfully due to no need
> for a delayed sleep of this duration in either function.

So I'm assuming you have the hardware and have verified that it still
works in the absence of these delays?

No, of course you haven't.  You don't understand why the delays are
there, or why they might have a FIXME comment on them.

Nick, surely you've understood by now that this is not the right place to
be putting your energy?  A FIXME comment almost never indicates an issue
that can be trivially resolved; it indicates something that the developer
who wrote the code didn't see a solution to at the time.  Why do you
think you can resolve those issues without understanding them, without
understanding the hardware, and without testing your work?

But then, others have tried to convey this point to you in the past; no
reason to believe I'll be any more successful.  

Please do not send this patch again.

jon
