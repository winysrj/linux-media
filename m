Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43046 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318AbZKKMRG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 07:17:06 -0500
Received: by yxe17 with SMTP id 17so855759yxe.33
        for <linux-media@vger.kernel.org>; Wed, 11 Nov 2009 04:17:12 -0800 (PST)
Message-ID: <4AFAAB44.1000001@gmail.com>
Date: Wed, 11 Nov 2009 13:17:08 +0100
From: Ryan Raasch <ryan.raasch@gmail.com>
MIME-Version: 1.0
To: Carlos Lavin <carlos.lavin@vista-silicon.com>,
	v4l2_linux <linux-media@vger.kernel.org>
Subject: Re: module ov7670.c
References: <fe6fd5f60911110136t5f0f97fcjcd849916df6fda0c@mail.gmail.com>	 <4AFA97A0.10908@gmail.com> <fe6fd5f60911110320x45475aa4j38930660e9b2e81b@mail.gmail.com>
In-Reply-To: <fe6fd5f60911110320x45475aa4j38930660e9b2e81b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Carlos Lavin wrote:
> i am asking that if it is possible to start a module without MODULE_INIT 
> function in the body of program.
> 
It looks as though all drivers that use v4l2_i2c_driver_data DO NOT use 
the module_init function.

According to commit 14386c2b7793652a656021a3345cff3b0f6771f9, 
v4l2_subdev is used instead. However, this is different for me also.


Ryan

> 
> 2009/11/11 Ryan Raasch <ryan.raasch@gmail.com 
> <mailto:ryan.raasch@gmail.com>>
> 
> 
> 
>     Carlos Lavin wrote:
> 
>         i don't know that it pass with this module, ov7670.c , because i
>         don't see
>         in the screen of my Pc this modulo when the kernel is load. this
>         module
>         haven't the module_init  function , and i don't know if it is
>         possible to
>         run it without this function. the version kernel where i work is
>         2.6.30,
>         also i have patched this modulo for works with the library
>         soc_camera.h
>         can anybody help me? I am rookie in this topics.
>         thanks.
>         --
> 
>     What are you asking?
> 
>     Ryan
> 
>         video4linux-list mailing list
>         Unsubscribe mailto:video4linux-list-request@redhat.com
>         <mailto:video4linux-list-request@redhat.com>?subject=unsubscribe
>         https://www.redhat.com/mailman/listinfo/video4linux-list
> 
> 
