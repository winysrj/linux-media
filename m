Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984Ab1H0KdU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 27 Aug 2011 06:33:20 -0400
Message-ID: <4E58C883.60406@redhat.com>
Date: Sat, 27 Aug 2011 12:35:47 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: [RFCv2 PATCH 0/8] Add V4L2_CTRL_FLAG_VOLATILE and change volatile
 autocluster handling.
References: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1314360013-9876-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Looks good ACK series.

Acked-by: Hans de Goede <hdegoede@redhat.com>

On 08/26/2011 02:00 PM, Hans Verkuil wrote:
> This is the second patch for this. The first is here:
>
> http://comments.gmane.org/gmane.linux.drivers.video-input-infrastructure/36650
>
> This second version changes the pwc code as suggested by Hans de Goede and it
> adds documentation. The v4l2-ctrls.c code has also been improved to avoid
> unnecessary calls to update_from_auto_cluster(). Thanks to Hans de Goede for
> pointing me in the right direction.
>
> If there are no additional comments, then I will make a pull request early next
> week.
>
> This will also be the basis for converting soc-camera to the control framework.
>
> Regards,
>
> 	Hans
>
