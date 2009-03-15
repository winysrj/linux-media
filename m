Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:37542 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbZCOW2v (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 15 Mar 2009 18:28:51 -0400
Date: Sun, 15 Mar 2009 23:28:42 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: bttv, tvaudio and ir-kbd-i2c probing conflict
Message-ID: <20090315232842.62ea5417@hyperion.delvare>
In-Reply-To: <200903152309.05803.hverkuil@xs4all.nl>
References: <200903151344.01730.hverkuil@xs4all.nl>
	<20090315181207.36d951ac@hyperion.delvare>
	<1237145673.3314.47.camel@palomino.walls.org>
	<200903152309.05803.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 15 Mar 2009 23:09:05 +0100, Hans Verkuil wrote:
> Actually, it seems like this used to work at one time in the past. Jean, can 
> you confirm that it used to be possible to have two i2c clients at the same 
> i2c address in the past? Looking at the post (see the link in my original 
> mail) it apparently worked in 2.6.19 at least.

No, it has never been possible. I can't explain why it used to work (if
it really did...) Maybe the reporter was using an alternative
implementation doing raw bus transfers? You originally suggested that
lirc was doing this.

> I do think that the initial approach to this is to ensure that tvaudio is at 
> least working. After all, it is better to have audio and no remote than to 
> have a working remote, but no audio. Until we find a proper solution I 
> think that this should not stop us from going forward since this way we 
> remain bug-compatible with the current situation. Or even slightly better 
> since we can now ensure that audio is working at least.

Agreed.

-- 
Jean Delvare
