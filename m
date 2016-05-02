Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:56958 "EHLO
	www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbcEBKQz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 May 2016 06:16:55 -0400
Subject: Re: [PATCH] media: fix use-after-free in cdev_put() when app exits
 after driver unbind
To: Shuah Khan <shuahkh@osg.samsung.com>, mchehab@osg.samsung.com,
	laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi
References: <1461969452-9276-1-git-send-email-shuahkh@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <57272910.8090500@metafoo.de>
Date: Mon, 2 May 2016 12:16:48 +0200
MIME-Version: 1.0
In-Reply-To: <1461969452-9276-1-git-send-email-shuahkh@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2016 12:37 AM, Shuah Khan wrote:
[...]
> diff --git a/include/media/media-devnode.h b/include/media/media-devnode.h
> index 5bb3b0e..ce9b051 100644
> --- a/include/media/media-devnode.h
> +++ b/include/media/media-devnode.h
> @@ -72,6 +72,7 @@ struct media_file_operations {
>   * @fops:	pointer to struct &media_file_operations with media device ops
>   * @dev:	struct device pointer for the media controller device
>   * @cdev:	struct cdev pointer character device
> + * @kobj:	struct kobject
>   * @parent:	parent device
>   * @minor:	device node minor number
>   * @flags:	flags, combination of the MEDIA_FLAG_* constants
> @@ -91,6 +92,7 @@ struct media_devnode {
>  	/* sysfs */
>  	struct device dev;		/* media device */
>  	struct cdev cdev;		/* character device */
> +	struct kobject kobj;		/* set as cdev parent kobj */

As said during the previous review, the struct device should be used for
reference counting. Otherwise a use-after-free can still occur since you now
have two reference counted data structures with independent counters in the
same structure. For one of them the counter goes to zero before the other
and then you have the use-after-free.

>  	struct device *parent;		/* device parent */
>  
>  	/* device info */
> 

