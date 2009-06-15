Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.irobotique.be ([92.243.18.41]:36060 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbZFOJxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 05:53:23 -0400
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: Robert Krakora <rob.krakora@messagenetsystems.com>
Subject: Re: [PATCH 1/2] uvc: Fix for no return value check of uvc_ctrl_set() which calls mutex_lock_interruptible()
Date: Mon, 15 Jun 2009 11:53:21 +0200
Cc: linux-media@vger.kernel.org
References: <b24e53350906120951l552301c8x71b17fa4d45c8d1b@mail.gmail.com>
In-Reply-To: <b24e53350906120951l552301c8x71b17fa4d45c8d1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906151153.21254.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 12 June 2009 18:51:03 Robert Krakora wrote:
> From: Robert Krakora <rob.krakora@messagenetsystems.com>
>
> Fix for no return value check of uvc_ctrl_set() which calls
> mutex_lock_interruptible().
>
> Priority: normal
>
> Signed-off-by: Robert Krakora <rob.krakora@messagenetsystems.com>

Acked-by: Laurent Pinchart <laurent.pinchart@skynet.be>

I'd appreciate if you would at least CC me when submitting patches related to 
the Linux UVC driver in the future.

Regards,

Laurent Pinchart

