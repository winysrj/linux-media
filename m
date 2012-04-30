Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:40375 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab2D3J2t (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Apr 2012 05:28:49 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
Subject: Re: [GIT PULL for v3.5] Control events support for uvcvideo
Date: Mon, 30 Apr 2012 11:29:06 +0200
Message-ID: <5062483.FgLTOh88GA@avalon>
In-Reply-To: <201204300830.39501.hverkuil@xs4all.nl>
References: <3052114.LipUdaOlsN@avalon> <201204300830.39501.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Monday 30 April 2012 08:30:39 Hans Verkuil wrote:
> Hi Laurent,
> 
> I know I am very late with this, but I looked through the event/control core
> changes and I found a locking bug there. I didn't have a chance to review
> the patch series when HdG posted it earlier this month, so my apologies for
> coming up with this only now.

No worries. Thank you for catching the bug, I'll send a new pull request.

-- 
Regards,

Laurent Pinchart

