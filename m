Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36325 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687Ab0IJIki (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Sep 2010 04:40:38 -0400
Subject: Re: [PATCH 5/8] IR: extend MCE keymap.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: lirc-list@lists.sourceforge.net,
	David =?ISO-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	mchehab@infradead.org, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org
In-Reply-To: <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
References: <1283808373-27876-1-git-send-email-maximlevitsky@gmail.com>
	 <1283808373-27876-6-git-send-email-maximlevitsky@gmail.com>
	 <AANLkTi=EFZys7NnxixmQL3hqqGfin_VOV7XAWCm0BkwT@mail.gmail.com>
	 <1284079254.4828.6.camel@maxim-laptop>
	 <AANLkTik4HAspKxOpH1VcT0+TnGa=H+-M2Wpxg5MefPg1@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Sep 2010 11:40:31 +0300
Message-ID: <1284108031.3498.31.camel@maxim-laptop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Thu, 2010-09-09 at 21:37 -0400, Jarod Wilson wrote: 
> On Thu, Sep 9, 2010 at 8:40 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> > On Wed, 2010-09-08 at 10:47 -0400, Jarod Wilson wrote:
> >> On Mon, Sep 6, 2010 at 5:26 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> >> > These keys are found on remote bundled with
> >> > Toshiba Qosmio F50-10q.
> >> >
> >> > Found and tested by, Sami R <maesesami@gmail.com>
> >> >
> >> > Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
> >> > ---
> >> >  drivers/media/IR/keymaps/rc-rc6-mce.c |    3 +++
> >> >  1 files changed, 3 insertions(+), 0 deletions(-)
> >
> > Tommorow I will resend that patch with even more scancodes.
> 
> Saw the discussion on irc. Feel your pain big-time on the X server
> limitation on keycodes. Its put a big damper on efforts to add native
> support to mythtv. Peter Hutterer's libXi2 cookbook tutorials talk a
> good game about how libXi2 supports 32-bit keycodes, but neglects to
> mention that the X server still gobbles up anything above 248 or 255
> or whatever it is, and remedying that is no small task. :(
> 
> I think for mythtv, we're going to end up having a daemon process with
> elevated privs that reads directly from input devices to get around
> this annoyance, until such time as the annoyance is gone.


Btw, indeed Xi2 still doesn't pass > 248 keycodes, just tested that with
-git versions of X stack from about 2 months ago.
However this can be fixed relatively easily.
Maybe even I could do that.

The big problem is however about ability to map extended keycodes to
actions, thing that should be provided by XKB2, which we will see
probably when DNF is released on Phantom console...
Also this will need lots of changes in toolkits.
Thats the problem I don't have resources to fix.

Best regards,
Maxim Levitsky


