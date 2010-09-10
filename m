Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:12625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673Ab0IJNSn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 09:18:43 -0400
Date: Fri, 10 Sep 2010 09:18:29 -0400
From: Jarod Wilson <jarod@redhat.com>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, mchehab@infradead.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/8] IR: extend MCE keymap.
Message-ID: <20100910131829.GD13554@redhat.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
 <1283808373-27876-6-git-send-email-maximlevitsky@gmail.com>
 <AANLkTi=EFZys7NnxixmQL3hqqGfin_VOV7XAWCm0BkwT@mail.gmail.com>
 <1284079254.4828.6.camel@maxim-laptop>
 <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
 <b8a480a446ba264233deebe1e514141a.squirrel@www.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b8a480a446ba264233deebe1e514141a.squirrel@www.hardeman.nu>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Sep 10, 2010 at 10:27:02AM +0200, David Härdeman wrote:
> On Fri, September 10, 2010 03:37, Jarod Wilson wrote:
> > I think for mythtv, we're going to end up having a daemon process with
> > elevated privs that reads directly from input devices to get around
> > this annoyance, until such time as the annoyance is gone.
> 
> A similar approach could work for XBMC since it already has input plugins
> (e.g. for using a Nintendo Wii controller, etc).

While attempting to drift off to sleep last night, it occurred to me that
lircd already has support for attaching to input devices, so it might be
an option to extend lircd and the lirc client library to have a "pass raw
keycodes" mode. Both xmbc and mythtv already have options to build in lirc
client support, so it'd just be minor extension of its use in both cases,
at least in theory...

-- 
Jarod Wilson
jarod@redhat.com

