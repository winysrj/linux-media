Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:50039 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757283Ab2JQPC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Oct 2012 11:02:28 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so7209545pad.19
        for <linux-media@vger.kernel.org>; Wed, 17 Oct 2012 08:02:28 -0700 (PDT)
Date: Wed, 17 Oct 2012 08:02:17 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [Q] reprobe deferred-probing drivers
Message-ID: <20121017150217.GA29424@kroah.com>
References: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210171021060.7402@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 17, 2012 at 10:27:36AM +0200, Guennadi Liakhovetski wrote:
> Hi
> 
> I've got a situation, for which I currently don't have a (good) solution.
> 
> Let's say device A depends on device B and as long as B hasn't probed, A 
> requests deferred probing. Now B probes, which causes A to also succeed 
> its probing. Next we want to remove B, say, by unloading its driver. A has 
> to go back into "deferred-probing" state. How do we do it? This can be 
> achieved by unloading B's driver and loading again. Essentially, we have 
> to use the sysfs "unbind" and then the "bind" attributes. But how do we do 
> this from the kernel? Shall we export driver_bind() and driver_unbind()?

No, no driver should ever have to mess with that at all, it is up to the
bus to do this.  Do you have a pointer to the code you are concerned
about?

greg k-h
