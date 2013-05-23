Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:51661 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3EWKsT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 23 May 2013 06:48:19 -0400
Received: by mail-ie0-f177.google.com with SMTP id 9so8218202iec.36
        for <linux-media@vger.kernel.org>; Thu, 23 May 2013 03:48:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <519D6CFA.2000506@gmail.com>
References: <519D6CFA.2000506@gmail.com>
Date: Thu, 23 May 2013 07:48:18 -0300
Message-ID: <CALF0-+UqJaNc7v86qakVTNEJx5npMFPqFp-=9rAByFV_+FEaww@mail.gmail.com>
Subject: Re: Audio: no sound
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: =?ISO-8859-1?Q?Alejandro_A=2E_Vald=E9s?= <av2406@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alejandro,



On Wed, May 22, 2013 at 10:12 PM, "Alejandro A. Valdés"
<av2406@gmail.com> wrote:
>
> Being able to capture the TV signal from a cable decoder; but can't make it
> with getting audio working.I'm using an Easycap dc60 USB adapter, plugged in
> to one of the  USB 2.0 ports of an ASUS laptop, running the Ubuntu 12.04,
> distro, kernel: 3.5.0-30-generic.
>

Is that an stk1160 device?

Please show me the output of:

$ cat /proc/asound/cards

Thanks,
-- 
    Ezequiel
