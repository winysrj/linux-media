Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:49956 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752449AbbBPO4V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 09:56:21 -0500
Message-ID: <54E20500.4080103@xs4all.nl>
Date: Mon, 16 Feb 2015 15:56:00 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: isely@isely.net
Subject: Re: [PATCH 0/2] Drop g/s_priority ioctl ops
References: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1422971216-47871-1-git-send-email-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/03/2015 02:46 PM, Hans Verkuil wrote:
> Only pvrusb2 is still using the vidioc_g/s_priority ioctl ops.
> Add struct v4l2_fh support to pvrusb2, allowing us to drop those
> ioctl ops altogether.
> 
> This patch series sits on top of the earlier 5 part patch series
> "Remove .ioctl from v4l2_file_operations", but it is probably
> independent of that one.
> 
> Note: this is not yet tested. If Mike can't get around to that this
> week, then I'll give it a spin on Monday.

Tested-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
