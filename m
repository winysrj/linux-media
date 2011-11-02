Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:37921 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab1KBKAw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:00:52 -0400
Date: Wed, 2 Nov 2011 12:00:48 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH 3/6] v4l2-event: Remove pending events from fh event
 queue when unsubscribing
Message-ID: <20111102100048.GA22159@valkosipuli.localdomain>
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com>
 <1320074209-23473-4-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320074209-23473-4-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Oct 31, 2011 at 04:16:46PM +0100, Hans de Goede wrote:
> The kev pointers inside the pending events queue (the available queue) of the
> fh point to data inside the sev, unsubscribing frees the sev, thus making these
> pointers point to freed memory!
> 
> This patch fixes these dangling pointers in the available queue by removing
> all matching pending events on unsubscription.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/v4l2-event.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)

Thanks for the patch! I think this should go in rather soon as this is an
important bugfix.

Acked-by: Sakari Ailus <sakari.ailus@iki.fi>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
