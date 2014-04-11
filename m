Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:2811 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaDKJpd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 05:45:33 -0400
Message-ID: <5347B9A3.2050301@xs4all.nl>
Date: Fri, 11 Apr 2014 11:45:07 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson - IT <it@sca-uk.com>, linux-media@vger.kernel.org
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com>
In-Reply-To: <5347B132.6040206@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/11/2014 11:09 AM, Steve Cookson - IT wrote:
> So I'm back to the Hauppauge ImpactVCB-e 01385.
> 
> Apparently it's fully supported by the current Linux kernel:
> 
> Model                 Standard Interface     Supported     Comments
> ImpactVCB-e     Video PCIe                 ✔ Yes                 No 
> tuners, only video-in. S-Video Capture works with kernel 3.5.0 (Ubuntu 
> 12.10).
> 
> http://linuxtv.org/wiki/index.php/Hauppauge.
> 
> So is this a typo or have I just encountered an install problem?

I have serious doubts whether this is actually supported. I see no mention of
that board in the cx23885 driver. I wonder if there is a mixup between the
ImpactVCB (which IS supported) and the ImpactVCB-e.

> 
>> When I plug in my 01385 I get the same old stuff in dmseg, ie:
>>
>> cx23885 driver version 0.0.3 loaded
>> [ 8.921390] cx23885[0]: Your board isn't known (yet) to the driver.
>> [ 8.921390] cx23885[0]: Try to pick one of the existing card configs via
>> [ 8.921390] cx23885[0]: card=<n> insmod option. Updating to the latest
>> [ 8.921390] cx23885[0]: version might help as well.
>> [ 8.921393] cx23885[0]: Here is a list of valid choices for the 
>> card=<n> insmod option:

You can try some of the existing cards: one  of 1, 2, 3, 6, 20, 24, 32 might
just work. Look in drivers/media/pci/cx23885/cx23885-cards.c.

Each card definition there defines the inputs that are supported by the card.
There is no perfect match, so you will have to change inputs to see which
input produces an image. You can also add a card definition yourself and
just fiddle around with the vmux/amux/gpio values to see which work. It is
probably something close to what is used by other Hauppauge cards.

>>
>> Etc.
> Would the daily build resolve this?  I haven't installed it on this test 
> system, but I'm never clear when I should install it or whether I should 
> just download a single driver from somewhere.

There is no point in using the daily build. The cx23885 driver hasn't been
updated in a long time.

Regards,

	Hans
