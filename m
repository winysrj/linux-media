Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54032 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753890AbdC2HjX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 29 Mar 2017 03:39:23 -0400
Date: Wed, 29 Mar 2017 09:38:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Haim Daniel <haimdaniel@gmail.com>
Cc: mchehab@kernel.org, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH]: staging: media: css2400: fix checkpatch error
Message-ID: <20170329073837.GA17585@kroah.com>
References: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0bf9753-54d7-5178-5339-37b24d7e8191@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 29, 2017 at 08:36:27AM +0300, Haim Daniel wrote:

> >From 41d35b455f8eb139912909639e914469ef5e06fb Mon Sep 17 00:00:00 2001
> From: Haim Daniel <haimdaniel@gmail.com>
> Date: Tue, 28 Mar 2017 19:27:57 +0300
> Subject: [PATCH] [media] staging: css2400: fix checkpatch error
> 
> isp_capture_defs.h:

What is this line for?

> 
> enclose macro with complex values in parentheses.
> 
> Signed-off-by: Haim Daniel <haimdaniel@gmail.com>
> ---
>  .../pci/atomisp2/css2400/css_2401_csi2p_system/hrt/isp_capture_defs.h   | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please don't attach your patch, use 'git send-email' to send it
properly.

thanks,

greg k-h
