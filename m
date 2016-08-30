Return-path: <linux-media-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:45930 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932696AbcH3RPN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Aug 2016 13:15:13 -0400
Date: Tue, 30 Aug 2016 19:14:52 +0200
From: Greg KH <greg@kroah.com>
To: Wolfram Sang <wsa-dev@sang-engineering.com>
Cc: linux-usb@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 00/28] media: don't print error when allocating urb fails
Message-ID: <20160830171452.GA13250@kroah.com>
References: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1470949451-24823-1-git-send-email-wsa-dev@sang-engineering.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 11, 2016 at 11:03:36PM +0200, Wolfram Sang wrote:
> This per-subsystem series is part of a tree wide cleanup. usb_alloc_urb() uses
> kmalloc which already prints enough information on failure. So, let's simply
> remove those "allocation failed" messages from drivers like we did already for
> other -ENOMEM cases. gkh acked this approach when we talked about it at LCJ in
> Tokyo a few weeks ago.

I've taken all of these through the usb tree given the delay in response
from the media developers :)

thanks,

greg k-h
