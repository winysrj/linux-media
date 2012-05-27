Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:50174 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab2E0NKe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 May 2012 09:10:34 -0400
Received: from dyn3-82-128-188-130.psoas.suomi.net ([82.128.188.130] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SYdEt-00028Y-Tw
	for linux-media@vger.kernel.org; Sun, 27 May 2012 16:10:31 +0300
Message-ID: <4FC227C7.3080309@iki.fi>
Date: Sun, 27 May 2012 16:10:31 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: Re: DVB USB: change USB stream settings dynamically
References: <4FC00C11.10403@iki.fi>
In-Reply-To: <4FC00C11.10403@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26.05.2012 01:47, Antti Palosaari wrote:
> I was planning make DVB USB be able to switch USB streaming parameters
> dynamically. I mean [struct usb_data_stream_properties] parameters.
>
> Currently it reserves USB streaming buffers when device is plugged. Own
> buffer is reserved for each frontend, which means currently 1-3
> streaming buffers depending on device.
>
> Basically I see USB TS as a DVB USB device property - not property of
> frontend. USB TS is interface between computer and USB-bridge and amount
> of parallel USB TS or TS configurations depends on USB-bridge
> capabilities. Sometimes used USB TS could be configured to fit better
> used stream. Smaller buffers for the narrow radio stream and biggest
> buffers for the wide DVB-S2 stream.
>
> I was wondering how to resolve that situation? It is not very big
> problem currently but I still want to make it better as there is surely
> coming new devices that needs better control for the USB streaming
> parameters. Currently there is mxl111sf driver which seems to offer 6
> different streaming configurations but AFAIK only three is currently
> used as there is 3 frontends and each one has own streaming parameters -
> and buffers - even only one can be used at the time.
>
> 1. Configure streaming parameters (alloc buffers) every time when
> streaming is started? IIRC that causes some problems lately for em28xx
> as memory goes dis-coherent and buffers cannot allocated.
>
> 2. Allocate buffers (streaming configuration) for all needed device use
> configurations at very beginning. Then add some logic to map streaming
> config to frontend at runtime. That is quite near what mxl111sf does
> currently.

After looking existing code carefully and doing some tests I think I 
will implement that a way it changes buffers at runtime to fit current 
needs.

int usb_urb_submit(struct usb_data_stream *stream) is called when 
streaming is started. At that point it is possible to compare already 
reserved buffers and buffers needed. If needed buffers are larger it is 
possible to reallocate bigger buffers. Of course it is not needed to 
decrease buffers even smaller stream configurations is asked, just to 
avoid repetitive allocations of large chunks of coherent memory.

1) allocate buffers at the init as now (callback to read stream 
properties from the driver)
2) re-allocate bigger buffers in runtime if needed (callback to read 
stream properties from the driver)
3) free all buffers when device is disconnected

Basically those USB buffers are type of (buffer count) x (buffer size). 
Buffer count is same as used count of URBs, typically ~5, and buffer 
size is the payload size of one URB.

Here is some background info (em28xx buffer alloc failures) why to avoid 
continuous buffer allocs / frees.
http://www.spinics.net/lists/linux-media/msg44209.html

regards
Antti
-- 
http://palosaari.fi/
