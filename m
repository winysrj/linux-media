Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47997 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab1EESkr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 May 2011 14:40:47 -0400
Received: by ewy4 with SMTP id 4so758812ewy.19
        for <linux-media@vger.kernel.org>; Thu, 05 May 2011 11:40:46 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: DM1105: could not attach frontend 195d:1105
Cc: Hendrik Skarpeid <skarp@online.no>, linux-media@vger.kernel.org,
	Nameer Kazzaz <nameer.kazzaz@gmail.com>
From: "Igor M. Liplianin" <liplianin@me.by>
Date: Thu, 5 May 2011 21:41:26 +0300
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105052141.26877.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 4 мая 2011 00:33:51 автор Mauro Carvalho Chehab написал:
> Hi Igor,
> 
> Em 23-10-2010 07:20, Igor M. Liplianin escreveu:
> > В сообщении от 10 марта 2010 14:15:49 автор Hendrik Skarpeid написал:
> >> Igor M. Liplianin skrev:
> >>> On 3 марта 2010 18:42:42 Hendrik Skarpeid wrote:
> >>>> Igor M. Liplianin wrote:
> >>>>> Now to find GPIO's for LNB power control and ... watch TV :)
> >>>> 
> >>>> Yep. No succesful tuning at the moment. There might also be an issue
> >>>> with the reset signal and writing to GPIOCTR, as the module at the
> >>>> moment loads succesfully only once.
> >>>> As far as I can make out, the LNB power control is probably GPIO 16
> >>>> and 17, not sure which is which, and how they work.
> >>>> GPIO15 is wired to tuner #reset
> >>> 
> >>> New patch to test
> >> 
> >> I think the LNB voltage may be a little to high on my card, 14.5V and
> >> 20V. I would be a little more happy if they were 14 and 19, 13 and 18
> >> would be perfect.
> >> Anyways, as Igor pointet out, I don't have any signal from the LNB,
> >> checked with another tuner card. It's a quad LNB, and the other outputs
> >> are fine. Maybe it's' toasted from to high supply voltage! I little word
> >> of warning then.
> >> Anyways, here's my tweaked driver.
> > 
> > Here is reworked patch for clear GPIO's handling.
> > It allows to support I2C on GPIO's and per board LNB control through
> > GPIO's. Also incuded support for Hendrik's card.
> > I think it is clear how to change and test GPIO's for LNB and other stuff
> > now.
> > 
> > To Hendrik:
> > 	Not shure, but there is maybe GPIO for raise/down LNB voltage a little
> > 	(~1v). It is used for long coaxial lines to compensate voltage
> > 	dropping.
> > 
> > Signed-off-by: Igor M. Liplianin <liplianin@me.by>
> 
> I'm not sure if this patch is still valid or not, and if it should or not
> be applied, as there were several discussions around it. As a reference,
> it is stored at patchwork with:
> 	X-Patchwork-Id: 279091
> 
> And still applies fine (yet, patchwork lost patch history/comments and
> SOB).
> 
> Igor, could you please update me if I should apply this patch or if the
> patch got rejected/superseeded?
> 
> Thanks!
> Mauro.
Hi Mauro,
The patch should be applied.
Do I need to do something, it means apply to a tree and send pull request? 

Thanks!
Igor
-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
