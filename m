Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mu-out-0910.google.com ([209.85.134.189])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJVz5-0005FZ-Ug
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 17:37:54 +0100
Received: by mu-out-0910.google.com with SMTP id g7so2724645muf.1
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 08:37:48 -0800 (PST)
Date: Sun, 4 Jan 2009 17:37:44 +0100
To: hermann pitton <hermann-pitton@arcor.de>
Message-ID: <20090104163744.GA3521@gmail.com>
References: <op.um6wpcvirj95b0@localhost>
	<c74595dc0901030928r7a3e3353h5c2a44ffd8ffd82f@mail.gmail.com>
	<op.um60szqyrj95b0@localhost>
	<c74595dc0901031058u3ad48036y2e09ec1475174995@mail.gmail.com>
	<20090103193718.GB3118@gmail.com> <20090104111429.1f828fc8@bk.ru>
	<1231057784.2615.9.camel@pc10.localdom.local>
	<20090104103744.GB3551@gmail.com>
	<1231085219.2723.1.camel@pc10.localdom.local>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1231085219.2723.1.camel@pc10.localdom.local>
From: Gregoire Favre <gregoire.favre@gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DVB-S Channel searching problem
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On Sun, Jan 04, 2009 at 05:06:59PM +0100, hermann pitton wrote:

Hello,

> it must not be related at all, since it is still not clear how the wrong
> tuner type sneaked in, could still be caused by user/system options.
> =

> But there seem to be some potential module load order problems.
> In any case, I would not use "make load" at all trying to debug such!
> =

> I just tried and had to reboot on a x86_32 including lost keyboard.

Oh, then I am not the only one with this lost keyboard problem ;-)
I hope you got an sshd open on your computer and could reboot without
too much troubles ?

So, would it be right in order to debug this to compil an updated
v4l-dvb's hg with debug enabled, then "make install" from v4l dir, and
issue :

modprobe budget_ci
modprobe cx8800
modprobe cx88_alsa
modprobe cx88-dvb

? (sorry for long question)

Thank you very much,
-- =

Gr=E9goire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
