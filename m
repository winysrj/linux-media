Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:36038 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbcGUAUA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 20:20:00 -0400
Date: Thu, 21 Jul 2016 09:19:57 +0900
From: Andi Shyti <andi.shyti@samsung.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 1/7] [media] rc-main: assign driver type during allocation
Message-id: <20160721001957.GD23521@samsunx.samsung>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-2-git-send-email-andi.shyti@samsung.com>
 <CGME20160719220453epcas1p450fba93c666c0633a8165c7daa33301b@epcas1p4.samsung.com>
 <20160719220447.GA24697@gofer.mess.org>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <20160719220447.GA24697@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > The driver type can be assigned immediately when an RC device
> > requests to the framework to allocate the device.
> > 
> > This is an 'enum rc_driver_type' data type and specifies whether
> > the device is a raw receiver or scancode receiver. The type will
> > be given as parameter to the rc_allocate_device device.
> 
> This patch is good, but it does unfortunately break all the other
> rc-core drivers, as now rc_allocate_device() needs argument. All
> drivers will need a simple change in this patch.

Yes, but for being an RFC I didn't took care of fixing
everything.

> Also note that there lots of issues that checkpatch.pl would pick
> in these series.

Some of the issues are coming from the code as it was and I
preferred to not change it. The last patch has some that need to
be fixed in the patchset.

Thanks,
Andi
