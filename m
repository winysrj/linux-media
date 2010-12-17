Return-path: <mchehab@gaivota>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49579 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0LQDVl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Dec 2010 22:21:41 -0500
Received: by vws16 with SMTP id 16so91244vws.19
        for <linux-media@vger.kernel.org>; Thu, 16 Dec 2010 19:21:41 -0800 (PST)
Subject: Re: [PATCH 3/4] rc: conversion is to microseconds, not nanoseconds
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <1292534935.19587.5.camel@maxim-laptop>
Date: Thu, 16 Dec 2010 22:21:38 -0500
Cc: Jarod Wilson <jarod@redhat.com>, linux-media@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2B8222AA-9648-42F0-A08C-8BA7EC506E35@wilsonet.com>
References: <1292526037-21491-1-git-send-email-jarod@redhat.com> <1292526037-21491-4-git-send-email-jarod@redhat.com> <1292534935.19587.5.camel@maxim-laptop>
To: Maxim Levitsky <maximlevitsky@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Dec 16, 2010, at 4:28 PM, Maxim Levitsky wrote:

> On Thu, 2010-12-16 at 14:00 -0500, Jarod Wilson wrote:
>> Fix a thinko, and move macro definition to a common header so it can be
>> shared amongst all drivers, as ms to us conversion is something that
>> multiple drivers need to do. We probably ought to have its inverse
>> available as well.
> 
> 
> Nope, at least ENE gets 'us' samples, that is 10^-6 seconds, and I
> multiply that by 1000, and that gives nanoseconds (10^-9).

Huh, okay. I'd have expected it to be US_TO_NS then. I basically
hijacked a copy over to mceusb and was using it for ms to us
conversions.

> I have nothing against moving MS_TO_NS to common code of course.

I'll throw together something new in the relatively near future, will
probably just add macros for both conversions and both directions.


-- 
Jarod Wilson
jarod@wilsonet.com



