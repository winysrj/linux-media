Return-path: <linux-media-owner@vger.kernel.org>
Received: from mujunyku.leporine.io ([113.212.96.195]:37190 "EHLO
	mujunyku.leporine.io" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbbHCM52 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 08:57:28 -0400
Message-ID: <55BF6531.9080505@rabbit.us>
Date: Mon, 03 Aug 2015 14:57:21 +0200
From: Peter Rabbitson <rabbit@rabbit.us>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] uvcvideo: Disable hardware timestamps by default
References: <1438006696-30678-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1438006696-30678-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/27/2015 04:18 PM, Laurent Pinchart wrote:
> The hardware timestamping implementation has been reported as not
> working correctly on at least the Logitech C920. Until this can be
> fixed, disable it by default.

As stated earlier on freenode#v4l - this patch seems to do the job for 
me as well. Thanks a lot!

Are there extra steps necessary to get this merged into media_tree.git ?

Cheers



