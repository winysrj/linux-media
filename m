Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45100 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0CFLw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 6 Mar 2010 06:52:29 -0500
Received: by bwz22 with SMTP id 22so1468814bwz.28
        for <linux-media@vger.kernel.org>; Sat, 06 Mar 2010 03:52:28 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Hendrik Skarpeid <skarp@online.no>
Subject: Re: DM1105: could not attach frontend 195d:1105
Date: Sat, 6 Mar 2010 13:52:06 +0200
Cc: linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
References: <4B7D83B2.4030709@online.no> <201003032105.06263.liplianin@me.by> <4B903127.208@online.no>
In-Reply-To: <4B903127.208@online.no>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201003061352.06763.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 5 марта 2010 00:16:07 Hendrik Skarpeid wrote:
> Igor M. Liplianin skrev:
> > On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
> >> Igor M. Liplianin wrote:
> >>> Now to find GPIO's for LNB power control and ... watch TV :)
> >>
> >> Yep. No succesful tuning at the moment. There might also be an issue
> >> with the reset signal and writing to GPIOCTR, as the module at the
> >> moment loads succesfully only once.
> >> As far as I can make out, the LNB power control is probably GPIO 16 and
> >> 17, not sure which is which, and how they work.
> >> GPIO15 is wired to tuner #reset
> >
> > New patch to test
> >
> > ------------------------------------------------------------------------
> >
> >
> > No virus found in this incoming message.
> > Checked by AVG - www.avg.com
> > Version: 9.0.733 / Virus Database: 271.1.1/2721 - Release Date: 03/03/10
> > 20:34:00
>
> modprobe si21xx debug=1 produces this output when scanning.
>
> [ 2187.998349] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
> [ 2187.998353] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
> [ 2187.999881] si21xx: si21xx_setacquire
> [ 2187.999884] si21xx: si21xx_set_symbolrate : srate = 27500000
> [ 2188.022645] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x01
> [ 2188.054350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
> [ 2188.054355] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
> [ 2188.055875] si21xx: si21xx_setacquire
> [ 2188.055879] si21xx: si21xx_set_symbolrate : srate = 27500000
> [ 2188.110359] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
> [ 2188.110366] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
> [ 2188.111885] si21xx: si21xx_setacquire
> [ 2188.111889] si21xx: si21xx_set_symbolrate : srate = 27500000
> [ 2188.166350] si21xx: si21_read_status : FE_READ_STATUS : VSTATUS: 0x02
> [ 2188.166354] si21xx: si21xx_set_frontend : FE_SET_FRONTEND
>
> Since the tuner at hand uses a Si2109 chip, VSTATUS 0x01 and 0x02 would
> indicate that blind scanning is used. Blind scanning is a 2109/2110
> specific function, and may not very usable since we always use initial
> tuning files anyway. 2109/10 also supports the legacy scanning method
> which is supported by Si2107708.
>
> Is the use of blind scanning intentional?
Yes, of course, it's intentional. Why not?
User has freedom to make little errors in channels.conf file. Also the chip didn't support DVB-S2. 
And last, has who si2107/08 ? My chip is si2109.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
