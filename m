Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-06.arcor-online.net ([151.189.21.46])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <hermann-pitton@arcor.de>) id 1LJVV3-00033d-6z
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 17:06:50 +0100
From: hermann pitton <hermann-pitton@arcor.de>
To: Gregoire Favre <gregoire.favre@gmail.com>
In-Reply-To: <20090104103744.GB3551@gmail.com>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
	<1231057784.2615.9.camel@pc10.localdom.local>
	<20090104103744.GB3551@gmail.com>
Date: Sun, 04 Jan 2009 17:06:59 +0100
Message-Id: <1231085219.2723.1.camel@pc10.localdom.local>
Mime-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,

Am Sonntag, den 04.01.2009, 11:37 +0100 schrieb Gregoire Favre: 
> On Sun, Jan 04, 2009 at 09:29:44AM +0100, hermann pitton wrote:
> 
> Hello,
> 
> > We else need at least i2c_debug enabled on the cx88xx, yes, that is the
> > busmaster :)
> 
> Great, I have to try to do it, but I should first learn of a way to do
> it, I'll report ASAP.
> 
> > I don't deny that strange things happened, wrong tuners loaded without
> > trace so far.
> > 
> > Mike at least had a hotfix, not to allow analog only tuners to oops
> > around.
> 
> Could you point me to an URL for this ?

http://linuxtv.org/hg/v4l-dvb/rev/f9bdc9ff3da1

it must not be related at all, since it is still not clear how the wrong
tuner type sneaked in, could still be caused by user/system options.

But there seem to be some potential module load order problems.
In any case, I would not use "make load" at all trying to debug such!

I just tried and had to reboot on a x86_32 including lost keyboard.

Cheers,
Hermann







_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
