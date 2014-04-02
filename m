Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38657 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaDBAWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Apr 2014 20:22:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 0/9] Timestamp source and mem-to-mem device support
Date: Wed, 02 Apr 2014 02:24:53 +0200
Message-ID: <3449850.PLWR070gQv@avalon>
In-Reply-To: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
References: <1393690690-5004-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patches, and sorry for the late reply.

I've pushed outstanding multiplane patches to the master branch of the yavta 
repository, and applied the first two patches of this series on top of that. 
After addressing the commends I've made on the individual patches, could you 
please rebase the rest of the series and resend it ?

On Saturday 01 March 2014 18:18:01 Sakari Ailus wrote:
> Hi,
> 
> This patchset enables using yavta for mem-to-mem devices, including
> mem2mem_testdev (or soon vim2m). The timestamp will be set for output
> buffers when the timestamp type is copy. An option is added to set the
> timestamp source flags (eof/soe).
> 
> To use yavta for mem2mem devices, just open the device in the shell and pass
> the file descriptor to yavta (--fd).

-- 
Regards,

Laurent Pinchart
