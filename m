Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51692 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751193AbdGMOZ0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 10:25:26 -0400
Date: Thu, 13 Jul 2017 16:25:22 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: smklearn <smklearn@gmail.com>
Cc: mchehab@kernel.org, alan@linux.intel.com,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging drivers fixed coding style error
Message-ID: <20170713142522.GB25779@kroah.com>
References: <1499955476-10445-1-git-send-email-smklearn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499955476-10445-1-git-send-email-smklearn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 07:17:56AM -0700, smklearn wrote:
> Fixed coding style error flagged checkpatch.pl:
> 	- ERROR: space prohibited after that open parenthesis '('
> 	- WARNING: Block comments use * on subsequent lines
> 
> Signed-off-by: Shy More <smklearn@gmail.com>
> 
> Output after fixing coding style issues:
> 
> $KERN/scripts/checkpatch.pl -f
> 	./media/atomisp/pci/atomisp2/css2400/runtime/isys/src/ibuf_ctrl_rmgr.c
> 
> total: 0 errors, 0 warnings, 141 lines checked

Please don't put anything below the Signed-off-by: line, you will note
that all other commits are written that way.

Also, your subject: needs a lot of work, again, look at other commits
for the driver you are modifying to get it right.

good luck!

greg k-h
