Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59094 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754557AbeCGO53 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Mar 2018 09:57:29 -0500
Date: Wed, 7 Mar 2018 06:57:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Johan Hovold <johan@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] [media] cpia2_usb: drop bogus interface-release call
Message-ID: <20180307145731.GE4109@kroah.com>
References: <20180307094936.9140-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180307094936.9140-1-johan@kernel.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 07, 2018 at 10:49:36AM +0100, Johan Hovold wrote:
> Drop bogus call to usb_driver_release_interface() from the disconnect()
> callback. As the interface is already being unbound at this point,
> usb_driver_release_interface() simply returns early.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
