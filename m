Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64983 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1FFUAr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 6 Jun 2011 16:00:47 -0400
Received: by ewy4 with SMTP id 4so1488153ewy.19
        for <linux-media@vger.kernel.org>; Mon, 06 Jun 2011 13:00:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTim9d3yi3OQn4AxfwV6pfv+KY-KseA@mail.gmail.com>
References: <BANLkTimFT+D3_vZVj5KMiB7jMvq=088Y7A@mail.gmail.com>
	<BANLkTim9d3yi3OQn4AxfwV6pfv+KY-KseA@mail.gmail.com>
Date: Mon, 6 Jun 2011 16:00:46 -0400
Message-ID: <BANLkTi=3eyHgiXCsH2uibPsV0L7Eq79fnw@mail.gmail.com>
Subject: Re: [PATCH] cx231xx: Add support for Hauppauge WinTV USB2-FM
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Peter Moon <pomoon@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Jun 6, 2011 at 3:22 PM, Peter Moon <pomoon@gmail.com> wrote:
> This patch adds support for the " Hauppauge WinTV USB2-FM" Analog Stick.
>
> Signed-off-by: Peter Moon <pomoon@gmail.com>

I basically have the same patch sitting in my one of my Hauppauge
private repos, but hadn't gotten around to submitting it upstream yet.

My only comment is that the func_mode in cx231xx_dif_set_standard()
should be 0x01, not 0x03.  Change that, resubmit the patch after
testing, and I will put my Reviewed-By on it.

Also, there is actually another USB ID which is the exact same product
(but targeted at NTSC by default).  I'll have to lookup the ID though.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
