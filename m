Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43604 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756644AbcC2KX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Mar 2016 06:23:58 -0400
Date: Tue, 29 Mar 2016 13:23:53 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v2 2/2] [media] media: Improve documentation for
 link_setup/link_modify
Message-ID: <20160329102353.GH32125@valkosipuli.retiisi.org.uk>
References: <fef855a4cd482eb02cff982b01511c893ea6e75d.1459243882.git.mchehab@osg.samsung.com>
 <0a562f0766e40f47092716e0f7744368bd6d963d.1459243882.git.mchehab@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0a562f0766e40f47092716e0f7744368bd6d963d.1459243882.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tue, Mar 29, 2016 at 06:31:28AM -0300, Mauro Carvalho Chehab wrote:
> Those callbacks are called with the media_device.graph_mutex hold.
> 
> Add a note about that, as the code called by those notifiers should
> not be touching in the mutex.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> ---
>  include/media/media-device.h | 3 ++-
>  include/media/media-entity.h | 3 +++
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index b04cfa907350..e6ad30c323fc 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -312,7 +312,8 @@ struct media_entity_notify {
>   * @enable_source: Enable Source Handler function pointer
>   * @disable_source: Disable Source Handler function pointer
>   *
> - * @link_notify: Link state change notification callback
> + * @link_notify: Link state change notification callback. This callback is
> + * Called with the graph_mutex hold.

s/Called/called/
s/hold/held/

>   *
>   * This structure represents an abstract high-level media device. It allows easy
>   * access to entities and provides basic media device-level support. The
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 6dc9e4e8cbd4..0b16ebe36db7 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -179,6 +179,9 @@ struct media_pad {
>   * @link_validate:	Return whether a link is valid from the entity point of
>   *			view. The media_entity_pipeline_start() function
>   *			validates all links by calling this operation. Optional.
> + *
> + * Note: Those ioctls should not touch the struct media_device.@graph_mutex
> + * field, as they're called with it already hold.

These aren't really IOCTLs. They are operation callbacks.

How about:

Note: the callbacks are called struct media_device.@graph_mutex held.

Feel free to replace "callbacks" with "ops" or "operations" or such.

With these changes,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

>   */
>  struct media_entity_operations {
>  	int (*link_setup)(struct media_entity *entity,

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
