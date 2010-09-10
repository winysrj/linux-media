Return-path: <mchehab@pedra>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:34754 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0IJI1E (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:27:04 -0400
Message-ID: <b8a480a446ba264233deebe1e514141a.squirrel@www.hardeman.nu>
In-Reply-To: <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
    <1283808373-27876-6-git-send-email-maximlevitsky@gmail.com>
    <AANLkTi=EFZys7NnxixmQL3hqqGfin_VOV7XAWCm0BkwT@mail.gmail.com>
    <1284079254.4828.6.camel@maxim-laptop>
    <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
Date: Fri, 10 Sep 2010 10:27:02 +0200 (CEST)
Subject: Re: [PATCH 5/8] IR: extend MCE keymap.
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: "Jarod Wilson" <jarod@wilsonet.com>
Cc: "Maxim Levitsky" <maximlevitsky@gmail.com>,
	lirc-list@lists.sourceforge.net, mchehab@infradead.org,
	linux-input@vger.kernel.org, linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, September 10, 2010 03:37, Jarod Wilson wrote:
> I think for mythtv, we're going to end up having a daemon process with
> elevated privs that reads directly from input devices to get around
> this annoyance, until such time as the annoyance is gone.

A similar approach could work for XBMC since it already has input plugins
(e.g. for using a Nintendo Wii controller, etc).

-- 
David Härdeman

