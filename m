Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58609 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbcAUW0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2016 17:26:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sebastien LEDUC <sebastien.leduc@st.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: mediacontroller for framebuffer
Date: Fri, 22 Jan 2016 00:26:24 +0200
Message-ID: <1707301.3M6CagkYeP@avalon>
In-Reply-To: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5CF5@SAFEX1MAIL1.st.com>
References: <DF597D17D2F66F40A76F27D4E5D6E1A48B0F5CF5@SAFEX1MAIL1.st.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sebastien,

On Wednesday 20 January 2016 14:52:30 Sebastien LEDUC wrote:
> Hi Laurent
> I have seen that a long time ago you had done some prototyping work for
> exposing framebuffer devices as media entities:
> http://www.spinics.net/lists/linux-fbdev/msg04408.html
> 
> What did happen to this prototyping ?
> Seems it has never been merged, so could you please explain why ?
> 
> We have some similar needs, so I'd like to understand the right way to go

The prototype has been dropped as the framebuffer subsystem got deprecated. 
Display drivers should now use DRM/KMS.

-- 
Regards,

Laurent Pinchart

