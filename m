Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:59143 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932132AbbBPLkc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 06:40:32 -0500
Message-ID: <54E1D71C.2000003@xs4all.nl>
Date: Mon, 16 Feb 2015 12:40:12 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Florian Echtler <floe@butterbrot.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: laurent.pinchart@ideasonboard.com, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v3][RFC] add raw video stream support for Samsung SUR40
References: <1423063842-6902-1-git-send-email-floe@butterbrot.org> <54DB4295.1080307@butterbrot.org>
In-Reply-To: <54DB4295.1080307@butterbrot.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/11/2015 12:52 PM, Florian Echtler wrote:
> Hello again,
> 
> does anyone have any suggestions why USERPTR still fails with dma-sg?
> 
> Could I just disable the corresponding capability for the moment so that
> the patch could perhaps be merged, and investigate this separately?

I prefer to dig into this a little bit more, as I don't really understand
it. Set the videobuf2-core debug level to 1 and see what the warnings are.

Since 'buf.qbuf' fails in v4l2-compliance, it's something in the VIDIOC_QBUF
sequence that returns an error, so you need to pinpoint that.

If push comes to shove I can also merge the patch without USERPTR support,
but I really prefer not to do that.

Regards,

	Hans
