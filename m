Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44257 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755442Ab2FVQFd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jun 2012 12:05:33 -0400
Received: by obbuo13 with SMTP id uo13so2122187obb.19
        for <linux-media@vger.kernel.org>; Fri, 22 Jun 2012 09:05:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FE4956D.6040206@gmail.com>
References: <4FE24132.4090705@gmail.com>
	<CAGoCfixL-tEFq4SpjxChH7uc0aDZGtdoO6EqrEH3tzPzoTqK8w@mail.gmail.com>
	<4FE3A3A6.5050500@gmail.com>
	<CAGoCfiympaYxeypnq0uuX_azsHhk3OFuLu-=r0yEvOz51Eznqw@mail.gmail.com>
	<4FE4956D.6040206@gmail.com>
Date: Fri, 22 Jun 2012 12:05:32 -0400
Message-ID: <CAGoCfiwkZyLHtGc7rLj4=7Tp_iBGLOaDfF+V2v5=au5awDH-zQ@mail.gmail.com>
Subject: Re: Chipset change for CX88_BOARD_PINNACLE_PCTV_HD_800i
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mack Stanley <mcs1937@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 22, 2012 at 11:55 AM, Mack Stanley <mcs1937@gmail.com> wrote:
> Your absolutely right about the tuning problem.  The VID's and AID's
> were all wrong.  The card seems to have been choosing more at less at
> random among the channels on the same frequency.  I copied the correct
> VID's and AID's out of the DTA by hand and now everything is A-OK.

That's not the card.  It's the scanning app that is screwed up.  The
card knows absolutely nothing about parsing PAT/PMT info and figuring
out which PIDs are tied to which streams.  If you've got another
capture card, you should see the exact same behavior.

> So, keeping all of the configuration settings exactly the same and
> simply using s5h1411_attach instead of s5h1409_attach works perfectly.
> Maybe the easiest path is just to have the driver try one, if it fails,
> try the other.

After discussion with my PCTV contact, I think that's probably the
correct approach (assuming the I2C addresses are different for the
1409 vs. the 1411).  Just do an attach against one, and if it fails
(returns NULL) then attempt to attach to the other.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
