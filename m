Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:52640 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbZIXIug convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Sep 2009 04:50:36 -0400
Received: by ewy7 with SMTP id 7so1470586ewy.17
        for <linux-media@vger.kernel.org>; Thu, 24 Sep 2009 01:50:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200909240820.54291.laurent.pinchart@ideasonboard.com>
References: <4AB43041.6050001@gmail.com>
	 <200909240820.54291.laurent.pinchart@ideasonboard.com>
Date: Thu, 24 Sep 2009 09:50:39 +0100
Message-ID: <59cf47a80909240150w3127ed51j48f81e157b49dc0c@mail.gmail.com>
Subject: Re: [Linux-uvc-devel] [PATCH] uvc: kmalloc failure ignored in
	uvc_ctrl_add_ctrl()
From: Paulo Assis <pj.assis@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Roel Kluin <roel.kluin@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-uvc-devel@lists.berlios.de, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent,


> That's not enough to prevent a kernel crash. The driver can try to dereference
> ctrl->data if ctrl->info isn't NULL. You should only set ctrl->info if
> allocationg succeeds. Something like
>
>        ctrl->data = kmalloc(ctrl->info->size * UVC_CTRL_NDATA, GFP_KERNEL);
>        if (ctrl->data == NULL)
>                return -ENOMEM;
>
>        ctrl->info = info;

Without reading any code this doesn't seem correct, how can you use
ctrl->info->size if you haven't set ctrl->info yet?

Did you mean something like this:

 ctrl->data = kmalloc(info->size * UVC_CTRL_NDATA, GFP_KERNEL);
 if (ctrl->data == NULL)
         return -ENOMEM;

 ctrl->info = info;


Like I said I haven't read the code but this looks better.

Best regards,
Paulo
