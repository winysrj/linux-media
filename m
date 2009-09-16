Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:55016 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZIPVJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 17:09:05 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Vladimir Pantelic <pan@nt.tu-darmstadt.de>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Date: Wed, 16 Sep 2009 16:09:05 -0500
Subject: RE: RFC: V4L - Support for video timings at the input/output
 interface
Message-ID: <A69FA2915331DC488A831521EAE36FE4015515707E@dlee06.ent.ti.com>
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
 <4AAF5056.8000001@nt.tu-darmstadt.de>
In-Reply-To: <4AAF5056.8000001@nt.tu-darmstadt.de>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

>>
>> 6. HDMI requires additional investigation. HDMI defines a whole bunch of
>>     infoframe fields. Most of these can probably be exported as
>controls?? Is
>>     HDMI audio handled by alsa?
>
>7. how does this interface/co-exist with something like DSS2 on the omap3?
>
>who will "own" e.g. HDMI setup, DSS2 or V4L2?
>

I still don't know what DSS2 is capable of doing. Will DSS2 work with 
v4l2 sub devices? If so, this RFC applies. I think DSS2 uses its own
interface to integrate a encoder device. Besides it uses (I believe) sysfs
to change the standards at the output. So I don't have an answer to your
question. I will let DSS2 owner to respond.

Murali
