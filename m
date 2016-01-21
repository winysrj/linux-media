Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:34392 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965648AbcAURni (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 12:43:38 -0500
Subject: Re: Debugging v4l-pci driver without real HW
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
References: <CAJ2oMh+tSJX4FSFduRG-p36YHxDBqi3c8hd0JDLJttWN9b2w-Q@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A118C5.2060804@xs4all.nl>
Date: Thu, 21 Jan 2016 18:43:33 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ2oMh+tSJX4FSFduRG-p36YHxDBqi3c8hd0JDLJttWN9b2w-Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/21/2016 06:03 PM, Ran Shalit wrote:
> Hello,
> 
> I would like to ask if it is possible in some way or other to start
> debugging the pci driver without the real hardware available.
> I've decided to use solo6x10 driver (I hope it's a good decision) as a
> template for our coming hardware.
> The thing is that I don't have hardware yet. I expect to purchase it
> in the coming days, but wanted to start debugging code even before
> that.
> Is it possible in some way or other to make the driver think that the
> pci board is connected to pci HW ?

The only way I can think of is to plug in some other pci card, make sure
the driver for that card isn't compiled in and instead use that pci vendor
and device ID for your driver. That way you can load it. You can setup
most of the skeleton code: register video nodes, even setting up vb2, as
long as you don't actually try to write/read to/from PCI registers since
obviously it is the wrong hardware.

But at least that way you can create all the non-hw dependent parts of
the driver.

Apparently you can fake a PCI device as well:
http://www.linuxquestions.org/questions/linux-kernel-70/how-to-emulate-a-pci-device-in-linux-901554/

but I think that's overkill for this.

Regards,

	Hans
