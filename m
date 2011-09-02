Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52790 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933393Ab1IBK7y (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Sep 2011 06:59:54 -0400
Received: by fxh19 with SMTP id 19so1524393fxh.19
        for <linux-media@vger.kernel.org>; Fri, 02 Sep 2011 03:59:53 -0700 (PDT)
Date: Fri, 2 Sep 2011 12:59:32 +0200
From: Steffen Barszus <steffenbpunkt@googlemail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org, Manu Abraham <abraham.manu@gmail.com>
Subject: Re: patches missing in git ? - TT S2 1600
Message-ID: <20110902125932.605102b8@grobi>
In-Reply-To: <4DBAC19F.7010003@redhat.com>
References: <20110306142020.7fe695ca@grobi>
	<4DBAC19F.7010003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 29 Apr 2011 10:48:15 -0300
Mauro Carvalho Chehab <mchehab@redhat.com> wrote:

> Em 06-03-2011 10:20, Steffen Barszus escreveu:
> > I have one patch lying around which will fix a kernel oops if more
> > than one TT S2 1600 is build into the same computer. 
> 
> I think that the bug with two TT S2 devices at the same computer were
> fixed, but I don't remember what were the adopted solution.
> 
> I think that the change were inside tuner_sleep() callback, where
> tuner_priv is actually used.
> 
> So, as far as I know, this patch is obsolete. I'll mark it as
> rejected on patchwork. Please test it without this patch and the
> latest tree, pinging us if the error is still there.

Late follow up - but i only _now_ have 2 of these card. Situation now
is that it doesn't oops anymore - however its not fixed in the end. 

Problem which still exists: When one card is recording in vdr, the
second card possibly doesnt get a lock anymore. if second "receiver" is
live tv, switching back and forward a couple of times makes tuning
possible in the end, but it can also break recording. 

So from overall picture its seems there are ressources which are not
guarded against use at multiple devices. The fix for the oops has only
fixed the immediate crash but did not solve the common use of
ressources. 

Can you let me know how to start tracking this down ? Beside me i know
a couple of others having more than one of these cards, and - if its
the best/easiest way i could also imagine to organize temporary 2 of
this cards for a developer able to fix it. 
