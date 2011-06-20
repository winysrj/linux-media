Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:57481 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab1FTNF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jun 2011 09:05:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [RFCv3 PATCH 08/18] v4l2-ctrls: add v4l2_ctrl_auto_cluster to simplify autogain/gain scenarios
Date: Mon, 20 Jun 2011 15:05:47 +0200
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <1307459123-17810-1-git-send-email-hverkuil@xs4all.nl> <79b139274f67e1e17b56ab49ece643e9cb106e99.1307458245.git.hans.verkuil@cisco.com>
In-Reply-To: <79b139274f67e1e17b56ab49ece643e9cb106e99.1307458245.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106201505.48108.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Hans,

Thanks for the patch.

On Tuesday 07 June 2011 17:05:13 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> It is a bit tricky to handle autogain/gain type scenerios correctly. Such
> controls need to be clustered and the V4L2_CTRL_FLAG_UPDATE should be set
> on the autofoo controls. In addition, the manual controls should be marked
> inactive when the automatic mode is on, and active when the manual mode is
> on. This also requires specialized volatile handling.
> 
> The chances of drivers doing all these things correctly are pretty remote.
> So a new v4l2_ctrl_auto_cluster function was added that takes care of these
> issues.

Sorry for being a killjoy, but how is this supposed to handle the auto-
exposure control ? Auto-exposure can be in complete auto mode, where both 
exposure time and aperture are controlled automatically, in exposure- or 
aperture-priority mode, where only one the exposure time and aperture is 
controlled automatically, or in manual mode.

-- 
Regards,

Laurent Pinchart
