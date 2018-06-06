Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:60195 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932334AbeFFSso (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 6 Jun 2018 14:48:44 -0400
Date: Wed, 6 Jun 2018 19:48:42 +0100
From: Sean Young <sean@mess.org>
To: Alec Leamas <leamas.alec@gmail.com>
Cc: "Michael Kerrisk (man-opages)" <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] lirc.4: remove ioctls and feature bits which were never
 implemented
Message-ID: <20180606184841.zqgd7ohpz65ocxlk@gofer.mess.org>
References: <20180423102637.xtcjidetxo6iaslx@gofer.mess.org>
 <6b531be3-56ea-b534-3493-d64c98b3f6c5@gmail.com>
 <20180518152529.eunu6e6735z62bug@gofer.mess.org>
 <0c9ce46b-420e-6394-a40a-ca4de809c918@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c9ce46b-420e-6394-a40a-ca4de809c918@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alec,

On Sat, May 19, 2018 at 08:38:11AM +0200, Alec Leamas wrote:
> On 18/05/18 17:25, Sean Young wrote:
> > On Sun, May 06, 2018 at 12:34:53PM +0200, Michael Kerrisk (man-opages) wrote:
> >> [CCing original author of this page]
> >>
> >>
> >> On 04/23/2018 12:26 PM, Sean Young wrote:
> >>> The lirc header file included ioctls and feature bits which were never
> >>> implemented by any driver. They were removed in commit:
> >>>
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=d55f09abe24b4dfadab246b6f217da547361cdb6
> >>
> >> Alec, does this patch look okay to you?
> 
> Yes, sorry, must have missed your message. These ioctl are used to
> exist, but are no more and should be removed.

Alec, you didn't reply to the list.

Can this be merged please?

Thanks,

Sean
