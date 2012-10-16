Return-path: <linux-media-owner@vger.kernel.org>
Received: from 1010ds2-suoe.0.fullrate.dk ([90.184.90.115]:17851 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087Ab2JPTGH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Oct 2012 15:06:07 -0400
Date: Tue, 16 Oct 2012 21:06:04 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] stk1160: Check return value of stk1160_read_reg()
 in stk1160_i2c_read_reg()
In-Reply-To: <CALF0-+UfoS1MBTeR6ZYNdPwACo+h2PR2E4WfC-aZca4g_Pmpjw@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1210162105050.6039@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.0811091803320.23782@swampdragon.chaosbits.net> <CALF0-+Vtmwu9rCc9BYiDx2O2GQWezK40BYR2LP_ve2YjCt=Afg@mail.gmail.com> <alpine.LNX.2.00.1210152025300.1038@swampdragon.chaosbits.net> <alpine.LNX.2.00.1210160051100.1682@swampdragon.chaosbits.net>
 <CALF0-+UuB0y_8+SLE05Sn997HDcP5u=AJsoGvjmfSUBB__DkhQ@mail.gmail.com> <alpine.LNX.2.00.1210160131240.1682@swampdragon.chaosbits.net> <CALF0-+UfoS1MBTeR6ZYNdPwACo+h2PR2E4WfC-aZca4g_Pmpjw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 15 Oct 2012, Ezequiel Garcia wrote:

> On Mon, Oct 15, 2012 at 9:03 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> > On Mon, 15 Oct 2012, Ezequiel Garcia wrote:
> >
> >> On Mon, Oct 15, 2012 at 7:52 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> >> > On Mon, 15 Oct 2012, Jesper Juhl wrote:
> >> >
> >> >> On Sat, 13 Oct 2012, Ezequiel Garcia wrote:
> >> >>
> > [...]
> >> > Currently there are two checks for 'rc' being less than zero with no
> >> > change to 'rc' between the two, so the second is just dead code.
> >> > The intention seems to have been to assign the return value of
> >> > 'stk1160_read_reg()' to 'rc' before the (currently dead) second check
> >> > and then test /that/. This patch does that.
> >> >
> >>
> >> This is an overly complicated explanation for such a small patch.
> >> Can you try to simplify it?
> >>
> > How's this?
> >
> >
> > From: Jesper Juhl <jj@chaosbits.net>
> > Date: Sat, 13 Oct 2012 00:16:37 +0200
> > Subject: [PATCH] [media] stk1160: Check return value of stk1160_read_reg() in stk1160_i2c_read_reg()
> >
> > Remember to collect the exit status from 'stk1160_read_reg()' in 'rc'
> > before testing it for less than zero.
> >
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/media/usb/stk1160/stk1160-i2c.c |    3 +--
> >  1 files changed, 1 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
> > index 176ac93..a2370e4 100644
> > --- a/drivers/media/usb/stk1160/stk1160-i2c.c
> > +++ b/drivers/media/usb/stk1160/stk1160-i2c.c
> > @@ -116,10 +116,9 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
> >         if (rc < 0)
> >                 return rc;
> >
> > -       stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> > +       rc = stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
> >         if (rc < 0)
> >                 return rc;
> > -
> ^^^^^^^^^^^^^^^^^^^^^^^^
> Sorry for the nitpick, but I'd like you to *not* remove this line.
> 
No problem.
I hope the below is OK :-)


From: Jesper Juhl <jj@chaosbits.net>
Date: Sat, 13 Oct 2012 00:16:37 +0200
Subject: [PATCH] [media] stk1160: Check return value of stk1160_read_reg() in stk1160_i2c_read_reg()

Remember to collect the exit status from 'stk1160_read_reg()' in 'rc'
before testing it for less than zero.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/media/usb/stk1160/stk1160-i2c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-i2c.c b/drivers/media/usb/stk1160/stk1160-i2c.c
index 176ac93..850cf28 100644
--- a/drivers/media/usb/stk1160/stk1160-i2c.c
+++ b/drivers/media/usb/stk1160/stk1160-i2c.c
@@ -116,7 +116,7 @@ static int stk1160_i2c_read_reg(struct stk1160 *dev, u8 addr,
 	if (rc < 0)
 		return rc;
 
-	stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
+	rc = stk1160_read_reg(dev, STK1160_SBUSR_RD, value);
 	if (rc < 0)
 		return rc;
 
-- 
1.7.1


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

