Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:2518 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab1FDKTk (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Jun 2011 06:19:40 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [RFCv2 PATCH 00/11] Control Event
Date: Sat, 4 Jun 2011 12:19:32 +0200
Cc: linux-media@vger.kernel.org
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl> <201106032154.48016.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201106032154.48016.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106041219.32756.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Friday, June 03, 2011 21:54:47 Laurent Pinchart wrote:
> Hi Hans,
> 
> Thanks for the patch set.
> 
> On Wednesday 25 May 2011 15:33:44 Hans Verkuil wrote:
> > This is the second version of the patch series introducing a new event that
> > is triggered when a control's value or state changes.
> 
> One general comment. The API lets applications subscribe to events for 
> individual controls. Should we also have an API to subscribe to events for all 
> controls ?

Right now there is no need for it, but should we need this, then I planned to
allow control event subscription with id == 0 or id == -1 or by setting a flag
or something similar.

Regards,

	Hans
