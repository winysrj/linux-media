Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44591 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308Ab2EYWrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 May 2012 18:47:47 -0400
Received: from dyn3-82-128-188-130.psoas.suomi.net ([82.128.188.130] helo=localhost.localdomain)
	by mail.kapsi.fi with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <crope@iki.fi>)
	id 1SY3IP-0002Vj-QV
	for linux-media@vger.kernel.org; Sat, 26 May 2012 01:47:45 +0300
Message-ID: <4FC00C11.10403@iki.fi>
Date: Sat, 26 May 2012 01:47:45 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>
Subject: DVB USB: change USB stream settings dynamically
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was planning make DVB USB be able to switch USB streaming parameters 
dynamically. I mean [struct usb_data_stream_properties] parameters.

Currently it reserves USB streaming buffers when device is plugged. Own 
buffer is reserved for each frontend, which means currently 1-3 
streaming buffers depending on device.

Basically I see USB TS as a DVB USB device property - not property of 
frontend. USB TS is interface between computer and USB-bridge and amount 
of parallel USB TS or TS configurations depends on USB-bridge 
capabilities. Sometimes used USB TS could be configured to fit better 
used stream. Smaller buffers for the narrow radio stream and biggest 
buffers for the wide DVB-S2 stream.

I was wondering how to resolve that situation? It is not very big 
problem currently but I still want to make it better as there is surely 
coming new devices that needs better control for the USB streaming 
parameters. Currently there is mxl111sf driver which seems to offer 6 
different streaming configurations but AFAIK only three is currently 
used as there is 3 frontends and each one has own streaming parameters - 
and buffers - even only one can be used at the time.

1. Configure streaming parameters (alloc buffers) every time when 
streaming is started? IIRC that causes some problems lately for em28xx 
as memory goes dis-coherent and buffers cannot allocated.

2. Allocate buffers (streaming configuration) for all needed device use 
configurations at very beginning. Then add some logic to map streaming 
config to frontend at runtime. That is quite near what mxl111sf does 
currently.

regards
Antti
-- 
http://palosaari.fi/
