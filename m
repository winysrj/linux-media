Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:55350 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbZJDWY2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 4 Oct 2009 18:24:28 -0400
Received: by bwz6 with SMTP id 6so2119424bwz.37
        for <linux-media@vger.kernel.org>; Sun, 04 Oct 2009 15:23:51 -0700 (PDT)
Date: Mon, 5 Oct 2009 01:23:47 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Jean Delvare <khali@linux-fr.org>,
	"Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	Oldrich Jedlicka <oldium.pro@seznam.cz>, hverkuil@xs4all.nl
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV
	M116 for newer kernels
Message-ID: <20091004222347.GA31609@moon>
References: <1254584660.3169.25.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254584660.3169.25.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 03, 2009 at 11:44:20AM -0400, Andy Walls wrote:
> Aleksandr and Jean,
> 
> Zdrastvoitye & Bonjour,
> 
> To support the AVerMedia M166's IR microcontroller in ivtv and
> ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in
> 
> 	http://linuxtv.org/hg/~awalls/ivtv
> 

Now the last step to the decent support of M116 remote.

I spent hours banging my head against the wall, controller just doesn't
give a stable keypresses, skips a lot of them. Increasing polling interval
from default 100 ms to 400-500 ms helps a bit, but it only masks the
problem. Decreasing polling interval below 50ms makes it skip virtually
90% of keypresses.

Basicly during the I2C operation that reads scancode, controller seems
to stop processing input from IR sensor, resulting a loss of keypress.

So the solution(?) I found was to decrease the udelay in
ivtv_i2c_algo_template from 10 to 5. Guess it just doubles the frequency
of ivtv i2c bus or something like that. Problem went away, IR controller
is now working as expected.

So question is:
1) Is it ok to decrease udelay for this board?
2) If yes, how to do it right?
