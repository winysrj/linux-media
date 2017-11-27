Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60080 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751381AbdK0MVV (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Nov 2017 07:21:21 -0500
Date: Mon, 27 Nov 2017 13:21:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/3] media: staging: atomisp: defined as static some
 const arrays which don't need external linkage.
Message-ID: <20171127122125.GB8561@kroah.com>
References: <20171127113054.27657-1-jeremy@azazel.net>
 <20171127113054.27657-3-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171127113054.27657-3-jeremy@azazel.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 27, 2017 at 11:30:53AM +0000, Jeremy Sowden wrote:
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  .../isp/kernels/eed1_8/ia_css_eed1_8.host.c        | 24 +++++++++++-----------
>  1 file changed, 12 insertions(+), 12 deletions(-)

I can never take patches without any changelog text, and so no one
should write them that way :)

Try it again?

thanks,

greg k-h
