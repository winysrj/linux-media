Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53144 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354AbZFCFVq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Jun 2009 01:21:46 -0400
Date: Wed, 3 Jun 2009 02:21:13 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org, Terry Wu <terrywu2009@gmail.com>,
	mchehab@infradead.org
Subject: Re: [hg:v4l-dvb] Fix firmware load for DVB-T @ 6MHz
Message-ID: <20090603022113.1725b17b@pedra.chehab.org>
In-Reply-To: <1243900599.3959.9.camel@palomino.walls.org>
References: <E1MB9Iw-0003dY-4q@mail.linuxtv.org>
	<1243900599.3959.9.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Mon, 01 Jun 2009 19:56:39 -0400
Andy Walls <awalls@radix.net> escreveu:

> I looks like it accomplishes the 6 MHz DVB-T support in
> xc2028_set_params() that Terry needed.  I personally wouldn't have
> disabled the FE_QAM stuff.  However it doesn't matter as far as current
> Linux driver use of the XC3028 is concerned - no driver currently sets
> up the XC3028 with a DVB-C demod.

All trials of using FE_QAM failed, and nobody ever returned based on that
dmesg. I was asked in the past to remove it, but I nacked, to avoid the risk of
loosing something.

The discover that the qam firmware is, in fact, for Taiwan is the missing part of
the puzzle.

-- 

Cheers,
Mauro
