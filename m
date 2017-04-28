Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37728 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S638285AbdD1Qq2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 28 Apr 2017 12:46:28 -0400
Received: by mail-wm0-f48.google.com with SMTP id m123so52102333wma.0
        for <linux-media@vger.kernel.org>; Fri, 28 Apr 2017 09:46:28 -0700 (PDT)
Subject: Re: em28xx module: misidentified card
To: Giuseppe Toscano <giuseppe.toscano@unina.it>,
        linux-media@vger.kernel.org
References: <5b093b1a-6251-b35e-190c-431fb00eb771@unina.it>
From: =?UTF-8?Q?Frank_Sch=c3=a4fer?= <fschaefer.oss@googlemail.com>
Message-ID: <834a80ca-1dde-b3ca-dbee-eca1759f4668@googlemail.com>
Date: Fri, 28 Apr 2017 18:46:34 +0200
MIME-Version: 1.0
In-Reply-To: <5b093b1a-6251-b35e-190c-431fb00eb771@unina.it>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 28.04.2017 um 13:22 schrieb Giuseppe Toscano:
> I am trying to use eMPIA Technology, Inc. GrabBeeX+ Video Encoder
> (card=21) but the em28xx driver erroneously identifies it as
> EM2860/SAA711X Reference Design (card = 19).
> Attached the output of lsusb and dmesg.
>
Card 21 is an em2800 device, while your device uses an em2710/em2820
(see log).
Card 19 should work. Did you test it ?

Regards,
Frank


> Best regards,
>
> Giuseppe Toscano
