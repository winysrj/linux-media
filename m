Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1954 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab1LOJyf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Dec 2011 04:54:35 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: v4l: How bridge driver get subdev std?
Date: Thu, 15 Dec 2011 10:54:29 +0100
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org
References: <CAHG8p1A93tTu9Nz1s9ngDrMCRC98A3RVecYFSsrEHsU-zr_b2A@mail.gmail.com>
In-Reply-To: <CAHG8p1A93tTu9Nz1s9ngDrMCRC98A3RVecYFSsrEHsU-zr_b2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112151054.29905.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, December 15, 2011 10:48:39 Scott Jiang wrote:
> Hi Hans and Guennadi,
> 
> I'm wondering how does bridge driver get subdev std (not query)?
> My case is that bridge needs to get subdev default std.

It can just call the core g_std op. Note that g_std was added only recently
(September 9th according to the git log), so if you work with an older kernel,
then it may not be there yet.

Regards,

	Hans
