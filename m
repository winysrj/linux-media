Return-path: <linux-media-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:4204 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbZCUCDX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Mar 2009 22:03:23 -0400
Received: by yx-out-2324.google.com with SMTP id 31so1265236yxl.1
        for <linux-media@vger.kernel.org>; Fri, 20 Mar 2009 19:03:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090320192046.15d32407@pedra.chehab.org>
References: <200903022218.24259.hverkuil@xs4all.nl>
	 <20090304141715.0a1af14d@pedra.chehab.org>
	 <20090320204707.227110@gmx.net>
	 <20090320192046.15d32407@pedra.chehab.org>
Date: Fri, 20 Mar 2009 22:03:21 -0400
Message-ID: <412bdbff0903201903g270b4be1nb55e6d881e46efc2@mail.gmail.com>
Subject: Re: Results of the 'dropping support for kernels <2.6.22' poll
From: Devin Heitmueller <devin.heitmueller@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Werner <HWerner4@gmx.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Mar 20, 2009 at 6:20 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> My suggestion is to keep a backporting system, but more targeted at the
> end-users. The reasons are the ones explained above. Basically:

Ok, so just so we're all on the same page - we're telling all the
developers not willing to run a bleeding edge rc kernel to screw off?

Got an Nvidia video card?  Go away!
The wireless broken in this week's -rc candidate?  Go away!
Your distro doesn't yet support the bleeding edge kernel?   Go away!
Want to have a stable base on which to work so you can focus on
v4l-dvb development?  Go away!

I can tell you quite definitely that you're going to lose some
developers with this approach.  You better be damn sure that the lives
you're making easier are going to significantly outweigh the
developers willing to contribute who you are casting aside.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
