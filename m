Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37591 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752466Ab3H3Lr2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Aug 2013 07:47:28 -0400
Date: Fri, 30 Aug 2013 13:47:24 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Dinesh Ram <dinram@cisco.com>
Cc: linux-media@vger.kernel.org, dinesh.ram@cern.ch,
	linux-input@vger.kernel.org
Subject: Re: [PATCH 4/6] si4713 : HID blacklist Si4713 USB development
 board
In-Reply-To: <228d4c6c3c411f4f5aad408d5bff88bb09a82e4e.1377861337.git.dinram@cisco.com>
Message-ID: <alpine.LNX.2.00.1308301346480.23267@pobox.suse.cz>
References: <1377862104-15429-1-git-send-email-dinram@cisco.com> <228d4c6c3c411f4f5aad408d5bff88bb09a82e4e.1377861337.git.dinram@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 30 Aug 2013, Dinesh Ram wrote:

> The Si4713 development board contains a Si4713 FM transmitter chip
> and is handled by the radio-usb-si4713 driver.
> The board reports itself as (10c4:8244) Cygnal Integrated Products, Inc.
> and misidentifies itself as a HID device in its USB interface descriptor.
> This patch ignores this device as an HID device and hence loads the custom driver.
> 
> Signed-off-by: Dinesh Ram <dinram@cisco.com>

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Please feel free to take it together with my sigoff with the rest of the 
series.

-- 
Jiri Kosina
SUSE Labs
