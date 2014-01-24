Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:51858 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752018AbaAXL22 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jan 2014 06:28:28 -0500
Date: Fri, 24 Jan 2014 13:28:24 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	laurent.pinchart@ideasonboard.com, t.stanislaws@samsung.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 05/21] videodev2.h: add struct v4l2_query_ext_ctrl
 and VIDIOC_QUERY_EXT_CTRL.
Message-ID: <20140124112823.GB13820@valkosipuli.retiisi.org.uk>
References: <1390221974-28194-1-git-send-email-hverkuil@xs4all.nl>
 <1390221974-28194-6-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390221974-28194-6-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Jan 20, 2014 at 01:45:58PM +0100, Hans Verkuil wrote:
> +	union {
> +		__u64 val;
> +		__u32 reserved[4];
> +	} step;

While I do not question that step is obviously always a positive value (or
zero), using a different type from the value (and min and max) does add
slight complications every time it is being used. I don't think there's a
use case for using values over 2^62 for step either.

Speaking of which --- do you think we should continue to have step in the
interface? This has been proven to be slightly painful when the step is not
an integer. Using a step of one in that case has been the only feasible
solution. Step could be naturally be used as a hint but enforcing it often
forces setting it to one.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
