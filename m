Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:61054 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbZETObR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 10:31:17 -0400
Date: Wed, 20 May 2009 16:31:04 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Stefano Danzi <s.danzi@hawai.it>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Making a DVB-S Transmitter
In-Reply-To: <4A03E492.1090504@hawai.it>
Message-ID: <alpine.LRH.1.10.0905201618150.15868@pub4.ifh.de>
References: <4A03E492.1090504@hawai.it>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Stefano,

On Fri, 8 May 2009, Stefano Danzi wrote:

> Hi!!
>
> I and some others Ham radio operators are working on a pc-based
> dvb-s transmitter.
>
> Reference website are: http://www.m0dts.co.uk/datv.htm

I read very quickly the website, interesting project :)

> Interfare between pc and transmitter is based on FTDI FT245 (usb fifo).
>
> Goal will be create a device like /dev/dvbs-tx, write into a mpeg-ts stream 
> so
> kernel module convert it to a dvb-s signal and send it to the usb fifo.

When you say, the kernel module converts it to a dvb-s signal? Do you mean 
you want to do a MPEG2-TS to DVB-S I/Q generator? Please 
describe closer what is the input format expected by the FTDI FT245.

In general I would suggest that all the busy/important parts are done in 
userspace. Kernel modules should generally do nothing more that to copy 
data AS IS from host memory to device memory.

Saying that any conversion, modulation or whatever should be done in 
user-space.

If you're lucky you don't even need a kernel module to write to your USB 
device. There is a slight chance that using libusb to write the data to 
your hardware is sufficient. I think I read somewhere that there is a 
faster way to write data to a USB device with recent kernels than libusb 
from userspace, but maybe it was a dream. Check linux/Documentation to see 
whether you can find something.

Good luck ;)
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
