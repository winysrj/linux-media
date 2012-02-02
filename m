Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46926 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab2BBXGM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 18:06:12 -0500
Received: by eaah12 with SMTP id h12so1242831eaa.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 15:06:10 -0800 (PST)
Message-ID: <4F2B16DF.3040400@gmail.com>
Date: Fri, 03 Feb 2012 00:06:07 +0100
From: Gianluca Gennari <gennarone@gmail.com>
Reply-To: gennarone@gmail.com
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Subject: Re: PCTV 290e page allocation failure
References: <4F2AC7BF.4040006@ukfsn.org>	<4F2ADDCB.4060200@gmail.com> <CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>
In-Reply-To: <CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Il 02/02/2012 20:07, Devin Heitmueller ha scritto:
> On Thu, Feb 2, 2012 at 2:02 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
>> I'm trying to reproduce the problem with another em28xx-dvb device to
>> see if it is not restricted to the PCTV 290e. Before the PCTV 290e, I
>> was using a different device with a driver based on the dvb-usb
>> framework, and I never observed similar crashes.
> 
> On ARM based platforms it is very likely you will run into this issue
> with most USB based tuners.  It's because over time there is memory
> fragmentation that occurs which prevents being able to allocate large
> enough chunks of coherent memory.
> 
> Making such a scenario work would require hacks to the driver code to
> preallocate the memory in some form of static pool at system boot (or
> perhaps at driver initialization), and then reuse that memory instead
> of attempting to allocate it as needed.
> 
> Devin
> 

Hi Devin,
thanks for the explanation. The CPU is MIPS based (not ARM) but I guess
there is not much of a difference from this point of view.
As I mentioned in my first reply, I never had this kind of errors when I
was using a dvb-usb USB stick. Now I'm trying to replicate the problem
with a Terratec Hybrid XS (em28xx-dvb + zl10353 + xc2028), and so far
I've stressed it for a few hours without problems. We will see in a day
or two if I can make it fail in the same way.

Regards,
Gianluca


