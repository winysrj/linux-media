Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48762 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab1CYRxN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Mar 2011 13:53:13 -0400
Received: by wya21 with SMTP id 21so1314902wya.19
        for <linux-media@vger.kernel.org>; Fri, 25 Mar 2011 10:53:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4D8CAE2C.2030301@uni-rostock.de>
References: <4D8CAE2C.2030301@uni-rostock.de>
Date: Fri, 25 Mar 2011 23:23:11 +0530
Message-ID: <AANLkTimy=QymYhYM3tknCP-Qh7X_y1AjJ0TK2axZ5UmV@mail.gmail.com>
Subject: Re: S2-3200 switching-timeouts on 2.6.38
From: Manu Abraham <abraham.manu@gmail.com>
To: Paul Franke <paul.franke@uni-rostock.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Fri, Mar 25, 2011 at 8:31 PM, Paul Franke <paul.franke@uni-rostock.de> wrote:
> Hi list,
>
> Follow up to: [1]
>
> I did testing with a TechniSat SkyStar HD 2 (1ae4:0003).
>
> - without a patch: card unuseable, gets locks only rarely
> - with Manu's patch: card useable, gets locks, but sometimes this still
> needs some seconds
> - with the mentioned stb0899 patch: card useable, gets locks, most time or
> nearly always fast (and faster as with Manu's patch)
>
> In practice the stb0899 patch does a better job for zap frenzies, so I
> kindly ask to include this patch.
>

Can you guys, (who seem to really need the said patch) please provide
me the STB0899 chipset version on your card ?

For eg: what I have here 3 different silicon versions
C6L STB0899 VQ940KDA12 22 9BS VQ MLT 22 012
C2L STB0899 VQ636DSK    22 09C  VQ MLT 22 656
C1L STB0899 VQ608FSD    22 OPD VQ MLT 22 628

Best Regards,
Manu
