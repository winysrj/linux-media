Return-path: <mchehab@pedra>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:25378 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab0IRArp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Sep 2010 20:47:45 -0400
From: rjkm <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19604.3118.741829.592934@valen.metzler>
Date: Sat, 18 Sep 2010 02:47:42 +0200
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Johannes Stezenbach <js@linuxtv.org>, linux-media@vger.kernel.org
Subject: Re: How to handle independent CA devices
In-Reply-To: <AANLkTikqJoDLRbU6269HF4UD8QoiNPrjPbcNTfZ9j38u@mail.gmail.com>
References: <19593.22297.612764.560375@valen.metzler>
	<20100914144339.GA9525@linuxtv.org>
	<19600.3015.410234.367070@valen.metzler>
	<AANLkTikqJoDLRbU6269HF4UD8QoiNPrjPbcNTfZ9j38u@mail.gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Manu Abraham writes:

 > > You still need a mechanism to decide which tuner gets it. First one
 > > which opens its own ca device?
 > > Sharing the CI (multi-stream decoding) in such an automatic way
 > > would also be complicated.
 > > I think I will only add such a feature if there is very high demand
 > > and rather look into the separate API solution.
 > 
 > 
 > It would be advantageous, if we do have just a simple input path,
 > where it is not restricted for CA/CI alone. I have some hardware over
 > here, where it has a DMA_TO_DEVICE channel (other than for the SG
 > table), where it can write a TS to any post-processor connected to it,
 > such as a CA/CI device, or even a decoder, for example. In short, it
 > could be anything, to put short.
 > 
 > In this case, the device can accept processed stream (muxed TS for
 > multi-TP TS) for CA, or a single TS/PS for decode on a decoder. You
 > can flip some registers for the device, for it to read from userspace,
 > or for that DMA channel to read from the hardware page tables of
 > another DMA channel which is coming from the tuner.
 > 
 > Maybe, we just need a simple mechanism/ioctl to select the CA/CI input
 > for the stream to the bridge. ie like a MUX: a 1:n select per adapter,
 > where the CA/CI device has 1 input and there are 'n' sources.


It would be nice to have a more general output device. But I have
currently no plans to support something like transparent streaming 
from one input to the output and back inside the driver.



-Ralph
