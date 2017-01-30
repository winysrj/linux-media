Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:58207 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750889AbdA3Rbe (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 30 Jan 2017 12:31:34 -0500
Date: Mon, 30 Jan 2017 17:31:31 +0000
From: Sean Young <sean@mess.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH RESEND] staging: media: lirc: use new parport device model
Message-ID: <20170130173131.GA16811@gofer.mess.org>
References: <1484960154-6355-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1484960154-6355-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Jan 21, 2017 at 12:55:54AM +0000, Sudip Mukherjee wrote:
> From: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> 
> Modify lirc_parallel driver to use the new parallel port device model.
> 
> Signed-off-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>
> ---
> 
> Resending after more than one year.
> Prevoius patch is at https://patchwork.kernel.org/patch/7883591/

Since noone ported lirc_parallel to rc-core, the lirc_parallel staging
driver has been droppped from the current media tree.

I have ported a few other lirc drivers to rc-core but I never found
anyone using lirc_parallel or the hardware itself.


Sean
