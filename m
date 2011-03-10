Return-path: <mchehab@pedra>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62418 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1CJSbv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 13:31:51 -0500
Received: by ywj3 with SMTP id 3so793811ywj.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 10:31:51 -0800 (PST)
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: bugzilla-daemon@bugzilla.kernel.org, btekbas@gmail.com
Subject: Re: [Bug 30022] Kernel cannot find Flyvideo 98's remote control device.
Date: Thu, 10 Mar 2011 10:31:39 -0800
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <bug-30022-3268@https.bugzilla.kernel.org/> <201103100852.p2A8q0Vh026847@demeter2.kernel.org>
In-Reply-To: <201103100852.p2A8q0Vh026847@demeter2.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103101031.39687.dmitry.torokhov@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thursday, March 10, 2011 12:52:00 am bugzilla-daemon@bugzilla.kernel.org 
wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=30022
> 
> 
> 
> 
> 
> --- Comment #7 from Mehmet Tekbaş <btekbas@gmail.com>  2011-03-10
> 08:51:59 --- Tried with Inca I-TV004 (bt878 analog card) and result
> didn't changed. IR device doesnt place under /dev/input/ . Can it be
> related to inputdev replacement of lirc_gpio?

Let's ask folks on linux-media mailing list...

-- 
Dmitry
