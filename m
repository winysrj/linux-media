Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f166.google.com ([209.85.217.166]:43726 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760671AbZEFPQp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 6 May 2009 11:16:45 -0400
Received: by gxk10 with SMTP id 10so255694gxk.13
        for <linux-media@vger.kernel.org>; Wed, 06 May 2009 08:16:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <cb69f9670905060803ucce5b66v587f385069adad3f@mail.gmail.com>
References: <412bdbff0905052114r7f481759r373fd0b814f458e@mail.gmail.com>
	 <cb69f9670905052347k4117de32lc78290e7356dd14e@mail.gmail.com>
	 <412bdbff0905060602v135fff12jf76d92510a455272@mail.gmail.com>
	 <cb69f9670905060803ucce5b66v587f385069adad3f@mail.gmail.com>
Date: Wed, 6 May 2009 11:16:44 -0400
Message-ID: <412bdbff0905060816m6db4e196wf8c42afcc5079af9@mail.gmail.com>
Subject: Re: XC5000 improvements: call for testers!
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: kenny wang <smartkenny@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, May 6, 2009 at 11:03 AM, kenny wang <smartkenny@gmail.com> wrote:
>
> Yes, Devin, I am using a WinTV-HVR-950Q.

That's what I thought - the delay in loading tvtime is actually
because of some issues with the performance of the au0828's i2c bus.
I've put a few nights of work into debugging it, and I have some ideas
on how to make it perform better, however I wanted to take it out of
the critical path for the xc5000 improvements.

I realize it's annoying for tvtime users and will be working to
improve the situation going forward.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
