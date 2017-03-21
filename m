Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40765 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751648AbdCUHGh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 21 Mar 2017 03:06:37 -0400
Date: Tue, 21 Mar 2017 08:05:54 +0100
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 06/24] atomisp: kill another define
Message-ID: <20170321070554.GA15685@kroah.com>
References: <149002068431.17109.1216139691005241038.stgit@acox1-desk1.ger.corp.intel.com>
 <149002076867.17109.6183542354794542722.stgit@acox1-desk1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149002076867.17109.6183542354794542722.stgit@acox1-desk1.ger.corp.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Mar 20, 2017 at 02:39:38PM +0000, Alan Cox wrote:
> We don't need an ifdef for the sake of 8-12 bytes. This undoes the ifdef added by
> fde469701c7efabebf885e785edf367bfb1a8f3f. Instead turn it into a single const string
> array at a fixed location thereby saving even more memory.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
>  .../staging/media/atomisp/pci/atomisp2/hmm/hmm.c   |   23 +++++++++-----------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 

This patch didn't apply to my tree, can you rebase it and resend?

thanks,

greg k-h
