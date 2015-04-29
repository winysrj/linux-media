Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-1.cisco.com ([173.38.203.51]:34484 "EHLO
	aer-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbD2IE5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 04:04:57 -0400
Message-ID: <55408DE7.3020906@cisco.com>
Date: Wed, 29 Apr 2015 09:53:11 +0200
From: Hans Verkuil <hansverk@cisco.com>
MIME-Version: 1.0
To: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-media <linux-media@vger.kernel.org>
CC: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: S_CTRL must be called twice  to set volatile controls
References: <5540895A.5060102@samsung.com>
In-Reply-To: <5540895A.5060102@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacek,

On 04/29/15 09:33, Jacek Anaszewski wrote:
> Hi,
> 
> After testing my v4l2-flash helpers patch [1] with the recent patches
> for v4l2-ctrl.c ([2] and [3]) s_ctrl op isn't called despite setting
> the value that should be aligned to the other step than default one.
> 
> This happens for V4L2_CID_FLASH_TORCH_INTENSITY control with
> V4L2_CTRL_FLAG_VOLATILE flag.
> 
> The situation improves after setting V4L2_CTRL_FLAG_EXECUTE_ON_WRITE
> flag for the control. Is this flag required now for volatile controls
> to be writable?

Yes, you need that if you want to be able to write to a volatile control.

It was added for exactly that purpose.

Why is V4L2_CID_FLASH_TORCH_INTENSITY volatile? Volatile typically only
makes sense if the hardware itself is modifying the value without the
software knowing about it.

Regards,

	Hans

> 
> [1] http://www.spinics.net/lists/linux-media/msg89004.html
> [2] 45f014c5 [media] media/v4l2-ctrls: Always execute EXECUTE_ON_WRITE ctrls
> [3] b08d8d26 [media] media/v4l2-ctrls: volatiles should not generate CH_VALUE
