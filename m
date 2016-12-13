Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34092 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932290AbcLMKyL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 05:54:11 -0500
Date: Tue, 13 Dec 2016 12:54:07 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Ian Arkver <ian.arkver.dev@gmail.com>
Cc: Nicholas Mc Guire <hofrat@osadl.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
Message-ID: <20161213105406.GY16630@valkosipuli.retiisi.org.uk>
References: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
 <20161213094346.GW16630@valkosipuli.retiisi.org.uk>
 <ce9f2ee0-c0d3-2eb4-a733-b108d12b43fb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce9f2ee0-c0d3-2eb4-a733-b108d12b43fb@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Dec 13, 2016 at 10:10:51AM +0000, Ian Arkver wrote:
> On 13/12/16 09:43, Sakari Ailus wrote:
> >Hi Nicholas,
> >
> >On Tue, Dec 13, 2016 at 02:58:02AM +0100, Nicholas Mc Guire wrote:
> >>As this is not in atomic context and it does not seem like a critical
> >>timing setting a range of 1ms allows the timer subsystem to optimize
> >>the hrtimer here.
> >I'd suggest not to. These delays are often directly visible to the user in
> >use cases where attention is indeed paid to milliseconds.
> >
> >The same applies to register accesses. An delay of 0 to 100 µs isn't much as
> >such, but when you multiply that with the number of accesses it begins to
> >add up.
> >
> Data sheet for this device [1] says STBYN deassertion to RSTN deassertion
> should be >50us, though this is actually referenced to MCLK startup. See
> Figure 36, Power-Up Sequence, page 42.
> 
> I think the usleep range here could be greatly reduced and opened up to
> allow hr timer tweaks if desired.
> 
> [1] http://www.bdtic.com/DataSheet/SAMSUNG/S5K6AAFX13.pdf

Good point. Datasheets do not always tell everything though; it'd be good to
get a comment from the original driver authors on why they've used the value
which can now be found in the driver.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
