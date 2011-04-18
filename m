Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45307 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1DROez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 10:34:55 -0400
Received: by ewy4 with SMTP id 4so1377631ewy.19
        for <linux-media@vger.kernel.org>; Mon, 18 Apr 2011 07:34:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikrT8o92sZ5gYT3Thy10HNYcHpSAQ@mail.gmail.com>
References: <BANLkTimKhe05sGJPGUrkD5JgwQKV_83bhQ@mail.gmail.com>
	<BANLkTinCBYFhpjqanV7U3C2a43MZmXZsqw@mail.gmail.com>
	<BANLkTikma80oNCF68FL8uoLY9-uakegnQw@mail.gmail.com>
	<BANLkTi=brbaZnupYHjwJy=VzdN6BZF9QRw@mail.gmail.com>
	<BANLkTikrT8o92sZ5gYT3Thy10HNYcHpSAQ@mail.gmail.com>
Date: Mon, 18 Apr 2011 10:34:54 -0400
Message-ID: <BANLkTik-rL8p+fWg+UhGbLo-TtenA9pq2A@mail.gmail.com>
Subject: Re: Wrong tv tuner card detedted
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Madhur Jajoo <jajoo.madhur@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Apr 18, 2011 at 10:28 AM, Madhur Jajoo <jajoo.madhur@gmail.com> wrote:
> Hi Devin,
>
>       Thanks for the reply. How can i make it work ?
>       Is there any wayout?
>
> Thanks
> Madhur

Unless you're familiar with device driver development, there isn't
really any solution for you.  The driver needs to be extended to
support whatever tuner chip, demodulator, and video decoder the device
has.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
