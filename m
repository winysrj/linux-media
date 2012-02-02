Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:37754 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2BBTHm (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 14:07:42 -0500
Received: by vcge1 with SMTP id e1so2039275vcg.19
        for <linux-media@vger.kernel.org>; Thu, 02 Feb 2012 11:07:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2ADDCB.4060200@gmail.com>
References: <4F2AC7BF.4040006@ukfsn.org>
	<4F2ADDCB.4060200@gmail.com>
Date: Thu, 2 Feb 2012 14:07:41 -0500
Message-ID: <CAGoCfiyTHNkr3gNAZUefeZN88-5Vd9SEyGUeFjYO-ddG1WqgzA@mail.gmail.com>
Subject: Re: PCTV 290e page allocation failure
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: gennarone@gmail.com
Cc: Andy Furniss <andyqos@ukfsn.org>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 2, 2012 at 2:02 PM, Gianluca Gennari <gennarone@gmail.com> wrote:
> I'm trying to reproduce the problem with another em28xx-dvb device to
> see if it is not restricted to the PCTV 290e. Before the PCTV 290e, I
> was using a different device with a driver based on the dvb-usb
> framework, and I never observed similar crashes.

On ARM based platforms it is very likely you will run into this issue
with most USB based tuners.  It's because over time there is memory
fragmentation that occurs which prevents being able to allocate large
enough chunks of coherent memory.

Making such a scenario work would require hacks to the driver code to
preallocate the memory in some form of static pool at system boot (or
perhaps at driver initialization), and then reuse that memory instead
of attempting to allocate it as needed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
