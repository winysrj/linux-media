Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:33670 "EHLO
	lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbbJTGZM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2015 02:25:12 -0400
Message-ID: <5625DDCA.2040203@xs4all.nl>
Date: Tue, 20 Oct 2015 08:23:06 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ran Shalit <ranshalit@gmail.com>, linux-media@vger.kernel.org
Subject: Re: PCIe capture driver
References: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
In-Reply-To: <CAJ2oMhJinTjko5N+JdCYrenxme7xUJ_LudwtUy4TJMi1RD6Xag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/19/2015 10:26 PM, Ran Shalit wrote:
> Hello,
> 
> When writing a device driver for  capturing video coming from PCIe,
> does it need to be used as v4l device (video for linux) , ?

Yes. If you don't then 1) you will never be able to upstream the driver,
2) any application that wants to use your driver will need custom code to
talk to your driver, 3) it will be a lot more work to write the driver
since you can't use the V4L2 kernel frameworks it provides or ask for
help.

Basically, by deciding to reinvent the wheel you're screwing over your
customers and yourself.

Here is a nice PCI(e) template driver that you can use as your starting
point: Documentation/video4linux/v4l2-pci-skeleton.c

Regards,

	Hans
