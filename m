Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:60393 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755538Ab3HRP1f (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Aug 2013 11:27:35 -0400
Message-ID: <5210E7BC.9060605@iki.fi>
Date: Sun, 18 Aug 2013 18:26:52 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Ulf <mopp@gmx.net>
CC: linux-media@vger.kernel.org, Hans Petter Selasky <hps@bitfrost.no>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
In-Reply-To: <trinity-f1bb3861-097c-4a3d-a374-a999bdb0fd9d-1376838057464@3capp-gmx-bs32>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/18/2013 06:00 PM, Ulf wrote:

I added Mr. Hans Petter Selasky back to Cc. I think it is better to keep 
all involved in To/Cc even it is mailing list. Personally I pay special 
attention for messages coming to my INBOX than those which are filtered 
to list basis folders. And everyone could personalize from mailing list 
settings if he wants duplicates or will mailing list drop it.


> Hi,
>
>> It is DVB-S driver. HVR-900 is DVB-T and DVB-C.
> The si2168 is a DVB-T2, DVB-T, and DVB-C demodulator http://www.silabs.com/Support%20Documents/TechnicalDocs/Si2168-A20-short.pdf.
>
> I tried to apply the dvbsky-linux-3.9-hps-v2.diff to media_build.git (used do_patches.sh from http://www.selasky.org/hans_petter/distfiles/webcamd-3.10.0.7.tar.bz2), but I was not able to compile it. I already changed some includes, but then I got the next error.
> I just wanted to test if the si2168 module will work with si2165, but as I don't expect it to work I stopped trying to compile the si2168.

I looked wrong place and driver =)

That driver is asked few times already, nice!

+    History:
+	Max Nibble wrote the initial code, but only released it in
+	binary form. Assembly to C conversion done by HP Selasky.
+	Some possible endian issues fixed.


It is big possibility same DVB-T/C/T2 blocks are used with different 
chips as none wants to reinvent the wheel. That has happened many times.

I wonder is there any change to start mainlining that driver as it is 
converted from the binary? Make documentation and then write clean driver?


regards
Antti

-- 
http://palosaari.fi/
