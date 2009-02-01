Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:32143 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZBANre (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Feb 2009 08:47:34 -0500
Date: Sun, 1 Feb 2009 14:47:25 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org
Subject: Re: cx88-dvb broken since 2.6.29-rc1
Message-ID: <20090201144725.637ba51a@hyperion.delvare>
In-Reply-To: <20090201114257.19d5df1f@pedra.chehab.org>
References: <20090129221012.685c239e@hyperion.delvare>
	<20090129192431.46adf0c9@caramujo.chehab.org>
	<20090201142927.57f0d5b4@hyperion.delvare>
	<20090201114257.19d5df1f@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 1 Feb 2009 11:42:57 -0200, Mauro Carvalho Chehab wrote:
> On Sun, 1 Feb 2009 14:29:27 +0100
> Jean Delvare <khali@linux-fr.org> wrote:
> 
> > On Thu, 29 Jan 2009 19:24:31 -0200, Mauro Carvalho Chehab wrote:
> > > I have already a pull request almost ready that will fix this issue. I'll
> > > likely send it today or tomorrow.
> > 
> > Did it happen? I've just tested kernel 2.6.29-rc3-git3 and the problem
> > is still present.
> 
> I just sent today a pull request with this fix included:

Great, thanks.

> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> To: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-media@vger.linuxtv.org

The last address looks like a typo.

-- 
Jean Delvare
