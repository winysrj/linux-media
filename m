Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbbLIAri (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Dec 2015 19:47:38 -0500
Date: Mon, 7 Dec 2015 10:31:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: stable <stable@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Failed to build on 4.2.6
Message-ID: <20151207153119.GA31513@kroah.com>
References: <20151207102519.6c6d850a@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20151207102519.6c6d850a@gandalf.local.home>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 07, 2015 at 10:25:19AM -0500, Steven Rostedt wrote:
> Hi,
> 
> The attached config doesn't build on 4.2.6, but changing it to the
> following:
> 
>  VIDEO_V4L2_SUBDEV_API n -> y
> +V4L2_FLASH_LED_CLASS n
> 
> does build.

Did this work on older kernels (4.2.5?  .4?  older?)

thanks,

greg k-h
