Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab0DJAfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Apr 2010 20:35:12 -0400
Message-ID: <4BBFC7B8.8080505@infradead.org>
Date: Fri, 09 Apr 2010 21:35:04 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC3] Teach drivers/media/IR/ir-raw-event.c to use durations
References: <20100408113910.GA17104@hardeman.nu> <1270812351.3764.66.camel@palomino.walls.org>
In-Reply-To: <1270812351.3764.66.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy Walls wrote:
> On Thu, 2010-04-08 at 13:39 +0200, David Härdeman wrote:

> Encoding pulse vs space with a negative sign, even if now hidden with
> macros, is still just using a sign instead of a boolean.  Memory in
> modern computers (and now microcontrollers) is cheap and only getting
> cheaper.  Don't give up readability, flexibility, or mainatainability,
> for the sake of saving memory.

Btw, a bad side effect of using the negative sign is that enabling debug will
present those messages, showing negative number of units and time to the poor user:

[42889.320163] ir_rc5_decode: RC5(x) decode started at state 1 (-1 units, -816us)
[42889.320166] ir_rc6_decode: RC6 decode started at state 0 (-2 units, -816us)
[42889.320169] ir_rc6_decode: RC6 decode failed at state 0 (-2 units, -816us)

It seems we need a debug macro also.

-- 

Cheers,
Mauro
