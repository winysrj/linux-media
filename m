Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:60962 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932511AbcLMJo1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 13 Dec 2016 04:44:27 -0500
Date: Tue, 13 Dec 2016 11:43:47 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Nicholas Mc Guire <hofrat@osadl.org>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] [media] s5k6aa: set usleep_range greater 0
Message-ID: <20161213094346.GW16630@valkosipuli.retiisi.org.uk>
References: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1481594282-12801-1-git-send-email-hofrat@osadl.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Nicholas,

On Tue, Dec 13, 2016 at 02:58:02AM +0100, Nicholas Mc Guire wrote:
> As this is not in atomic context and it does not seem like a critical 
> timing setting a range of 1ms allows the timer subsystem to optimize 
> the hrtimer here.

I'd suggest not to. These delays are often directly visible to the user in
use cases where attention is indeed paid to milliseconds.

The same applies to register accesses. An delay of 0 to 100 µs isn't much as
such, but when you multiply that with the number of accesses it begins to
add up.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
