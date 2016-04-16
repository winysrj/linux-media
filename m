Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45062 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbcDPAA3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Apr 2016 20:00:29 -0400
Date: Fri, 15 Apr 2016 17:00:25 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Thaissa Falbo <thaissa.falbo@gmail.com>
Subject: Re: [PATCH for 4.6] davinci_vpfe: Revert "staging: media:
 davinci_vpfe: remove,unnecessary ret variable"
Message-ID: <20160416000025.GA17263@kroah.com>
References: <5710D752.4040208@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5710D752.4040208@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 15, 2016 at 01:58:10PM +0200, Hans Verkuil wrote:
> This reverts commit afa5d19a2b5fbf0bbcce34f3613bce2bc9479bb7.
> 
> This patch is completely bogus and messed up the code big time.
> 
> I'm not sure what was intended, but this isn't it.
> 
> Cc: Thaissa Falbo <thaissa.falbo@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> 
> Greg, this patch was never seen by us. Can you redirect patches for staging/media
> to the linux-media mailinglist? We'd like to stay on top of what is happening there.

Ugh, you are right, sorry about this.  I'll try to forward this stuff
onward, my fault.

greg k-h
