Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:36667 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab1FCWCa (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jun 2011 18:02:30 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv2 PATCH 05/11] v4l2-ctrls: add v4l2_fh pointer to the set control functions.
Date: Fri, 3 Jun 2011 21:55:23 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1306330435-11799-1-git-send-email-hverkuil@xs4all.nl> <f3f32913df4962bdb541abe87348e561c5e6d325.1306329390.git.hans.verkuil@cisco.com>
In-Reply-To: <f3f32913df4962bdb541abe87348e561c5e6d325.1306329390.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106032155.23482.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Wednesday 25 May 2011 15:33:49 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> When an application changes a control you want to generate an event.
> However, you want to avoid sending such an event back to the application
> (file handle) that caused the change.
> 
> Add the filehandle to the various set control functions.

To implement per-file handle controls, the get/try functions will need the 
file handle as well. Should this patch handle that, or do you want to postpone 
it until a driver uses per-file handle controls ?

-- 
Regards,

Laurent Pinchart
