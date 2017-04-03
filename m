Return-path: <linux-media-owner@vger.kernel.org>
Received: from jake.logic.tuwien.ac.at ([128.130.175.117]:48208 "EHLO
        jake.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751803AbdDCQDl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 3 Apr 2017 12:03:41 -0400
Date: Mon, 3 Apr 2017 18:03:33 +0200
From: Ingo Feinerer <feinerer@logic.at>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org
Subject: Re: Conditional sys/sysmacros.h inclusion
Message-ID: <20170403160333.GA53237@t450.itgeo.fhwn.ac.at>
References: <20170313115838.GA28761@t450.itgeo.fhwn.ac.at>
 <8429768f-9edc-e701-5fe2-0ca7f6d168ee@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8429768f-9edc-e701-5fe2-0ca7f6d168ee@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Apr 03, 2017 at 11:28:30AM +0200, Hans Verkuil wrote:
> I was about to commit this when I noticed that you didn't add a
> Signed-off-by line in your email. We need that for v4l-utils.
> 
> See section 11 here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?id=HEAD
> 
> for details about that tag.
> 
> Just reply with your Signed-off-by and I'll merge this patch.

Thanks for the pointer and merging the patch!

Signed-off-by: Ingo Feinerer <feinerer@logic.at>
