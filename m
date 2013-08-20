Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta.bitpro.no ([92.42.64.202]:46954 "EHLO mta.bitpro.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365Ab3HTImO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 04:42:14 -0400
Message-ID: <52132C2D.5030002@bitfrost.no>
Date: Tue, 20 Aug 2013 10:43:25 +0200
From: Hans Petter Selasky <hps@bitfrost.no>
MIME-Version: 1.0
To: "nibble.max" <nibble.max@gmail.com>
CC: Konstantin Dimitrov <kosio.dimitrov@gmail.com>,
	Steven Toth <stoth@kernellabs.com>,
	Antti Palosaari <crope@iki.fi>, Ulf <mopp@gmx.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge HVR-900 HD and HVR 930C-HD with si2165
References: <trinity-fe3d0cd8-edad-4308-9911-95e49b1e82ea-1376739034050@3capp-gmx-bs54>, <520F643C.70306@iki.fi>, <5210B5F3.4040607@bitfrost.no>, <CALzAhNXUKZPEyFe0eND3Lb3dQwfVaMUWS30kx0sQJj7YG2rKow@mail.gmail.com>, <52127667.8050202@bitfrost.no>, <CAF0Ff2mQP6+a5693kf3Vq7AHHG5--1keZMvdp-YX4o4OLk3Y-g@mail.gmail.com> <201308201626317340537@gmail.com>
In-Reply-To: <201308201626317340537@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/20/13 10:26, nibble.max wrote:
> Hello Hans,
>
> I am the original author of sit2 source code based on the reference code from silabs.
> And we have signed NDA with silabs, it does not allow us to release the source code to the public.
> I donot know it is permited or not when you do decompiling the binary code.
>

Thank you Max for clearing this up a bit,

I can tell you that the decompiled driver works like expected with the 
product I bought and lets me use this product under FreeBSD like I was 
expecting after reading the Linux-commercial's from the Vendor.

Maybe an idea for the future. Abstract binaries a bit more so that they 
are independent of the Linux header files and other kernel functions. 
Then I wouldn't have to do the decompile.

The other DVB-T adapter I had before outputted somtimes corrupted or too 
long USB packets on the isochronous endpoint when the bitrate was going 
too high. I do no longer see this problem with the adapter supported by 
Max's driver. And I am satisfied. Regarding you and "Konstantin 
Dimitrov" I don't want to have any opinion about what product is best.

--HPS

