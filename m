Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:41607 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab1HSUY4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Aug 2011 16:24:56 -0400
Date: Fri, 19 Aug 2011 23:24:52 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <snjw23@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCHv2] adp1653: make ->power() method optional
Message-ID: <20110819202452.GI8872@valkosipuli.localdomain>
References: <20110818092158.GA8872@valkosipuli.localdomain>
 <98c77ce2a17d7a098dedfc858f4055edc5556c54.1313666504.git.andriy.shevchenko@linux.intel.com>
 <1313667122.25065.8.camel@smile>
 <20110818115131.GD8872@valkosipuli.localdomain>
 <1313674341.25065.17.camel@smile>
 <4E4D4840.7050207@gmail.com>
 <4E4D61CD.40405@iki.fi>
 <4E4D7D3A.4040708@gmail.com>
 <4E4E8C7B.7090806@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E4E8C7B.7090806@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Aug 19, 2011 at 07:16:59PM +0300, Sakari Ailus wrote:
[clip]
> > I'm afraid your requirements are too demanding :)
> > Yes, I meant creating a new regulator. In case the ADP1635 voltage regulator
> > is inhibited through a GPIO at a host processor such regulator would in fact
> > be only flipping a GPIO (and its driver would request the GPIO and set it into
> > a default inactive state during its initialization). But the LDO for ADP1635
> 
> Thinking about this again, I think we'd need a regulator and reset gpio.

And as noted below, the regulator isn't needed at this point.

-- 
Sakari Ailus
sakari.ailus@iki.fi
