Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:26455 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142AbZBROr5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2009 09:47:57 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: gilles <gilles.gigan@gmail.com>
Subject: Re: Comments on V4L controls
Date: Wed, 18 Feb 2009 15:51:32 +0100
Cc: linux-media@vger.kernel.org
References: <4994A667.2000909@gmail.com>
In-Reply-To: <4994A667.2000909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902181551.32623.laurent.pinchart@skynet.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Gilles,

On Thursday 12 February 2009 23:44:55 gilles wrote:
> Hi everyone,
> Sorry for double posting, but I originally sent this to the old mailing
> list. Here it is:
>
> I have a couple of comments / suggestions regarding the part on controls of
> the V4L2 api:
> Some controls, such as pan relative and tilt relative are write-only, and
> reading their value makes little sense. Yet, there is no way of knowing
> about this, but to try and read a value and be greeted with EINVAL or
> similar. There is already a read-only flag (V4L2_CTRL_FLAG_READ_ONLY) in
> struct v4l2_query. Does it make sense to add another one for write-only
> controls ?

Yes it does. Martin Rubli from Logitech sent a mail in April 2008 to the 
video4linux mailing list. Search the list archives for "[PATCH] Support for 
write-only controls". Feel free to submit a patch.

> The extended controls Pan / Tilt  reset are defined in the API as boolean
> controls. Shouldnt these be defined as buttons instead, as they dont really
> hold a state (enabled/disabled) ?

Agreed. As no driver seem to be using those controls yet, it should be safe to 
update the spec. Could you submit a patch ?

Best regards,

Laurent Pinchart

