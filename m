Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:43681 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751803AbdJYH24 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 03:28:56 -0400
Subject: Re: [PATCH v15.2 24/32] v4l: fwnode: Add a helper function to obtain
 device / integer references
To: Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
Cc: niklas.soderlund@ragnatech.se, maxime.ripard@free-electrons.com,
        laurent.pinchart@ideasonboard.com, pavel@ucw.cz, sre@kernel.org
References: <ffc57dfd-e798-d532-e029-dc91989e285c@xs4all.nl>
 <20171024203254.19993-1-sakari.ailus@linux.intel.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <3dd3ca30-dc22-e40e-8bcb-a43d48aaae63@xs4all.nl>
Date: Wed, 25 Oct 2017 09:28:47 +0200
MIME-Version: 1.0
In-Reply-To: <20171024203254.19993-1-sakari.ailus@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 10/24/2017 10:32 PM, Sakari Ailus wrote:
> v4l2_fwnode_reference_parse_int_prop() will find an fwnode such that under
> the device's own fwnode, it will follow child fwnodes with the given
> property-value pair and return the resulting fwnode.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>

The improved explanation and the DT example make this much easier to understand,
so:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Thanks!

	Hans
