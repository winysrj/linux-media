Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64444 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394Ab1I3HSB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 03:18:01 -0400
Received: by wwf22 with SMTP id 22so2264174wwf.1
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 00:18:00 -0700 (PDT)
Message-ID: <4e856d27.92d1e30a.6587.13f8@mx.google.com>
Subject: Re: dvbscan output Channel Number into final stdout?
From: tvboxspy <tvboxspy@gmail.com>
To: linux-media@vger.kernel.org
Date: Fri, 30 Sep 2011 08:17:53 +0100
In-Reply-To: <20110929224418.GD2824@localhost2.local>
References: <20110929224418.GD2824@localhost2.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2011-09-29 at 14:44 -0800, Roger wrote:
> Can we get dvbscan to output the Channel Number into the final stdout somehow?
> 
> A likely format would be something such as the following.
> 
> Current output:
> 
> KATN-DT:497028615:8VSB:49:52:3
> KWFA-DT:497028615:8VSB:65:68:4
> ...
> 
> 
> Suggested output:
> 2.1:497028615:8VSB:49:52:3
> 2.2:497028615:8VSB:65:68:4
> ...
> 
> The reason for this, the local ATSC broadcast over the air channels are not
> assigning unique channel names.  However, channel numbers seem to be consistent
> between the published TV Guide/TV Listings and are unique!  This seems to be
> the norm for the past several years now.
> 
Trouble is, internationally channel numbering is regional, and has
variations in many countries.

Not to show the channel name would confuse users, but to show both with
the number first in a string might be an idea.



