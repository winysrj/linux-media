Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1512 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDAJbE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 05:31:04 -0400
Message-ID: <533A8708.6030302@xs4all.nl>
Date: Tue, 01 Apr 2014 11:29:44 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sriakhil Gogineni <sriakhil.gogineni@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: Writing a HDMI-CEC device driver for the IT66121
References: <4E127074-D400-4334-874D-7A67CF2D42EB@gmail.com>
In-Reply-To: <4E127074-D400-4334-874D-7A67CF2D42EB@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sri,

On 03/31/14 23:12, Sriakhil Gogineni wrote:
> Hi,
> 
> I'm trying to write a HDMI-CEC driver for the Radxa Rock
> (Specification - Radxa). I am coming from a software background and
> have found libcec and am looking at other implementation.
> 
> I'm wondering how to connect the hardware and software pieces under
> Linux / Android.
> 
> I'm not sure if I need to find out what /dev/ its exposed under via
> the device tree or determine which register is used from the data
> sheet?
> 
> Any advice / tips / pointers would be helpful.

There is currently no kernel CEC support available. What makes cec
complex is 1) the CEC specification is horrible :-) and 2) a proper cec
implementation has to be able to take care of v4l2 devices, drm/kms devices
and usb dongles. In addition, at least some of the CEC handling has to
take place in the kernel in order to handle the audio return channel,
suspend commands, hotplug-over-CEC and such advanced features.

I have been working on this, but it is a background project and I never
found the time to finish it.

My latest code is available here:

http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cec

but it needs more work to make this ready for prime time.

It works, but it needs cleanup and cec_claim_log_addrs() needs improvement.
Particularly when called from a driver: this needs to be done in non-
blocking mode which isn't yet working (in blocking mode the driver would
block for an unacceptable amount of time).

If you or someone else would be willing to take over, I would have no
objections. I have no idea when I might have time to continue work on
this.

Regards,

	Hans
