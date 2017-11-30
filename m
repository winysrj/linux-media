Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:37887 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752816AbdK3Ox1 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Nov 2017 09:53:27 -0500
Date: Thu, 30 Nov 2017 12:53:17 -0200
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: "# 3.4.x" <stable@vger.kernel.org>, Sergey Kozlov <serjk@netup.ru>,
        Abylay Ospan <aospan@netup.ru>,
        Daniel Scheller <d.scheller@gmx.net>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RESEND 1/2] dvb-frontends: fix i2c access helpers for
 KASAN
Message-ID: <20171130125317.1cfb4c09@vento.lan>
In-Reply-To: <CAK8P3a0dp0S8h0pV+1mexD=-LdRRW8D55tLmx5x9usCQkzNTqw@mail.gmail.com>
References: <20171130110939.1140969-1-arnd@arndb.de>
        <20171130104934.30dcfdf6@vento.lan>
        <CAK8P3a0dp0S8h0pV+1mexD=-LdRRW8D55tLmx5x9usCQkzNTqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 30 Nov 2017 15:06:15 +0100
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Thu, Nov 30, 2017 at 1:49 PM, Mauro Carvalho Chehab
> <mchehab@kernel.org> wrote:
> >> Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=81715
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> ---
> >> I'm undecided here whether there should be a comment pointing
> >> to PR81715 for each file that the bogus local variable workaround
> >> to prevent it from being cleaned up again. It's probably not
> >> necessary since anything that causes actual problems would also
> >> trigger a build warning.  
> 
> >
> > This kind of sucks, and it is completely unexpected... why val is
> > so special that it would require this kind of hack?  
> 
> It's explained in the gcc bug report: basically gcc always skipped
> one optimization on inline function arguments that it does on
> normal variables. Without KASAN and asan-stack, we didn't
> notice because the impact was fairly small, but I ended up finally
> getting to the bottom of it in September, and it finally got fixed.
> 
> I had an older version of the patch that was much more invasive
> before we understood what exactly is happening, see
> https://lkml.org/lkml/2017/3/2/484

Yeah, I saw the old versions and I'm following this thread.

> > Also, there's always a risk of someone see it and decide to
> > simplify the code, returning it to the previous state.
> >
> > So, if we're willing to do something like that, IMHO, we should have
> > some macro that would document it, and fall back to the direct
> > code if the compiler is not gcc 5, 6 or 7.  
> 
> Older compilers are also affected and will produce better code
> with my change, the difference is just smaller without asan-stack
> (added ion gcc-5) is disabled, since that increases the stack
> space used by each variable to (IIRC) 32 bytes.
> 
> The fixed gcc-8 produces identical code with and without my
> change.
> 
> I don't think that a macro would help here at all, but if you
> prefer, I could add a link to that gcc bug in each function that
> has the problem.

My main concern here is to avoid someone to undo the changes.
Adding a quick note on each of those changes is helpful, in
order to warn people and refrain undoing.

So, adding a quick comment works for me.

Regards,
Mauro
