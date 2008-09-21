Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ug-out-1314.google.com ([66.249.92.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1KhPxC-0006DI-W6
	for linux-dvb@linuxtv.org; Sun, 21 Sep 2008 16:30:29 +0200
Received: by ug-out-1314.google.com with SMTP id 39so3559824ugf.16
	for <linux-dvb@linuxtv.org>; Sun, 21 Sep 2008 07:30:23 -0700 (PDT)
Message-ID: <412bdbff0809210730i75f835cl54e48f70432dde1b@mail.gmail.com>
Date: Sun, 21 Sep 2008 10:30:23 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Jonathan Coles" <jcoles0727@rogers.com>
In-Reply-To: <48D658BF.7040807@rogers.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <48D658BF.7040807@rogers.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Still unclear how to use Hauppage HVR-950 and
	v4l-dvb
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

On Sun, Sep 21, 2008 at 10:22 AM, Jonathan Coles <jcoles0727@rogers.com> wrote:
> It would really help if there was a single set of instructions specific
> to the HVR-950 with tests at each stage. I'm really confused as to the
> status of my installation.
>
> I compiled the firmware according to the instructions on
> http://linuxtv.org/repo/. The result:
>
> $ lsusb
> Bus 005 Device 002: ID 2040:7200 Hauppauge

Hold the phone!  You don't have an HVR-950.  You have an HVR-950Q.
Please be sure to mention this in all future messages, since it's a
totally different device and the HVR-950 directions do not apply.

I'm not sure whether the HVR-950Q support has been merged yet.  Steven
could comment on that.  I suspect it's still in a separate branch,
which would mean you would need to do an hg clone of a different tree.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
