Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44064 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750997AbdBFIad (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 6 Feb 2017 03:30:33 -0500
Date: Mon, 6 Feb 2017 09:30:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Stevenson <linux-media@destevenson.freeserve.co.uk>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Eric Anholt <eric@anholt.net>, devel@driverdev.osuosl.org,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] staging: Import the BCM2835 MMAL-based V4L2 camera
 driver.
Message-ID: <20170206083032.GA23574@kroah.com>
References: <20170127215503.13208-1-eric@anholt.net>
 <20170127215503.13208-2-eric@anholt.net>
 <20170203165909.65aa0e35@vento.lan>
 <f68d1a05-60e2-48eb-52c1-401cfeccd45e@destevenson.freeserve.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f68d1a05-60e2-48eb-52c1-401cfeccd45e@destevenson.freeserve.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Feb 05, 2017 at 10:15:21PM +0000, Dave Stevenson wrote:
> Newbie question: if this has already been merged to staging, where am I
> looking for the relevant tree to add patches on top of?
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git branch
> staging-next?

Yes, that is the correct place.

thanks,

greg k-h
