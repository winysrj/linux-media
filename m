Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:55054 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbZGIPwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 9 Jul 2009 11:52:23 -0400
Received: by gxk26 with SMTP id 26so395590gxk.13
        for <linux-media@vger.kernel.org>; Thu, 09 Jul 2009 08:52:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907091144.48125.jarod@redhat.com>
References: <20090406174448.118f574e@hyperion.delvare>
	 <20090407075029.21d14f4a@pedra.chehab.org>
	 <20090407143617.2c2adbf7@hyperion.delvare>
	 <200907091144.48125.jarod@redhat.com>
Date: Thu, 9 Jul 2009 11:52:22 -0400
Message-ID: <829197380907090852o2dcb61f7lbebedfcbdcb193c7@mail.gmail.com>
Subject: Re: [RFC] Anticipating lirc breakage
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Jean Delvare <khali@linux-fr.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Mike Isely <isely@pobox.com>, isely@isely.net,
	LMML <linux-media@vger.kernel.org>,
	Andy Walls <awalls@radix.net>,
	Hans Verkuil <hverkuil@xs4all.nl>, Janne Grunau <j@jannau.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jul 9, 2009 at 11:44 AM, Jarod Wilson<jarod@redhat.com> wrote:
> On Tuesday 07 April 2009 08:36:17 Jean Delvare wrote:
>> > So, let's just forget the workarounds and go straight to the point: focus on
>> > merging lirc-i2c drivers.
>>
>> Will this happen next week? I fear not. Which is why I can't wait for
>> it. And anyway, in order to merge the lirc_i2c driver, it must be
>> turned into a new-style I2C driver first, so bridge drivers must be
>> prepared for this, which is exactly what my patches are doing.
>
> For what its worth, I fixed up lirc_i2c a few days ago, and now have
> it working just fine with my pvr-250 under 2.6.31-rc2.
>
> Real Soon Now (I swear), I'm hoping to get up another head of steam
> for submitting lirc upstream. Multiple drivers have received a bunch
> of love in the past few weeks, so I think we're in a pretty good state
> to have another go at it...
>
> --
> Jarod Wilson
> jarod@redhat.com

Jarod,

This is excellent news.  Keep up the good work!

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
