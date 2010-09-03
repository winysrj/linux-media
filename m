Return-path: <mchehab@pedra>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64373 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0ICQMA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Sep 2010 12:12:00 -0400
Received: by yxp4 with SMTP id 4so772346yxp.19
        for <linux-media@vger.kernel.org>; Fri, 03 Sep 2010 09:12:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1283529713.12583.84.camel@morgan.silverblock.net>
References: <AANLkTi=SY9xWCjp_0q6US7XN6XYoTWnGHA2=6EfjuWK-@mail.gmail.com>
	<AANLkTikg79zui71Xz8r-Lg3zut0jkSk-BGEpBpXfWz5Y@mail.gmail.com>
	<AANLkTimc2TTQQogO8Q6ih6Bv3j_oOcVMux3cg-CJPGsw@mail.gmail.com>
	<AANLkTim_mU7ayxjeE2HQz57UsPqHU46dPC3Ys600RJAD@mail.gmail.com>
	<1283529713.12583.84.camel@morgan.silverblock.net>
Date: Fri, 3 Sep 2010 12:12:00 -0400
Message-ID: <AANLkTimvC6811Pb-sxTVSod-p2U+Cmy5QUenKRn9ceYX@mail.gmail.com>
Subject: Re: Gigabyte 8300
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Dagur Ammendrup <dagurp@gmail.com>,
	Joel Wiramu Pauling <joel@aenertia.net>,
	linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

On Fri, Sep 3, 2010 at 12:01 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> On Fri, 2010-09-03 at 10:55 +0000, Dagur Ammendrup wrote:
>> I tried it on a windows machine where it's identified as "Conextant
>> Polaris Video Capture"  or
>> "oem17.inf:Conexant.NTx86:POLARIS.DVBTX.x86:6.113.1125.1210:usb\vid_1b80&pid_d416&mi_01"
>> if that tells you anything.
>
>
> Polaris refers to the series of CX2310[012] chips IIRC.
>
> Support would need changes to the cx231xx driver, and possibly changes
> to the cx25480 module, depending on how far the board differs from
> Conexant reference designs.

I've been working with Conexant on this, and have their current tree here:

https://www.kernellabs.com/hg/~dheitmueller/polaris4/

So if you feel the urge to do any new device support, I would suggest
using this as a starting point.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
