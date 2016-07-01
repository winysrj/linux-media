Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:36917 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbcGAJ2C (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 1 Jul 2016 05:28:02 -0400
Date: Fri, 1 Jul 2016 10:27:59 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 15/15] [media] include: lirc: add LIRC_GET_LENGTH
 command
Message-ID: <20160701092759.GA8808@gofer.mess.org>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
 <1467360098-12539-16-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467360098-12539-16-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 01, 2016 at 05:01:38PM +0900, Andi Shyti wrote:
> Added the get length command to allow userspace users to check on
> the data length.

So what does LIRC_GET_LENGTH do? If you want to add an ioctl, it
need justification, documenting in 
Documentatoin/DocBook/media/v4l/lirc_device_interface.xml and there
should be at least one driver using it.

If you want to write a new driver which does IR transmit, it's best
to use the rc-core interface like the existing drivers and do 
not use the lirc interface. Most of the other drivers which implement
IR transmit use rc-core too.


Sean
