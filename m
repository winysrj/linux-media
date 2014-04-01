Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48938 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaDASzT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 14:55:19 -0400
Received: by mail-pb0-f48.google.com with SMTP id md12so10243967pbc.21
        for <linux-media@vger.kernel.org>; Tue, 01 Apr 2014 11:55:19 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Writing a HDMI-CEC device driver for the IT66121
From: Sriakhil Gogineni <sriakhil.gogineni@gmail.com>
In-Reply-To: <533A8708.6030302@xs4all.nl>
Date: Tue, 1 Apr 2014 11:55:19 -0700
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <3F599A20-E00D-4C0A-B125-B1428774BCFE@gmail.com>
References: <4E127074-D400-4334-874D-7A67CF2D42EB@gmail.com> <533A8708.6030302@xs4all.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the detailed response. As, much as I would love to have a robust, fully functioning implementation for v1, I  think it might be a a bit of 'over-optimization' to write the complete spec into the driver from the beginning.

The question I ask myself is, "how can we get it mainlined quickly?" I'm not sure of the answer but I would like implement and test basic features of HDMI-CEC and then add in the more advanced fun stuff ;)

So I'm trying to test out CEC on the hardware I have. Making clean interfaces would allow for adaptable between 4l2 devices, drm/kms devices and hardware. My question is how can I connect to / test on the hardware I have?

Best,
Sri

On Apr 1, 2014, at 2:29 AM, Hans Verkuil <hverkuil@xs4all.nl> wrote:

> Hi Sri,
> 
> On 03/31/14 23:12, Sriakhil Gogineni wrote:
>> Hi,
>> 
>> I'm trying to write a HDMI-CEC driver for the Radxa Rock
>> (Specification - Radxa). I am coming from a software background and
>> have found libcec and am looking at other implementation.
>> 
>> I'm wondering how to connect the hardware and software pieces under
>> Linux / Android.
>> 
>> I'm not sure if I need to find out what /dev/ its exposed under via
>> the device tree or determine which register is used from the data
>> sheet?
>> 
>> Any advice / tips / pointers would be helpful.
> 
> There is currently no kernel CEC support available. What makes cec
> complex is 1) the CEC specification is horrible :-) and 2) a proper cec
> implementation has to be able to take care of v4l2 devices, drm/kms devices
> and usb dongles. In addition, at least some of the CEC handling has to
> take place in the kernel in order to handle the audio return channel,
> suspend commands, hotplug-over-CEC and such advanced features.
> 
> I have been working on this, but it is a background project and I never
> found the time to finish it.
> 
> My latest code is available here:
> 
> http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cec
> 
> but it needs more work to make this ready for prime time.
> 
> It works, but it needs cleanup and cec_claim_log_addrs() needs improvement.
> Particularly when called from a driver: this needs to be done in non-
> blocking mode which isn't yet working (in blocking mode the driver would
> block for an unacceptable amount of time).
> 
> If you or someone else would be willing to take over, I would have no
> objections. I have no idea when I might have time to continue work on
> this.
> 
> Regards,
> 
> 	Hans

