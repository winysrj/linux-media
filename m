Return-path: <mchehab@gaivota>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64964 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab0L2Ljc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Dec 2010 06:39:32 -0500
Received: by wyb28 with SMTP id 28so10026132wyb.19
        for <linux-media@vger.kernel.org>; Wed, 29 Dec 2010 03:39:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201012291137.49153.hverkuil@xs4all.nl>
References: <4D19037B.6060904@redhat.com>
	<AANLkTi=MFVH0b8y7eneaku9sf5x5ZWWiZBK+5Bptx6cE@mail.gmail.com>
	<201012291137.49153.hverkuil@xs4all.nl>
Date: Wed, 29 Dec 2010 17:09:29 +0530
Message-ID: <AANLkTi=oSzDjBAvJ9y6Z-+AkTjaEVZsCGv=Rsui0f55k@mail.gmail.com>
Subject: Re: [PATCH] [media] dabusb: Move it to staging to be deprecated
From: Manu Abraham <abraham.manu@gmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Felipe Sanches <juca@members.fsf.org>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Deti Fliegl <deti@fliegl.de>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Wed, Dec 29, 2010 at 4:07 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday, December 28, 2010 20:10:17 Felipe Sanches wrote:
>> Wait!
>>
>> It supports the DRBox1 DAB sold by Terratec:
>> http://www.baycom.de/wiki/index.php/Products::dabusbhw
>
> No, it doesn't. The driver in the kernel only supports the prototype board.
> The driver on baycom.de *does* support the Terratec product, but that's not
> in the kernel.
>
>> I've been working on a free firmware for this device:
>> http://libreplanet.org/wiki/LinuxLibre:USB_DABUSB
>
> I don't mind having support for DAB in the kernel, but any DAB API needs to
> be properly discussed, designed and documented. And it should probably be a
> part of the V4L2 API (since that already supports analog radio and RDS).
>
> By removing this driver from the kernel we open the way for a new DAB API
> without breaking support for any existing end-users since the current driver
> doesn't support any sold products.
>
> Frankly, I'm quite interested to see support for this and I'd be happy to
> work with someone on designing an API for it. Sounds interesting :-)
>


Quite unlikely that you need to design a new API for it.

The ETSI DAB page says:

"DAB system specifications

Digital Audio Broadcasting (DAB) uses Orthogonal Frequency Division
Multiplexing (OFDM) offering superior sound quality ..."

"ETSI is working with the WorldDAB Forum to develop standards for DMB:
these include the DMB Video Service (video carried by DAB) and MPEG-2
Transport streaming."

now TS102427 states:

"The DAB system EN 300 401 [1] defines the way that audio (programme)
and data services may be carried. However,
in MSC stream mode, the error protection scheme is optimised for audio
services. Data services carried in stream mode
(for example video services) require additional error protection and
this can be achieved by applying an outer coding to
the data packets before insertion into a DAB MSC stream mode
sub-channel. In order to provide as much commonality
in transmission and reception equipment as possible, the outer coding
is taken directly from DVB-T EN 300 744 [2],"


"The system is defined as a functional block that performs the
addition of outer coding (Reed-Solomon code) and outer
interleaving (convolutional interleaving). This functional block sits
between the output of the MPEG-2 transport
multiplexer and the input to a stream sub-channel of a DAB multiplexer,"

5 Error Protection for DAB MSC stream data
sub-channels and transport packets of 188 bytes
5.1 General considerations
Each input transport packet is 188 bytes long and starts with a
synchronizing byte of value 0x47. The transport packet
may contain any data. See ISO/IEC 13818 [3] for more details of the
format of transport packets.


Regards,
Manu
