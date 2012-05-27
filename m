Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39539 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2E3EUP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 30 May 2012 00:20:15 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SZaOI-0006NU-8G
	for linux-media@vger.kernel.org; Wed, 30 May 2012 06:20:10 +0200
Received: from 203.116.198.71 ([203.116.198.71])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 06:20:10 +0200
Received: from soby.mathew by 203.116.198.71 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 30 May 2012 06:20:10 +0200
To: linux-media@vger.kernel.org
From: Soby Mathew <soby.mathew@st.com>
Subject: Re: Preliminary proposal, new APIs for HDMI and DVI control in v4l2
Date: Sun, 27 May 2012 17:30:20 +0000 (UTC)
Message-ID: <loom.20120527T192755-466@post.gmane.org>
References: <4D7E42AE.2080506@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Bugge (marbugge <marbugge <at> cisco.com> writes:

> 
> 
> This is a preliminary proposal for an extension to the v4l2 api.
> To be discussed at the  V4L2 'brainstorming' meeting in Warsaw, March 2011
> 
> Purpose: Provide basic controls for HDMI and DVI devices.
> 
> 
reposting the query since the earlier post did not appear in mailing list.

Hi Martin,
   We are also in requirement of these controls as described by you. I did a 
search in the archives but could not find a suitable conclusion to the RFC. I 
could find that the dv_timings structure has been modified as a result of 
further discussions. But for many items like S_EDID, DV_CABLE_DETECT, Info 
frames etc , I could not find the logical conclusion to this RFC. Could please 
let me know the further updates on these requirements?


Thanks in Advance
Best Regards
Soby Mathew


