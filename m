Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36657 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab1FCWC2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 18:02:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 00/11] Control Event
Date: Fri, 3 Jun 2011 21:54:47 +0200
Cc: linux-media@vger.kernel.org
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106032154.48016.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch set.

On Wednesday 25 May 2011 15:33:44 Hans Verkuil wrote:
> This is the second version of the patch series introducing a new event that
> is triggered when a control's value or state changes.

One general comment. The API lets applications subscribe to events for 
individual controls. Should we also have an API to subscribe to events for all 
controls ?

-- 
Regards,

Laurent Pinchart
