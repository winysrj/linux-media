Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4324 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3AGOh4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Jan 2013 09:37:56 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Fwd: [Bug 51991] ioctl(VIDIOC_QUERYCAP) may return non-ASCII characters
Date: Mon, 7 Jan 2013 15:37:50 +0100
Cc: linux-media@vger.kernel.org
References: <3413534.jxGpuKhLTn@avalon>
In-Reply-To: <3413534.jxGpuKhLTn@avalon>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301071537.50246.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon January 7 2013 15:25:30 Laurent Pinchart wrote:
> Hi everybody,
> 
> Any opinion on this ?

UTF-8 makes sense to me.

Regards,

	Hans

> 
> ----------  Forwarded Message  ----------
> 
> Subject: [Bug 51991] ioctl(VIDIOC_QUERYCAP) may return non-ASCII characters
> Date: Wednesday 02 January 2013, 14:45:48
> From: bugzilla-daemon@bugzilla.kernel.org
> To: laurent.pinchart+bugzilla-kernel@ideasonboard.com
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=51991
> 
> 
> Alan <alan@lxorguk.ukuu.org.uk> changed:
> 
>            What    |Removed                     |Added
> ----------------------------------------------------------------------------
>                  CC|                            |alan@lxorguk.ukuu.org.uk
> 
> 
> 
> 
> --- Comment #2 from Alan <alan@lxorguk.ukuu.org.uk>  2013-01-02 14:45:48 ---
> It should probably be documented as UTF-8 IMHO
> 
> -----------------------------------------
> 
> 
