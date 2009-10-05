Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.seznam.cz ([77.75.72.43]:42989 "EHLO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZJESqM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 14:46:12 -0400
From: Oldrich Jedlicka <oldium.pro@seznam.cz>
To: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
Subject: Re: [REVIEW] ivtv, ir-kbd-i2c: Explicit IR support for the AVerTV M116 for newer kernels
Date: Mon, 5 Oct 2009 20:45:20 +0200
Cc: Andy Walls <awalls@radix.net>, Jean Delvare <khali@linux-fr.org>,
	Jarod Wilson <jarod@wilsonet.com>, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl
References: <1254584660.3169.25.camel@palomino.walls.org> <20091004222347.GA31609@moon>
In-Reply-To: <20091004222347.GA31609@moon>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910052045.20676.oldium.pro@seznam.cz>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Monday 05 of October 2009 at 00:23:47, Aleksandr V. Piskunov wrote:
> On Sat, Oct 03, 2009 at 11:44:20AM -0400, Andy Walls wrote:
> > Aleksandr and Jean,
> >
> > Zdrastvoitye & Bonjour,
> >
> > To support the AVerMedia M166's IR microcontroller in ivtv and
> > ir-kbd-i2c with the new i2c binding model, I have added 3 changesets in
> >
> > 	http://linuxtv.org/hg/~awalls/ivtv
>
> Now the last step to the decent support of M116 remote.
>
> I spent hours banging my head against the wall, controller just doesn't
> give a stable keypresses, skips a lot of them. Increasing polling interval
> from default 100 ms to 400-500 ms helps a bit, but it only masks the
> problem. Decreasing polling interval below 50ms makes it skip virtually
> 90% of keypresses.
>
> Basicly during the I2C operation that reads scancode, controller seems
> to stop processing input from IR sensor, resulting a loss of keypress.

Hi Aleksandr,

Just a side note. If your M166 has the same remote control chip as my CardBus 
Plus/Hybrid (I2C address 0x40), then I have to say it is very fragile. From 
my experience it doesn't like probing (empty read), when reading the value it 
doesn't like interruptions (you have to write the address and read 
immediately). So I wouldn't be surprised if it doesn't work under some other 
conditions.

Regards,
Oldrich.

>
> So the solution(?) I found was to decrease the udelay in
> ivtv_i2c_algo_template from 10 to 5. Guess it just doubles the frequency
> of ivtv i2c bus or something like that. Problem went away, IR controller
> is now working as expected.
>
> So question is:
> 1) Is it ok to decrease udelay for this board?
> 2) If yes, how to do it right?


