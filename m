Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47674 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761244Ab0GTMS2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Jul 2010 08:18:28 -0400
Received: by gxk23 with SMTP id 23so2687576gxk.19
        for <linux-media@vger.kernel.org>; Tue, 20 Jul 2010 05:18:27 -0700 (PDT)
Message-ID: <4C4594DA.5070509@gmail.com>
Date: Tue, 20 Jul 2010 08:21:46 -0400
From: Emmanuel <eallaud@gmail.com>
MIME-Version: 1.0
To: code unknown <restlessbrain@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: CAM Support for Terratec Cinergy S2 HD or Technisat SkyStar HD2
References: <AANLkTincseG_CGu9BjvXdkKLnD6ZVgSAwSIC-fO1oDzH@mail.gmail.com>
In-Reply-To: <AANLkTincseG_CGu9BjvXdkKLnD6ZVgSAwSIC-fO1oDzH@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

code unknown a écrit :
> Hi,
>
> I am using a Terratec Cinergy S2 HD with Mantis driver and so far the
> card runs without problems.
>
> The only thing is that CAM seems not to be supported - it is defined
> out from the source code:
>
> #if 0
>   err = mantis_ca_init(mantis);
>   if (err < 0) {
>            dprintk(MANTIS_ERROR, 1, "ERROR: Mantis CA initialization
> failed <%d>", err);
>   }
> #endif
>
>
> My questions are:
>
> 1. Is anybody currently working on CAM support? Will it be supported soon?
>
> 2. Is there another DVB-S2 HD card which has CAM supported?
>   
I am using a Technotrend S2-3200 with a CAM (Astoncrypt) with no problem 
so far.
HTH
Bye
Manu
