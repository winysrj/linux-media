Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga12.intel.com ([192.55.52.136]:47042 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405461AbeKTD2e (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 19 Nov 2018 22:28:34 -0500
Date: Mon, 19 Nov 2018 19:03:54 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Dave Stevenson <dave.stevenson@raspberrypi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>, mchehab@kernel.org,
        linux-media@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 for v4.4 1/1] v4l: event: Add subscription to list
 before calling "add" operation
Message-ID: <20181119170354.kjgob6m2lsbqae2m@kekkonen.localdomain>
References: <20181114093746.29035-1-sakari.ailus@linux.intel.com>
 <20181119151400.GB5340@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119151400.GB5340@kroah.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Greg,

On Mon, Nov 19, 2018 at 04:14:00PM +0100, Greg Kroah-Hartman wrote:
> On Wed, Nov 14, 2018 at 11:37:46AM +0200, Sakari Ailus wrote:
> > [ upstream commit 92539d3eda2c090b382699bbb896d4b54e9bdece ]
> 
> There is no such git commit id in Linus's tree :(

Right. At the moment it's in the media tree only. I expect it'll end up to
Linus's tree once Mauro will send the next pull request from the media tree
to Linus.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
