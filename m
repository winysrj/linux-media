Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:41181 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751883AbeA3RNQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 30 Jan 2018 12:13:16 -0500
Received: from [217.146.132.69] (helo=[192.168.2.34])
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <florian.boor@kernelconcepts.de>)
        id 1egZT9-0004gu-5H
        for linux-media@vger.kernel.org; Tue, 30 Jan 2018 18:13:15 +0100
Subject: Re: MT9M131 on I.MX6DL CSI color issue
From: Florian Boor <florian.boor@kernelconcepts.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub> <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
 <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
 <20180118040308.GA21998@minime.bse>
 <4407aea6-4a7e-a637-40ae-3b25f43b81e5@kernelconcepts.de>
 <20180120150204.GA17833@minime.bse>
 <474c1392-6a31-277e-02f0-b1d3a93cfe65@kernelconcepts.de>
Message-ID: <b37ea727-29fd-e1d5-08e0-8835ff991547@kernelconcepts.de>
Date: Tue, 30 Jan 2018 18:13:13 +0100
MIME-Version: 1.0
In-Reply-To: <474c1392-6a31-277e-02f0-b1d3a93cfe65@kernelconcepts.de>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello all,

On 22.01.2018 15:52, Florian Boor wrote:
>> Have you ever tried to capture images in one of the RGB formats?
> Not so far but I just tried. The JPEG compressor does not seem to like it but I
> can import the raw frame as ARGB into i.e. ImageJ and what I get is a RGB image
> with quite a lot of overflows and wrong colors. It looks pretty much broken like
> I would expect it to look missing the upper bits.

RGB seems to be complicated. I did not find a working setup.

> I'll see if I can fix the hardware now :-)

But fixing the hardware almost got it right. The last remaining issue was the
pixel clock that required inverting. Now the images from the camera look
correct. (I'm currently testing with YUYV2X8 configuration and videoparse
"format=4" setting.)

Many thanks for all the help!

Greetings

Florian

-- 
The dream of yesterday                  Florian Boor
is the hope of today                    Tel: +49(0) 271-771091-15
and the reality of tomorrow.		Fax: +49(0) 271-338857-29
[Robert Hutchings Goddard, 1904]        florian.boor@kernelconcepts.de
                                        http://www.kernelconcepts.de/en

kernel concepts GmbH
Hauptstraße 16
D-57074 Siegen
Geschäftsführer: Ole Reinhardt
HR Siegen, HR B 9613
