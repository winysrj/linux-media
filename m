Return-path: <linux-media-owner@vger.kernel.org>
Received: from yop.chewa.net ([91.121.105.214]:56416 "EHLO yop.chewa.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1KBLQw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Nov 2011 07:16:52 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 02 Nov 2011 12:16:51 +0100
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
In-Reply-To: <20111102105804.GA15491@minime.bse>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com> <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net> <201111011349.47132.laurent.pinchart@ideasonboard.com> <20111102091046.GA14955@minime.bse> <20111102101449.GC22159@valkosipuli.localdomain> <20111102105804.GA15491@minime.bse>
Message-ID: <346e9709d02ee99af76e0d2ccaf698d8@chewa.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 2 Nov 2011 11:58:04 +0100, Daniel Glöckner <daniel-gl@gmx.net>

wrote:

>> Converting between the two can be done when making the timestamp but

it's

>> non-trivial at other times and likely isn't supported. I could be

wrong,

>> though. This might lead to e.g. timestamps that are taken before

>> switching

>> to summer time and for which the conversion is done after the switch.

>> This might be a theoretical possibility, but there might be also

>> unfavourable interaction with the NTP.

> 

> Summertime/wintertime is purely a userspace thing. UTC as returned by

> gettimeofday is unaffected by that.



Right, DST is a non-issue.



> NTP AFAIK adjusts the speed of the monotonic clock, so there is a

constant

> delta between wall clock time and clock monotonic



For NTP it depends. Simple NTP, as in ntpdate, warps the wall clock.

Full-blown NTP only adjusts the speed.



> unless there is a leap

> second or someone calls settimeofday. Applications currently using the

> wall clock timestamps should have trouble dealing with that as well.



I can think of at least three other sources of wall clock time, that could

trigger a warp:

 - GPS receiver (TAI),

 - cellular modem (NITZ),

 - and, of course, manual setting.



So if at all possible I'd much prefer monotonic over real timestamps.



-- 

Rémi Denis-Courmont

http://www.remlab.net/
