Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:44394
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946AbZKXENQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Nov 2009 23:13:16 -0500
Message-ID: <4B0B5E84.1030305@wilsonet.com>
Date: Mon, 23 Nov 2009 23:18:12 -0500
From: Jarod Wilson <jarod@wilsonet.com>
MIME-Version: 1.0
To: Christoph Bartelmus <lirc@bartelmus.de>
CC: dmitry.torokhov@gmail.com, j@jannau.net, jarod@redhat.com,
	khc@pm.waw.pl, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
References: <BDRabhTZjFB@christoph>
In-Reply-To: <BDRabhTZjFB@christoph>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/23/2009 04:10 PM, Christoph Bartelmus wrote:
> Hi Jarod,
>
> on 23 Nov 09 at 14:17, Jarod Wilson wrote:
>>> Krzysztof Halasa wrote:
> [...]
>>> If you see patch 3/3, of the lirc submission series, you'll notice a driver
>>> that has hardware decoding, but, due to lirc interface, the driver
>>> generates pseudo pulse/space code for it to work via lirc interface.
>
>> Historically, this is true.
>
> No, it's not.
> I think you misunderstood the code. The comment may be a bit misleading,
> too.
> Early iMON devices did not decode in hardware and the part of the driver
> that Krzystof is referring to is translating a bit-stream of the sampled
> input data into pulse/space durations.

Sorry, no, I know the newer devices don't actually send pulse/data info 
out to userspace, just hex codes that correspond to key presses. What I 
meant was "onboard decoding devices can operate as pure input devices or 
in classic lirc mode", leaving out the details on exactly what they were 
sending out to userspace. :)

-- 
Jarod Wilson
jarod@wilsonet.com
