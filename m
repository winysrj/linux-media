Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kernelconcepts.de ([188.40.83.200]:59672 "EHLO
        mail.kernelconcepts.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753050AbeAQM6o (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 17 Jan 2018 07:58:44 -0500
Received: from [217.146.132.69] (helo=[192.168.2.34])
        by mail.kernelconcepts.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <florian.boor@kernelconcepts.de>)
        id 1ebnIg-00049t-Pa
        for linux-media@vger.kernel.org; Wed, 17 Jan 2018 13:58:42 +0100
Subject: Re: MT9M131 on I.MX6DL CSI color issue
To: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <b704a2fb-efa1-a2f8-7af0-43d869c688eb@kernelconcepts.de>
 <20180112105840.75260abb@crub> <20180112110606.47499410@crub>
 <929ef892-467b-dfd1-8ae0-0190263be38a@kernelconcepts.de>
 <20180117103109.GA18072@minime.bse>
From: Florian Boor <florian.boor@kernelconcepts.de>
Message-ID: <ff51f6e2-270d-c881-4445-8dadf5d7db6f@kernelconcepts.de>
Date: Wed, 17 Jan 2018 13:58:42 +0100
MIME-Version: 1.0
In-Reply-To: <20180117103109.GA18072@minime.bse>
Content-Type: text/plain; charset=utf-8
Content-Language: de-AT
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 17.01.2018 11:31, Daniel Glöckner wrote:
> May I suggest that you capture something of known colors, by pointing
> the camera at a monitor displaying this?:
> http://www.avsforum.com/photopost/data/2224298/0/04/04d8edc6_8bit_full_grad_color.png
> 
> The colors will of course be off by a bit, but it should still be
> possible to guess how the RGB primaries were mangled.

yes that's a good idea. The result with original and camera view side by side
looks like this:

http://www.kernelconcepts.de/~florian/screenshot.png

Its not really obvious for me what is wrong but these wraparounds Philipp
mentioned are really nice to see within the bars.

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
