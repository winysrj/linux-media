Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:45682 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753932Ab3HVSGJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 14:06:09 -0400
Date: Thu, 22 Aug 2013 15:06:04 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Javier =?utf-8?B?QsO6Y2Fy?= <jbucar@lifia.info.unlp.edu.ar>
Cc: Luis Polasek <lpolasek@gmail.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Olivier GRENIE <olivier.grenie@parrot.com>,
	Patrick BOETTCHER <patrick.boettcher@parrot.com>
Subject: Re: dib8000 scanning not working on 3.10.3
Message-ID: <20130822180603.GA14784@localhost>
References: <CAER7dwe+kkVoDbRt9Xj8+77tJnL29bxRzHbSPYOrck_HxVsENw@mail.gmail.com>
 <CAER7dwe8UQZ=5iZhCi1C1-DGi7t_Hz43M4QamnBSNerHNnDCvg@mail.gmail.com>
 <20130801163624.GA10498@localhost>
 <20130801141518.258ff0a3@samsung.com>
 <CAER7dwe9biLNZKtW6xQmD8J0Qmh4dMTi=chpUuQ_Dq5KKxJ5UQ@mail.gmail.com>
 <20130805172605.1ba32958@samsung.com>
 <CAER7dwcDxa4=i453tOU21ZJP9Opd01mZ-QYrLpQTcgB_yU4B+Q@mail.gmail.com>
 <CAJmEX9B=VAEXSto2omRTNcgVdX7akDBUAhJs7nwPUc9xhqFBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJmEX9B=VAEXSto2omRTNcgVdX7akDBUAhJs7nwPUc9xhqFBbg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mauro, Javier,

On Thu, Aug 22, 2013 at 02:47:33PM -0300, Javier Búcar wrote:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=173a64cb3fcff1993b2aa8113e53fd379f6a968f
> 
> This is a very big commit. I don't known where to fix it. Can you help

That's not a commit: that's a monster :-(

That should have been heavily splitted. Now a user (Javier and Luis)
is allegedly reporting a regression, but that commit is almost
impossible to understand, and probably very difficult to revert.

I hate to get grumpy, but this does not look nice!
Even the commit log sucks: what does ""dib8000: enhancement"" suppose to mean?

Javier/Luis: (for the second time) please try to avoid top-posting
in the future, it breaks the thread discussion.
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
