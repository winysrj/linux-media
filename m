Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f200.google.com ([209.85.216.200]:41827 "EHLO
	mail-px0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489AbZFHVJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Jun 2009 17:09:05 -0400
Received: by pxi38 with SMTP id 38so373951pxi.33
        for <linux-media@vger.kernel.org>; Mon, 08 Jun 2009 14:09:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A2D7C99.3090609@gatech.edu>
References: <4A2CE866.4010602@gatech.edu> <4A2D1CAA.2090500@kernellabs.com>
	 <829197380906080717x37dd1fd8n8f37fb320ab20a37@mail.gmail.com>
	 <4A2D3A40.8090307@gatech.edu> <4A2D3CE2.7090307@kernellabs.com>
	 <4A2D4778.4090505@gatech.edu> <4A2D7277.7080400@kernellabs.com>
	 <829197380906081336n48d6090bmc4f92692a5496cd6@mail.gmail.com>
	 <4A2D7C99.3090609@gatech.edu>
Date: Mon, 8 Jun 2009 17:09:07 -0400
Message-ID: <829197380906081409w3617b18cy2bc8ee81ef298bf0@mail.gmail.com>
Subject: Re: cx18, s5h1409: chronic bit errors, only under Linux
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: David Ward <david.ward@gatech.edu>
Cc: Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 8, 2009 at 5:03 PM, David Ward <david.ward@gatech.edu> wrote:
> Devin, I would really really appreciate this.  I hesitated to e-mail this
> list for several weeks, because I wanted to investigate thoroughly first and
> avoid wasting anyone's time as much as possible.  I hope you are able to
> reproduce this.

Well, I've got a few different combinations of s5h1409 tuners and
demods (including the HVR-1600), so if I can reproduce the issue, I
can probably narrow it down as to whether it's a tuner or a demod
issue.  I've spent a good bit of time analyzing the s5h1409 driver in
the past, although I don't have the datasheet for the chip.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
