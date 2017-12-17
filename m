Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:44096 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752395AbdLQNOB (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 17 Dec 2017 08:14:01 -0500
Subject: Re: [PATCH 4/5] v4l2: async: Postpone subdev_notifier registration
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        sakari.ailus@linux.intel.com
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Reply-To: kieran.bingham@ideasonboard.com, kieran.bingham@ideasonboard.com
References: <1513189580-32202-1-git-send-email-jacopo+renesas@jmondi.org>
 <1513189580-32202-5-git-send-email-jacopo+renesas@jmondi.org>
 <fad564c9-c421-3fd2-1e99-652d2b54985e@ideasonboard.com>
Message-ID: <e8301f4c-da46-472c-0f3d-07fa3f5a3c5a@ideasonboard.com>
Date: Sun, 17 Dec 2017 13:13:56 +0000
MIME-Version: 1.0
In-Reply-To: <fad564c9-c421-3fd2-1e99-652d2b54985e@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17/12/17 13:10, Kieran Bingham wrote:
> Hi Jacopo,
> 
> Thank you for the patch,
> 
> This seems like a good thing to do at a glance here, but I'll leave contextual
> judgement like that to Sakari.

Oh - I hit send and *then* my mail client wakes up and tells me Sakari reviewed
two days ago.

--
Kieran
