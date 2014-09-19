Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:36914 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154AbaISIAV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Sep 2014 04:00:21 -0400
Date: Fri, 19 Sep 2014 10:59:45 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH 1/3] vb2: Buffers returned to videobuf2 from
 start_streaming in QUEUED state
Message-ID: <20140919075945.GJ2939@valkosipuli.retiisi.org.uk>
References: <1411077469-29178-1-git-send-email-sakari.ailus@iki.fi>
 <1411077469-29178-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411077469-29178-2-git-send-email-sakari.ailus@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Sep 19, 2014 at 12:57:47AM +0300, Sakari Ailus wrote:
> @@ -1174,7 +1174,7 @@ void vb2_buffer_done(struct vb2_buffer *vb, enum vb2_buffer_state state)
>  	if (WARN_ON(vb->state != VB2_BUF_STATE_ACTIVE))
>  		return;
>  
> -	if (!q->start_streaming_called) {
> +	if (q->done_buffers_queued_state) {
>  		if (WARN_ON(state != VB2_BUF_STATE_QUEUED))
>  			state = VB2_BUF_STATE_QUEUED;
>  	} else if (WARN_ON(state != VB2_BUF_STATE_DONE &&

This condition needs to be changed, too. I'll resend a corrected version.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
