Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47301 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab1BEOc2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 09:32:28 -0500
Date: Sat, 5 Feb 2011 15:32:15 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: firedtv and removal of old IEEE1394 stack
Message-ID: <20110205153215.03d55743@stein>
In-Reply-To: <20110205152122.3b566ef0@stein>
References: <201102031706.12714.hverkuil@xs4all.nl>
	<20110205152122.3b566ef0@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 05 Stefan Richter wrote:
> On Feb 03 Hans Verkuil wrote:
> > It would be nice to remove this since building the firedtv driver for older kernels
> > always gives problems on ubuntu due to some missing ieee1394 headers.
> 
> How so?  Then there is something wrong with the backported sources.

Or with the backports' build system perhaps.
-- 
Stefan Richter
-=====-==-== --=- --=-=
http://arcgraph.de/sr/
