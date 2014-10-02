Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57393 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751978AbaJBMqW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Oct 2014 08:46:22 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
	by gateway2.nyi.internal (Postfix) with ESMTP id 50FA4208F9
	for <linux-media@vger.kernel.org>; Thu,  2 Oct 2014 08:46:22 -0400 (EDT)
Date: Thu, 2 Oct 2014 05:45:24 -0700
From: Greg KH <greg@kroah.com>
To: Amber Thrall <amber.rose.thrall@gmail.com>
Cc: jarod@wilsonet.com, m.chehab@samsung.com,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] Fixed all coding style issues for
 drivers/staging/media/lirc/
Message-ID: <20141002124524.GA25203@kroah.com>
References: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412224802-28431-1-git-send-email-amber.rose.thrall@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 01, 2014 at 09:40:02PM -0700, Amber Thrall wrote:
> Fixed various coding style issues, including strings over 80 characters long and many 
> deprecated printk's have been replaced with proper methods.

Only do one thing per patch, you are doing lots of different things
here, and as Dan pointed out, you broke the build.

greg k-h
