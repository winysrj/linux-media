Return-path: <linux-media-owner@vger.kernel.org>
Received: from av12-2-sn2.hy.skanova.net ([81.228.8.186]:53697 "EHLO
	av12-2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZHKPOA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2009 11:14:00 -0400
Message-ID: <4A8182D4.2040100@mocean-labs.com>
Date: Tue, 11 Aug 2009 16:40:20 +0200
From: =?ISO-8859-1?Q?Richard_R=F6jfors?=
	<richard.rojfors.ext@mocean-labs.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, mchehab@infradead.org,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [patch v2 0/1] video: initial support for ADV7180
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a an updated version of my previous patch.

Hans: I have updated the patch according to you feedback (almost). 
Thanks for the feedback btw.
  * I left the state struct even though it only contains the subdev, 
it's for the future when more functions are added in.
  * I left the function for checking the norm, also for the future it's 
for instance possible to get interrupts when the norm is changed, a 
schedule work or equal could then use this function too.

And yes, Mocean laboratories is the author while it's copyrighted to Intel.

--Richard
