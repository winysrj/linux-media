Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58526 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AIVO7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Jan 2011 16:14:59 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 0/5] Use control framework in cafe_ccic and s_config removal
Date: Sun, 9 Jan 2011 22:15:45 +0100
Cc: linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1294484508-14820-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101092215.45816.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

On Saturday 08 January 2011 12:01:43 Hans Verkuil wrote:
> Second version of this patch. Changes are:
> 
> - Handle the return code of the internal 'registered' op and 'unregistered'
> now returns a void.
> - has_new has been renamed to is_new and is documented and no longer
> internal.

For patches 1/5, 2/5 and 3/5,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

-- 
Regards,

Laurent Pinchart
