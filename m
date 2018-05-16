Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54488 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751664AbeEPLSc (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 07:18:32 -0400
Date: Wed, 16 May 2018 14:18:29 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 12/28] v4l2-ctrls: add core request support
Message-ID: <20180516111829.yoq3z7kk5bgsuqrr@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503145318.128315-13-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, May 03, 2018 at 04:53:02PM +0200, Hans Verkuil wrote:
> @@ -1059,6 +1077,11 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
>   */
>  __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
>  
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +			     struct v4l2_ctrl_handler *hdl);
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +				struct v4l2_ctrl_handler *hdl);
> +

The two kAPI functions appear to be without documentation.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
