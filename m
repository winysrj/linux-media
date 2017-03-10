Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:57514 "EHLO
        lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936381AbdCJNId (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 10 Mar 2017 08:08:33 -0500
Subject: Re: [PATCH v6] [media] vimc: Virtual Media Controller core, capture
 and sensor
To: Helen Koike <helen.koike@collabora.co.uk>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Helen Koike <helen.koike@collabora.com>
References: <ee909db9-eb2b-d81a-347a-fe12112aa1cf@xs4all.nl>
 <37dc3fa2c020c30f8ced9749f81394d585a37ec1.1473018878.git.helen.koike@collabora.com>
 <1974124.c4lYpJ902j@avalon>
 <599c7289-611c-8328-36b4-9146e24f2c5d@collabora.co.uk>
Cc: linux-media@vger.kernel.org, jgebben@codeaurora.org,
        mchehab@osg.samsung.com,
        Helen Fornazier <helen.fornazier@gmail.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ace9b06f-082f-2909-139f-5c44974b4c25@xs4all.nl>
Date: Fri, 10 Mar 2017 14:08:30 +0100
MIME-Version: 1.0
In-Reply-To: <599c7289-611c-8328-36b4-9146e24f2c5d@collabora.co.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Helen,

On 11/01/17 02:30, Helen Koike wrote:
> 
> Thank you for the review, I'll update the patch accordingly and re-submit it.
> 
> Helen

Do you know when you have a v7 ready?

We really need a vimc driver so people without hardware can actually fiddle around
with the MC.

See also my rant here (not directed at you!):

https://www.spinics.net/lists/kernel/msg2462009.html

Regards,

	Hans
