Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:33922 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbeAVOwR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 09:52:17 -0500
Received: from [217.146.132.69] (helo=[192.168.2.34])
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <florian.boor@kernelconcepts.de>)
        id 1eddSK-0001GZ-23
        for linux-media@vger.kernel.org; Mon, 22 Jan 2018 15:52:16 +0100
Subject: Re: MT9M131 on I.MX6DL CSI color issue
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub> <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
 <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
 <20180118040308.GA21998@minime.bse>
 <4407aea6-4a7e-a637-40ae-3b25f43b81e5@kernelconcepts.de>
 <20180120150204.GA17833@minime.bse>
From: Florian Boor <florian.boor@kernelconcepts.de>
Message-ID: <474c1392-6a31-277e-02f0-b1d3a93cfe65@kernelconcepts.de>
Date: Mon, 22 Jan 2018 15:52:15 +0100
MIME-Version: 1.0
In-Reply-To: <20180120150204.GA17833@minime.bse>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel,

On 20.01.2018 16:02, Daniel Glöckner wrote:
> The VM-009 has 10 data lines. Do you use a board designed by Phytec?
> If not, did you connect the lower or the upper 8 data lines to the i.MX6?
> Using the upper 8 data lines is correct.

its a VM-009 but not a Phytec baseboard and luckily I am not responsible for the
hardware design :-)
I guess you found the issue: The lower data lines are connected. I guess the
designer of this hardware did not have the schematic of the camera and assumed
that the numeration of the data lines of the camera module is the same like on
the MT9M131 chip - which does not seem to be the case.

> I'm asking because the raw frames I asked for off list* contain only odd
> bytes except for some null bytes. And for all components they exceed the
> standard value range (Y 16-235, Cb/Cr 16-240).
> 
> Have you ever tried to capture images in one of the RGB formats?
Not so far but I just tried. The JPEG compressor does not seem to like it but I
can import the raw frame as ARGB into i.e. ImageJ and what I get is a RGB image
with quite a lot of overflows and wrong colors. It looks pretty much broken like
I would expect it to look missing the upper bits.

I'll see if I can fix the hardware now :-)

Greetings

Florian



-- 
The dream of yesterday                  Florian Boor
is the hope of today                    Tel: +49 271-771091-15
and the reality of tomorrow.		Fax: +49 271-338857-29
[Robert Hutchings Goddard, 1904]        florian.boor@kernelconcepts.de
                                        http://www.kernelconcepts.de/en

kernel concepts GmbH
Hauptstraße 16
D-57074 Siegen
Geschäftsführer: Ole Reinhardt
HR Siegen, HR B 9613
