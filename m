Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:52831 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490Ab2C1I7T (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 04:59:19 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 07/10] uvcvideo: Move __uvc_ctrl_get() up
Date: Wed, 28 Mar 2012 10:59:15 +0200
Message-ID: <5129126.1UHhr4JkAq@avalon>
In-Reply-To: <1332676610-14953-8-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-8-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 25 March 2012 13:56:47 Hans de Goede wrote:
> This avoids the need for doing a forward declaration of __uvc_ctrl_get
> (which is a static function) in later patches in this series.
> 
> Note to reviewers this patch does not change a single line of code, it
> just moves the function up in uvc_ctrl.c a bit.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
