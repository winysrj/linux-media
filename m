Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:43988 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751519AbcEFLFO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 May 2016 07:05:14 -0400
Date: Fri, 6 May 2016 14:05:07 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, mchehab@osg.samsung.com
Subject: Re: [RFC 15/22] media: Make events on request completion optional,
 disabled by default
Message-ID: <20160506110507.GM26360@valkosipuli.retiisi.org.uk>
References: <1462532011-15527-1-git-send-email-sakari.ailus@linux.intel.com>
 <1462532011-15527-16-git-send-email-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1462532011-15527-16-git-send-email-sakari.ailus@linux.intel.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, May 06, 2016 at 01:53:24PM +0300, Sakari Ailus wrote:
> Add flags to requests. The first defined flag, MEDIA_REQ_FL_COMPLETE_EVENT
> is used to tell whether to queue an event on request completion. Unless
> the flag is set, no event is generated when a request completes.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

This one nicely demonstrates variable size IOCTL argument support so I left
it there for the time being. To be merged with the previous patch in the
future, with struct media_request_cmd_0 removed.

> ---
>  drivers/media/media-device.c | 26 +++++++++++++++++---------
>  include/media/media-device.h |  2 ++
>  include/uapi/linux/media.h   | 16 +++++++++++++---
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 357c3cb..0b1ab88 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -284,7 +284,8 @@ static void media_device_request_delete(struct media_device *mdev,
>  void media_device_request_complete(struct media_device *mdev,
>  				   struct media_device_request *req)
>  {
> -	media_device_request_queue_event(mdev, req);
> +	if (req->flags & MEDIA_REQ_FL_COMPLETE_EVENT)
> +		media_device_request_queue_event(mdev, req);
>  
>  	media_device_request_delete(mdev, req);
>  }
> @@ -292,8 +293,8 @@ EXPORT_SYMBOL_GPL(media_device_request_complete);
>  
>  static int media_device_request_queue_apply(
>  	struct media_device *mdev, struct media_device_request *req,
> -	int (*fn)(struct media_device *mdev,
> -		  struct media_device_request *req))
> +	u32 req_flags, int (*fn)(struct media_device *mdev,
> +				 struct media_device_request *req))
>  {
>  	unsigned long flags;
>  	int rval = 0;
> @@ -302,10 +303,12 @@ static int media_device_request_queue_apply(
>  		return -ENOSYS;
>  
>  	spin_lock_irqsave(&mdev->req_lock, flags);
> -	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE)
> +	if (req->state != MEDIA_DEVICE_REQUEST_STATE_IDLE) {
>  		rval = -EINVAL;
> -	else
> +	} else {
>  		req->state = MEDIA_DEVICE_REQUEST_STATE_QUEUED;
> +		req->flags = req_flags;
> +	}
>  	spin_unlock_irqrestore(&mdev->req_lock, flags);
>  
>  	if (rval)
> @@ -358,12 +361,12 @@ static long media_device_request_cmd(struct media_device *mdev,
>  		break;
>  
>  	case MEDIA_REQ_CMD_APPLY:
> -		ret = media_device_request_queue_apply(mdev, req,
> +		ret = media_device_request_queue_apply(mdev, req, cmd->flags,
>  						       mdev->ops->req_apply);
>  		break;
>  
>  	case MEDIA_REQ_CMD_QUEUE:
> -		ret = media_device_request_queue_apply(mdev, req,
> +		ret = media_device_request_queue_apply(mdev, req, cmd->flags,
>  						       mdev->ops->req_queue);
>  		break;
>  
> @@ -930,13 +933,18 @@ static long __media_device_ioctl(
>  	return ret;
>  }
>  
> +static const unsigned short media_request_cmd_sizes[] = {
> +	sizeof(struct media_request_cmd_0),
> +	0
> +};
> +
>  static const struct media_ioctl_info ioctl_info[] = {
>  	MEDIA_IOC(DEVICE_INFO, media_device_get_info, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(ENUM_ENTITIES, media_device_enum_entities, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(ENUM_LINKS, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> -	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
> +	MEDIA_IOC_SZ(REQUEST_CMD, media_device_request_cmd, 0, media_request_cmd_sizes),
>  	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
>  };
>  
> @@ -985,7 +993,7 @@ static const struct media_ioctl_info compat_ioctl_info[] = {
>  	MEDIA_IOC_ARG(ENUM_LINKS32, media_device_enum_links, MEDIA_IOC_FL_GRAPH_MUTEX, from_user_enum_links32, copy_arg_to_user_nop),
>  	MEDIA_IOC(SETUP_LINK, media_device_setup_link, MEDIA_IOC_FL_GRAPH_MUTEX),
>  	MEDIA_IOC(G_TOPOLOGY, media_device_get_topology, MEDIA_IOC_FL_GRAPH_MUTEX),
> -	MEDIA_IOC(REQUEST_CMD, media_device_request_cmd, 0),
> +	MEDIA_IOC_SZ(REQUEST_CMD, media_device_request_cmd, 0, media_request_cmd_sizes),
>  	MEDIA_IOC(DQEVENT, media_device_dqevent, 0),
>  };
>  
> diff --git a/include/media/media-device.h b/include/media/media-device.h
> index e62ad13..fc91d2d 100644
> --- a/include/media/media-device.h
> +++ b/include/media/media-device.h
> @@ -291,6 +291,7 @@ struct media_kevent {
>   * @state: The state of the request, MEDIA_DEVICE_REQUEST_STATE_*,
>   *	   access to state serialised by mdev->req_lock
>   * @data: Per-entity data list
> + * @flags: Request specific flags, MEDIA_REQ_FL_*
>   */
>  struct media_device_request {
>  	u32 id;
> @@ -302,6 +303,7 @@ struct media_device_request {
>  	struct list_head fh_list;
>  	enum media_device_request_state state;
>  	struct list_head data;
> +	u32 flags;
>  };
>  
>  /**
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index f6e1efe..4fab54d 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -394,26 +394,36 @@ struct media_v2_topology {
>  #define MEDIA_REQ_CMD_APPLY		2
>  #define MEDIA_REQ_CMD_QUEUE		3
>  
> +#define MEDIA_REQ_FL_COMPLETE_EVENT	(1 << 0)
> +
> +#ifdef __KERNEL__
> +struct __attribute__ ((packed)) media_request_cmd_0 {
> +	__u32 cmd;
> +	__u32 request;
> +};
> +#endif
> +
>  struct __attribute__ ((packed)) media_request_cmd {
>  	__u32 cmd;
>  	__u32 request;
> +	__u32 flags;
>  };
>  
>  #define MEDIA_EVENT_TYPE_REQUEST_COMPLETE	1
>  
> -struct media_event_request_complete {
> +struct __attribute__ ((packed)) media_event_request_complete {
>  	__u32 id;
>  	__s32 status;
>  };
>  
> -struct media_event {
> +struct __attribute__ ((packed)) media_event {
>  	__u32 type;
>  	__u32 sequence;
>  
>  	union {
>  		struct media_event_request_complete req_complete;
>  	};
> -} __attribute__ ((packed));
> +};
>  
>  #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
>  #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
