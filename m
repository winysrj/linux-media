Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.tglx.de ([62.245.132.106]:50203 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZCDJd2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 4 Mar 2009 04:33:28 -0500
Date: Wed, 4 Mar 2009 10:32:54 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: Dmitri Belimov <d.belimov@gmail.com>,
	"Hans J. Koch" <koch@hjk-az.de>,
	=?utf-8?Q?Hans-J=C3=BCrgen?= Koch <hjk@linutronix.de>,
	video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: saa7134 and RDS
Message-ID: <20090304093253.GA3244@bluebox.local>
References: <20090302133333.6f89aef0@glory.loctelecom.ru> <1236127388.3324.20.camel@pc09.localdom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236127388.3324.20.camel@pc09.localdom.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Mar 04, 2009 at 01:43:08AM +0100, hermann pitton wrote:
> Hi,
> 
> Am Montag, den 02.03.2009, 13:33 +0900 schrieb Dmitri Belimov:
> > Hi All.
> > 
> > I want use RDS on our TV cards. But now saa7134 not work with saa6588.
> > I found this old patch from Hans J. Koch. Why this patch is not in mercurial??
> > Yes I know that patch for v4l ver.1 and for old kernel. But why not?? 
> > v4l has other way for RDS on saa7134 boards?
> 
> I think the patch got lost, because it was not clear who should pull it
> in. Likely Hartmut or Mauro would have picked it up in 2006 if pinged
> directly.

The main reason was that at that time there was a conflict with the i2c
ir keyboard driver. I couldn't fix it immediately and was occupied with
different things afterwards. I don't know if saa7134 i2c got fixed
in the meantime.

> 
> Please try to work with Hans to get it in now. There was also a
> suggestion to add a has_rds capability flag and about how to deal with
> different RDS decoders later, IIRC.

Right. We should have a flag you could set to something like
  .has_rds = RDS_SAA6588
so that the rds driver could be loaded automagically.

But I'm afraid I cannot spend much time on this work ATM, sorry.

Thanks,
Hans

