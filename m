Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:48428 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932140AbeAXU6p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 24 Jan 2018 15:58:45 -0500
Date: Wed, 24 Jan 2018 22:58:41 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: corbet@lwn.net, mchehab@kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] media: ov7670: Implement mbus configuration
Message-ID: <20180124205839.fvv5ria4kdkbhk6h@valkosipuli.retiisi.org.uk>
References: <1516786250-3750-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1516786250-3750-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Wed, Jan 24, 2018 at 10:30:48AM +0100, Jacopo Mondi wrote:
> Hello,
>    4th round for this series, now based on Hans' 'parm' branch from
> git://linuxtv.org/hverkuil/media_tree.git
> 
> I addressed Sakari's comments on bindings documentation and driver error path,
> and I hope to get both driver and bindings acked to have this included in next
> merge window.

The patches seem fine to me, but before applying them I'd like to have Rob's
ack on the DT changes.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
