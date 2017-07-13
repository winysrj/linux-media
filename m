Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35934 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdGMPMx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Jul 2017 11:12:53 -0400
Date: Thu, 13 Jul 2017 17:12:49 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: smklearn <smklearn@gmail.com>
Cc: mchehab@kernel.org, alan@linux.intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] staging/atomisp: fix minor coding style warnings
Message-ID: <20170713151249.GA1451@kroah.com>
References: <1499958381-11361-1-git-send-email-smklearn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1499958381-11361-1-git-send-email-smklearn@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 13, 2017 at 08:06:21AM -0700, smklearn wrote:
> Below were the minor issues flagged by checkpatch.pl:
> - WARNING: Block comments use * on subsequent lines
> - ERROR: space prohibited after that open parenthesis '('

Don't do multiple things in the same patch please, this should be
multiple patches.

> Signed-off-by: Shy More <smklearn@gmail.com>

This name doesn't match your "From:" name in the email :(

thanks,

greg k-h
