Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:37263 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab2JCIqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Oct 2012 04:46:51 -0400
Message-ID: <506BFB76.2050602@ti.com>
Date: Wed, 3 Oct 2012 14:16:46 +0530
From: Sekhar Nori <nsekhar@ti.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: <linux-media@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: [RFCv2 PATCH 06/14] vpif_capture: move routing info from subdev
 to input.
References: <15fd87671d173ae4b943df4114aafb55d7e958fa.1348142407.git.hans.verkuil@cisco.com> <dedef717b23ad46abe8b0446bc16d8031128a670.1348142407.git.hans.verkuil@cisco.com>
In-Reply-To: <dedef717b23ad46abe8b0446bc16d8031128a670.1348142407.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/20/2012 5:36 PM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Routing information is a property of the input, not of the subdev.
> One subdev may provide multiple inputs, each with its own routing
> information.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

For the DaVinci platform change:

Acked-by: Sekhar Nori <nsekhar@ti.com>

Thanks,
Sekhar
