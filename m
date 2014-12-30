Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36615 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaL3Ncw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 30 Dec 2014 08:32:52 -0500
Date: Tue, 30 Dec 2014 13:32:49 +0000
From: Sean Young <sean@mess.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	m.szyprowski@samsung.com, mchehab@osg.samsung.com,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	Hans Verkuil <hansverk@cisco.com>
Subject: Re: [RFC 1/6] cec: add new driver for cec support.
Message-ID: <20141230133249.GA1566@gofer.mess.org>
References: <1419345142-3364-1-git-send-email-k.debski@samsung.com>
 <1419345142-3364-2-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419345142-3364-2-git-send-email-k.debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 23, 2014 at 03:32:17PM +0100, Kamil Debski wrote:
> +There are still a few todo's, the main one being the remote control support
> +feature of CEC. I need to research if that should be implemented via the
> +standard kernel remote control support.

I guess a new rc driver type RC_DRIVER_CEC should be introduced (existing
types are RC_DRIVER_IR_RAW and RC_DRIVER_SCANCODE). rc_register_device()
should not register the sysfs attributes specific for IR, but register
sysfs attributes for cec like a link to the device.

In addition there should be a new rc_type protocol RC_TYPE_CEC; now 
rc_keydown_notimeout() can be called for each key press.

I guess a new keymap should exist too.

HTH

Sean
