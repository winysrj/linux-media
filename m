Return-path: <linux-media-owner@vger.kernel.org>
Received: from pequod.mess.org ([80.229.237.210]:54638 "EHLO pequod.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbaAUM22 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jan 2014 07:28:28 -0500
Date: Tue, 21 Jan 2014 12:28:26 +0000
From: Sean Young <sean@mess.org>
To: Antti =?iso-8859-1?Q?Sepp=E4l=E4?= <a.seppala@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] rc: Adding support for sysfs wakeup scancodes
Message-ID: <20140121122826.GA25490@pequod.mess.org>
References: <20140115173559.7e53239a@samsung.com>
 <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1390246787-15616-1-git-send-email-a.seppala@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 20, 2014 at 09:39:43PM +0200, Antti Seppälä wrote:
> This patch series introduces a simple sysfs file interface for reading
> and writing wakeup scancodes to rc drivers.
> 
> This is an improved version of my previous patch for nuvoton-cir which
> did the same thing via module parameters. This is a more generic
> approach allowing other drivers to utilize the interface as well.
> 
> I did not port winbond-cir to this method of wakeup scancode setting yet
> because I don't have the hardware to test it and I wanted first to get
> some comments about how the patch series looks. I did however write a
> simple support to read and write scancodes to rc-loopback module.

Doesn't the nuvoton-cir driver need to know the IR protocol for wakeup?

This is needed for winbond-cir; I guess this should be another sysfs
file, something like "wakeup_protocol". Even if the nuvoton can only
handle one IR protocol, maybe it should be exported (readonly) via
sysfs?

I'm happy to help with a winbond-cir implementation; I have the hardware.


Sean
