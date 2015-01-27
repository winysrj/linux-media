Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:36280 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752056AbbA0OPo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2015 09:15:44 -0500
Message-ID: <54C79D47.9090609@xs4all.nl>
Date: Tue, 27 Jan 2015 15:14:31 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
Subject: Re: setting volatile v4l2-control
References: <54C79385.2050702@samsung.com>
In-Reply-To: <54C79385.2050702@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/27/15 14:32, Jacek Anaszewski wrote:
> While testing the LED / flash API integration patches
> I noticed that the v4l2-controls marked as volatile with
> V4L2_CTRL_FLAG_VOLATILE flag behave differently than I would
> expect.
> 
> Let's consider following use case:
> 
> There is a volatile V4L2_CID_FLASH_INTENSITY v4l2 control with
> following constraints:
> 
> min: 1
> max: 100
> step: 1
> def: 1
> 
> 1. Set the V4L2_CID_FLASH_INTENSITY control to 100.
>     - as a result s_ctrl op is called
> 2. Set flash_brightness LED sysfs attribute to 10.
> 3. Set the V4L2_CID_FLASH_INTENSITY control to 100.
>     - s_ctrl op isn't called
> 
> This way we are unable to write a new value to the device, despite
> that the related setting was changed from the LED subsystem level.
> 
> I would expect that if a control is marked volatile, then
> the v4l2-control framework should by default call g_volatile_ctrl
> op before set and not try to use the cached value.
> 
> Is there some vital reason for not doing this?

It's rather strange to have a writable volatile control. The semantics
of this are ambiguous and I don't believe we have ever used such controls
before.

Actually, the commit log of this patch (never merged) gives some
background information about this:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/commit/?h=volatilefix

It's never been merged because I have never been certain how to handle
such controls. Why do you have such controls in the first place? What
is it supposed to do?

Regards,

	Hans
