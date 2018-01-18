Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:60829 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753406AbeARQbq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Jan 2018 11:31:46 -0500
Received: from [217.146.132.69] (helo=[192.168.2.83])
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <florian.boor@kernelconcepts.de>)
        id 1ecD6O-0006dJ-Hm
        for linux-media@vger.kernel.org; Thu, 18 Jan 2018 17:31:44 +0100
From: Florian Boor <florian.boor@kernelconcepts.de>
Subject: Re: MT9M131 on I.MX6DL CSI color issue
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub> <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
 <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
 <20180118040308.GA21998@minime.bse>
Message-ID: <4407aea6-4a7e-a637-40ae-3b25f43b81e5@kernelconcepts.de>
Date: Thu, 18 Jan 2018 17:31:43 +0100
MIME-Version: 1.0
In-Reply-To: <20180118040308.GA21998@minime.bse>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Daniel,

On 18.01.2018 05:03, Daniel Glöckner wrote:
> The vertical lines tell me that videoparse format=5 is wrong. Since the
> U and V planes are so similar in the screenshot, it is most likely
> format 4 or 19.

okay - it gets more colorful with these at least :-)
See [1] and it looks quite similar with both format 4 and 19.

> But that does not explain the wraparounds. Can you rule out that the
> data lines have been connected in the wrong order?

According to the schematics and camera documentation I have the order of the
data lines is correct. I checked one more time... but I'm not sure if the
configuration of the parallel camera input is perfectly right.

The hardware uses CSI0 data lines 12 to 19 and so I used the configuration from
the SabreLite board:

&ipu1_csi0_from_ipu1_csi0_mux {
	bus-width = <8>;
	data-shift = <12>; /* Lines 19:12 used */
...

So what I did is to change data-shift to 0. This should cause unused lines to be
sampled but it did not change anything.
So even assuming it is correct per default some of the settings might never make
it to the hardware interface configuration.

Greetings

Florian


[1] http://www.kernelconcepts.de/~florian/screenshot2.png

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
