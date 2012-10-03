Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47970 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011Ab2JCInu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 04:43:50 -0400
Message-ID: <506BFAC1.90400@ti.com>
Date: Wed, 3 Oct 2012 14:13:45 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFCv2 PATCH 05/14] vpif_capture: remove unnecessary can_route
 flag.
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com> <b1644c5bf6f9db750a28bc42a07b1499b9c1e68a.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <b1644c5bf6f9db750a28bc42a07b1499b9c1e68a.1348142407.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/20/2012 5:36 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Calling a subdev op that isn't implemented will just return -ENOIOCTLCMD
> No need to have a flag for that.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For the DaVinci platform change:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
