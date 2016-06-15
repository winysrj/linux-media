Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:33796 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbcFOUcM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2016 16:32:12 -0400
Subject: Re: [PATCH 3/3] drivers/media/media-device: fix double free bug in
 _unregister()
To: Max Kellermann <max@duempel.org>, linux-media@vger.kernel.org,
	mchehab@osg.samsung.com
References: <146602170216.9818.6967531646383934202.stgit@woodpecker.blarg.de>
 <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuahkh@osg.samsung.com>
From: Shuah Khan <shuahkh@osg.samsung.com>
Message-ID: <5761BB4A.9040309@osg.samsung.com>
Date: Wed, 15 Jun 2016 14:32:10 -0600
MIME-Version: 1.0
In-Reply-To: <146602171226.9818.8828702464432665144.stgit@woodpecker.blarg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/15/2016 02:15 PM, Max Kellermann wrote:
> While removing all interfaces in media_device_unregister(), all
> media_interface pointers are freed.  This is illegal and results in
> double kfree() if any media_interface is still linked at this point;
> maybe because a userspace process still has a file handle.  Once the
> process closes the file handle, dvb_media_device_free() gets called,
> which frees the dvb_device.intf_devnode again.
> 
> This patch removes the unnecessary kfree() call, and documents who's
> responsible for really freeing it.
> 
> Signed-off-by: Max Kellermann <max@duempel.org>
> ---
>  drivers/media/media-device.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 33a9952..1db4707 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -799,9 +799,11 @@ void media_device_unregister(struct media_device *mdev)
>  	/* Remove all interfaces from the media device */
>  	list_for_each_entry_safe(intf, tmp_intf, &mdev->interfaces,
>  				 graph_obj.list) {
> +		/* unlink the interface, but don't free it here; the
> +		   module which created it is responsible for freeing
> +		   it */
>  		__media_remove_intf_links(intf);
>  		media_gobj_destroy(&intf->graph_obj);
> -		kfree(intf);

This change introduces memory leaks, since drivers are relying on
media_device_unregister() to free interfaces.

thanks,
-- Shuah
