Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:35347 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbZL3NXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 08:23:41 -0500
Received: by qw-out-2122.google.com with SMTP id 8so1134699qwh.37
        for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 05:23:40 -0800 (PST)
Date: Wed, 30 Dec 2009 11:26:08 -0200
From: Nicolau Leal Werneck <nwerneck@gmail.com>
To: leandro Costantino <lcostantino@gmail.com>
Cc: linux-media@vger.kernel.org, Jean-Francois Moine <moinejf@free.fr>
Subject: Re: patch to support for 0x0802 sensor in t613.c
Message-ID: <20091230112608.49bf2ae2@Nokia-N800-43-7>
In-Reply-To: <c2fe070d0912300156o28c34842g43b5c90bcb48f765@mail.gmail.com>
References: <20091218184604.GA24444@pathfinder.pcs.usp.br>
	<20091218201349.69ca27a5@tele>
	<c2fe070d0912181352j7c8a8085sf14d8ea68fe63ddb@mail.gmail.com>
	<c2fe070d0912300156o28c34842g43b5c90bcb48f765@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 30 Dec 2009 04:56:03 -0500
leandro Costantino <lcostantino@gmail.com> escreveu:

Hello. Thanks for the help! The problem is I'm away from home, on
vacation. Also my two computers back home are not workig. But I'm
going to work with that again at my lab next week, at most.

I'll take the chance to ask: where do the gamma correction table values
come from? Because I got slightly different values from the driver I
sniffed...

See you,
  ++nicolau


> Hi Nicoulau,
> could you try the attached patch and add the Signed-Off by  so we can
> merge it???
> It's your patch, just removed some lines.
> 
> Best Regards
> 
> 
> On Fri, Dec 18, 2009 at 4:52 PM, leandro Costantino
> <lcostantino@gmail.com> wrote:
> > Nicolau, if you need help, let me know.
> > I also, sent you some mails asking for the patch for review some
> > weeks ago, i thougth you were missing :)
> > good woork
> > best regards
> >
> > On Fri, Dec 18, 2009 at 8:13 PM, Jean-Francois Moine
> > <moinejf@free.fr> wrote:
> >> On Fri, 18 Dec 2009 16:46:04 -0200
> >> Nicolau Werneck <nwerneck@gmail.com> wrote:
> >>
> >>> Hello. I am a clueless n00b, and I can't make patches or use any
> >>> proper development tools. But I made this modification to t613.c
> >>> to support this new sensor. It is working fine with me. I just
> >>> cleaned the code up a bit and compiled and tested with the 2.6.32
> >>> kernel, and it seems to be working fine.
> >>>
> >>> If somebody could help me creating a proper patch to submit to the
> >>> source tree, I would be most grateful. The code is attached.
> >>
> >> Hello Nicolau,
> >>
> >> Your code seems fine. To create a patch, just go to the linux tree
> >> root, make a 'diff -u' from the original file to your new t613.c,
> >> edit it, at the head, add a comment and a 'Signed-off-by: <your
> >> email>', and submit to the mailing-list with subject '[PATCH]
> >> email>gspca - t613: Add new
> >> sensor lt168g'.
> >>
> >> BTW, as you know the name of your sensor, do you know the real
> >> name of the sensor '0x803' ('other')? (it should be in some
> >> xxx.ini file in a ms-win driver, but I could not find it - the
> >> table n4_other of t613.c should be a table 'Regxxx' in the xx.ini)

