Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58304 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932414AbeBVNq6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Feb 2018 08:46:58 -0500
Date: Thu, 22 Feb 2018 14:46:58 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Rohit Athavale <rohit.athavale@xilinx.com>
Cc: devel@driverdev.osuosl.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 1/3] staging: xm2mvscale: Driver support for Xilinx
 M2M Video Scaler
Message-ID: <20180222134658.GB19182@kroah.com>
References: <1519252996-787-1-git-send-email-rohit.athavale@xilinx.com>
 <1519252996-787-2-git-send-email-rohit.athavale@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1519252996-787-2-git-send-email-rohit.athavale@xilinx.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Feb 21, 2018 at 02:43:14PM -0800, Rohit Athavale wrote:
> This commit adds driver support for the pre-release Xilinx M2M Video
> Scaler IP. There are three parts to this driver :
> 
>  - The Hardware/IP layer that reads and writes register of the IP
>    contained in the scaler_hw_xm2m.c
>  - The set of ioctls that applications would need to know contained
>    in ioctl_xm2mvsc.h
>  - The char driver that consumes the IP layer in xm2m_vscale.c
> 
> Signed-off-by: Rohit Athavale <rohit.athavale@xilinx.com>
> ---

I need an ack from the linux-media maintainers before I can consider
this for staging, as this really looks like an "odd" video driver...

thanks,

greg k-h
