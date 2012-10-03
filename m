Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:57981 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960Ab2JCIzL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Oct 2012 04:55:11 -0400
Message-ID: <506BFD6A.9030205@ti.com>
Date: Wed, 3 Oct 2012 14:25:06 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFCv2 PATCH 13/14] davinci: move struct vpif_interface to chan_cfg.
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com> <3315239726b3c1a08b359c443f6bbe54c63d74d0.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <3315239726b3c1a08b359c443f6bbe54c63d74d0.1348142407.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/20/2012 5:36 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> struct vpif_interface is channel specific, not subdev specific.
> Move it to the channel config.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For the DaVinci platform changes:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
