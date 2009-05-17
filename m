Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51663 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbZEQNs4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 May 2009 09:48:56 -0400
Message-ID: <4A1015DA.6010703@redhat.com>
Date: Sun, 17 May 2009 15:49:14 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: video4linux-list@redhat.com,
	SPCA50x Linux Device Driver Development
	<spca50x-devs@lists.sourceforge.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH][libv4l] Support V4L2_CTRL_FLAG_NEXT_CTRL for fake controls
References: <49E5D4DE.6090108@hhs.nl> <49E9B989.70602@redhat.com> <200904182044.06879.linux@baker-net.org.uk> <200904182345.48441.linux@baker-net.org.uk>
In-Reply-To: <200904182345.48441.linux@baker-net.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 04/19/2009 12:45 AM, Adam Baker wrote:
> The "fake" controls added by libv4l to provide whitebalance on some cameras do
> not respect the V4L2_CTRL_FLAG_NEXT_CTRL and hence don't appear on control
> programs that try to use that flag if there are any driver controls that do
> support the flag. Add support for V4L2_CTRL_FLAG_NEXT_CTRL
>
> Signed-off-by: Adam Baker<linux@baker-net.org.uk>

Thanks, reviewed and tested looks fine, so it has been applied to my tree:
http://linuxtv.org/hg/~hgoede/libv4l

And will be in the next libv4l release.

Regards,

Hans
