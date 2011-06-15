Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:50406 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab1FOIhh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Jun 2011 04:37:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] v4l: Don't access media entity after is has been destroyed
Date: Wed, 15 Jun 2011 10:37:45 +0200
Cc: hverkuil@xs4all.nl, hdegoede@redhat.com, sakari.ailus@iki.fi
References: <201106131809.28074.laurent.pinchart@ideasonboard.com> <1308126986-7679-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1308126986-7679-1-git-send-email-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106151037.45534.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Mauro,

I forgot to mention in the subject line that this fix should go to 3.0. It 
fixes a kernel oops when a UVC webcam is disconnected during streaming.

I'll send a pull request in the next few days after getting an ack on this 
patch.

Hans, could you please test if it fixes your issue ?

-- 
Regards,

Laurent Pinchart
