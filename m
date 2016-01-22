Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:38289 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752733AbcAVMPO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2016 07:15:14 -0500
Subject: Re: [v4l-utils PATCH v2 0/3] List supported formats in libv4l2subdev
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org
References: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
Cc: laurent.pinchart@ideasonboard.com
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <56A21D4C.4010800@xs4all.nl>
Date: Fri, 22 Jan 2016 13:15:08 +0100
MIME-Version: 1.0
In-Reply-To: <1449587716-22954-1-git-send-email-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Can you respin this series and add the "v4l: libv4l2subdev: Precisely convert
media bus string to code" patch to it as well? And incorporate Laurent's
comments?

I think this is a very useful addition and since Laurent's comments are minor
I suspect a v3 would be ready for merging.

Regards,

	Hans

On 12/08/2015 04:15 PM, Sakari Ailus wrote:
> Hi,
> 
> Rebased on current v4l-utils. There were conflicts as new media bus
> formats were added. The earlier version is here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg94619.html>
> 
> These patches go on top of the field support set, which hasn't appeared in
> the archive yet. The earlier version is here:
> 
> <URL:http://www.spinics.net/lists/linux-media/msg94605.html>
> 

