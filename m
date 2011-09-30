Return-path: <linux-media-owner@vger.kernel.org>
Received: from denali.acsalaska.net ([209.112.173.242]:54672 "EHLO
	denali.acsalaska.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1I3UxU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 16:53:20 -0400
Received: from localhost2.local (66-230-86-166-rb1.fai.dsl.dynamic.acsalaska.net [66.230.86.166])
	by denali.acsalaska.net (8.14.4/8.14.4) with ESMTP id p8UKrIE5019338
	for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 12:53:18 -0800 (AKDT)
	(envelope-from rogerx.oss@gmail.com)
Date: Fri, 30 Sep 2011 12:53:17 -0800
From: Roger <rogerx.oss@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: dvbscan output Channel Number into final stdout?
Message-ID: <20110930205317.GA2287@localhost2.local>
References: <20110929224418.GD2824@localhost2.local>
 <4e856d27.92d1e30a.6587.13f8@mx.google.com>
 <20110930080609.GD2284@localhost2.local>
 <e9f9d962fccf0ef7c4bddd24ed065c8c.squirrel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9f9d962fccf0ef7c4bddd24ed065c8c.squirrel@localhost>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> On Fri, Sep 30, 2011 at 12:34:41PM -0500, david.hagood@gmail.com wrote:
>Even that won't always save you. In my area, we have 2 distinct signals,
>both identifying themselves as "KAKE-DT" on virtual channel 10.1, so even
>that isn't guaranteed to be unique.

Eh, what fun.

Technically, should just output both, the channel_name and channel_num.

ie. For my channel 2:1 here (using chicken scratch):

-- KATN-DT:497028615:8VSB:49:52:3
++ KATN-DT:2.1:497028615:8VSB:49:52:3

or

++ 2.1:KATN-DT:497028615:8VSB:49:52:3


-- 
Roger
http://rogerx.freeshell.org/
