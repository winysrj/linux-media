Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41890 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdAPKhu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 16 Jan 2017 05:37:50 -0500
Date: Mon, 16 Jan 2017 11:38:04 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Derek Robson <robsonde@gmail.com>
Cc: mchehab@kernel.org, jb@abbadie.fr, hans.verkuil@cisco.com,
        bhumirks@gmail.com, aquannie@gmail.com, claudiu.beznea@gmail.com,
        bankarsandhya512@gmail.com, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] Staging: media: bcm2048: style fix - bare use of
 unsigned
Message-ID: <20170116103804.GB2037@kroah.com>
References: <20170116070951.17988-1-robsonde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170116070951.17988-1-robsonde@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 16, 2017 at 08:09:51PM +1300, Derek Robson wrote:
> Changed macro to not pass signedness and size as seprate fields.
> This is to improve code readablity.

Not really, it reads just fine as is.  In fact, it forces you to think
about the signed vs. unsigned of the variable and doesn't let you forget
it, which seems to be the intention of the code as-is.

So I would recommend just leaving it alone.

Remember, checkpatch is a hint, you always have to use your brain when
making kernel changes, and always test-build them :)

thanks,

greg k-h
