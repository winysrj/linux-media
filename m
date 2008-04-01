Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.187])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mrechberger@gmail.com>) id 1JgYzW-0006Xz-QT
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 07:25:03 +0200
Received: by rv-out-0910.google.com with SMTP id b22so1331699rvf.41
	for <linux-dvb@linuxtv.org>; Mon, 31 Mar 2008 22:24:57 -0700 (PDT)
Message-ID: <d9def9db0803312224t74300f79o727cb11495077112@mail.gmail.com>
Date: Tue, 1 Apr 2008 07:24:57 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: "Another Sillyname" <anothersname@googlemail.com>
In-Reply-To: <a413d4880803311815x2009eddex2351adc11525db3d@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <a413d4880803301640u20b77b9cya5a812efec8ee25c@mail.gmail.com>
	<c8b4dbe10803311302n6edc8d0dtb1f816099e020946@mail.gmail.com>
	<d9def9db0803311559p3b4fe2a7gfb20477a2ac47144@mail.gmail.com>
	<d9def9db0803311627i6df82e04wc7a6bf8898440637@mail.gmail.com>
	<a413d4880803311815x2009eddex2351adc11525db3d@mail.gmail.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Lifeview DVB-T from v4l-dvb and Pinnacle Hybrid USb
	from v4l-dvb-kernel......help
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

On 4/1/08, Another Sillyname <anothersname@googlemail.com> wrote:
> Markus thanks for the response.
>
> Am I correct in saying that your work will be on the v4l-dvb-kernel
> branch and focused purely on the em28xx devices? Then you'll then be
> migrating this work to v4l-dvb?
>
> Or are you looking to 'clean up' the code that's currently in
> v4l-dvb-kernel? without migrating it to v4l-dvb?
>
> Obviously as I'm looking to get one device working from each branch
> I'm a bit hamstrung at the moment.
>

I already cut out the em28xx support so that it's possible to get it
work with v4l-dvb from linuxtv.org. Although this one only focussed at
a few newer devices for now I'm adding support for all the other
devices from this month on. The biggest part is to go through all the
videostandards and different input methods (svideo/composite).

v4l-dvb-kernel has support for several other devices too which are not
em28xx based and which I got work last year, it wasn't entirely em28xx
focussed.

Markus

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
