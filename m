Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f199.google.com ([209.85.221.199]:52873 "EHLO
	mail-qy0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab0EFMgT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 6 May 2010 08:36:19 -0400
Received: by qyk37 with SMTP id 37so2165217qyk.22
        for <linux-media@vger.kernel.org>; Thu, 06 May 2010 05:36:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <10683c6d21eb608c93a46b06b23ef73f.squirrel@webmail.ovh.net>
References: <10683c6d21eb608c93a46b06b23ef73f.squirrel@webmail.ovh.net>
Date: Thu, 6 May 2010 08:36:17 -0400
Message-ID: <j2s83bcf6341005060536tf5283d7bo212076436801866a@mail.gmail.com>
Subject: Re: Philips/NXP channel decoders
From: Steven Toth <stoth@kernellabs.com>
To: guillaume.audirac@webag.fr
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I am starting first in diving into the tda10048 driver (DVB-T) to become
> familiar with the API. In case you know some existing issues, please
> report them to me, I would be glad to investigate and help.
>
> Last but not least, I don't have any hardware yet, is it blocking to
> eventually send patches ?

I can test your TDA10048 patches and add sign-off for merge. Looking
at the list it appears that you have a few nice cleanups. I'll draw
all of these together this weekend and run some tests.

Regards,

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
