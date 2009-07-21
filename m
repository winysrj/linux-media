Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:13388 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbZGUHqm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Jul 2009 03:46:42 -0400
Date: Tue, 21 Jul 2009 09:45:37 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andy Walls <awalls@radix.net>
Cc: LMML <linux-media@vger.kernel.org>
Subject: Re: ir-kbd-i2c: Drop irrelevant inline keywords
Message-ID: <20090721094537.1679c654@hyperion.delvare>
In-Reply-To: <1248134984.3148.78.camel@palomino.walls.org>
References: <20090719145936.0c21917f@hyperion.delvare>
	<1248134984.3148.78.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Jul 2009 20:09:44 -0400, Andy Walls wrote:
> On Sun, 2009-07-19 at 14:59 +0200, Jean Delvare wrote:
> > Functions which are referenced by their address can't be inlined by
> > definition.
> > 
> > Signed-off-by: Jean Delvare <khali@linux-fr.org>
> 
> Jean,
> 
> Looks godd to me, but you forgot to add [PATCH] to the subject.  I'll
> add this one to my revised patch set I submit to the list, unless you
> object.

Oops, you're right. Yes, please pick it up and push it forward, thanks!

-- 
Jean Delvare
