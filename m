Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0IPOyW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 10:54:22 -0400
Received: by eyb6 with SMTP id 6so596195eyb.19
        for <linux-media@vger.kernel.org>; Thu, 16 Sep 2010 07:54:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1284646990.2917.14.camel@i7.private.net>
References: <1284646990.2917.14.camel@i7.private.net>
Date: Thu, 16 Sep 2010 10:54:21 -0400
Message-ID: <AANLkTin0hz7Job6NO+x-_CRphCo18K09ZHaLxUR6gtQj@mail.gmail.com>
Subject: Re: Hauppauge WinTV-HVR1800 dual tuner help needed
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jack Snodgrass <jacksnodgrass@mylinuxguy.net>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Thu, Sep 16, 2010 at 10:23 AM, Jack Snodgrass
<jacksnodgrass@mylinuxguy.net> wrote:
> I can use  1 input on the card with mythtv
> using /dev/dvb/adapter0/frontend0
> but I can't figure out how to use the 2nd tuner.... I'm not sure if the
> 2nd tuner is getting
> detected correctly... or if the 2nd tuner is just an analog tuner and
> not a digital tuner....
> or what exactly...

The HVR-1800 doesn't have two digital tuners.  It has an analog tuner
and a digital tuner.  If you need dual ClearQAM, you need a card like
the HVR-2250.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
