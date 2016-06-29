Return-path: <linux-media-owner@vger.kernel.org>
Received: from etezian.org ([198.101.225.253]:54895 "EHLO mail.etezian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751376AbcF2X60 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Jun 2016 19:58:26 -0400
Date: Thu, 30 Jun 2016 08:35:13 +0900
From: Andi Shyti <andi@etezian.org>
To: Sean Young <sean@mess.org>
Cc: Andi Shyti <andi.shyti@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH 15/15] include: lirc: add set length and frequency ioctl
 options
Message-ID: <20160629233513.GA1257@jack.zhora.eu>
References: <1467206444-9935-1-git-send-email-andi.shyti@samsung.com>
 <1467206444-9935-16-git-send-email-andi.shyti@samsung.com>
 <20160629224646.GA30214@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160629224646.GA30214@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

> > For that we need to have more control on the device frequency to
> > set (which is a new concept fro LIRC) and we also need to provide
> > to userspace, as feedback, the values of the used frequency and
> > length.
> 
> Please can you elaborate on what exactly you mean by frequency and
> length.
> 
> The carrier frequency can already be set with LIRC_SET_SEND_CARRIER.

yes, I mean carrier's frequency. I didn't understand that
LIRC_SET_SEND_CARRIER was related to the frequency.

> > Add the LIRC_SET_LENGTH, LIRC_GET_FREQUENCY and
> > LIRC_SET_FREQUENCY ioctl commands in order to allow the above
> > mentioned operations.
> 
> You're also adding ioctls without any drivers implementing them
> unless I missed something.

You're right; the first idea was to submit also the device
driver, but then I decided to keep it separate from this
patchset.
Anyway, we can drop this one (it's the last of the series) and,
in case it will be needed after the above comment, I will re-send
it with the driver.

Thanks,
Andi
