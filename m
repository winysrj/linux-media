Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47379 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932281AbaAaQmh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Jan 2014 11:42:37 -0500
Date: Fri, 31 Jan 2014 18:42:34 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org, k.debski@samsung.com
Subject: Re: [PATCH v4.1 3/3] v4l: Add V4L2_BUF_FLAG_TIMESTAMP_SOF and use it
Message-ID: <20140131164233.GB15383@valkosipuli.retiisi.org.uk>
References: <201308281419.52009.hverkuil@xs4all.nl>
 <344618801.kmLM0jZvMY@avalon>
 <52A9ADF6.2090900@xs4all.nl>
 <18082456.iNCn4Qe0lB@avalon>
 <52EBC534.8080903@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52EBC534.8080903@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans and Laurent,

On Fri, Jan 31, 2014 at 04:45:56PM +0100, Hans Verkuil wrote:
> How about defining a capability for use with ENUMINPUT/OUTPUT? I agree that this
> won't change between buffers, but it is a property of a specific input or output.

Over 80 characters per line. :-P

> There are more than enough bits available in v4l2_input/output to add one for
> SOF timestamps.

In complex devices with a non-linear media graph inputs and outputs are not
very relevant, and for that reason many drivers do not even implement them.
I'd rather not bind video buffer queues to inputs or outputs.

My personal favourite is still to use controls for the purpose but the
buffer flags come close, too, especially now that we're using them for
timestamp sources.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
