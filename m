Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:19030 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbZIOI3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 04:29:09 -0400
Message-ID: <4AAF5056.8000001@nt.tu-darmstadt.de>
Date: Tue, 15 Sep 2009 10:29:10 +0200
From: Vladimir Pantelic <pan@nt.tu-darmstadt.de>
MIME-Version: 1.0
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
Subject: Re: RFC: V4L - Support for video timings at the input/output interface
References: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
In-Reply-To: <A69FA2915331DC488A831521EAE36FE401550D0F8E@dlee06.ent.ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan wrote:

<snip>
> Open issues
> -----------
>
> 1.How to handle an HDMI transmitter? It can be put in two different modes: DVI compatible
> or HDMI compatible. Some of the choices are
> 	a) enumerate them as two different outputs when enumerating.
>          b) adding a status bit on the input.
>          c) change it using a control
>
> 2. Detecting whether there is an analog or digital signal on an DVI-I input:
> 	a) add new status field value for v4l2_input ?
> 	   #define  V4L2_IN_ST_DVI_ANALOG_DETECTED    0x10000000
> 	   #define  V4L2_IN_ST_DVI_DITIGITAL_DETECTED 0x20000000
>
> 3. Detecting an EDID.
> 	a) adding a status field in v4l2_output and two new ioctls that can
>           set the EDID for an input or retrieve it for an output. It should
>           also be added as an input/output capability.
>
> 4. ATSC bits in v4l2_std_id: how are they used? Are they used at all for
>     that matter?
>
>
> 6. HDMI requires additional investigation. HDMI defines a whole bunch of
>     infoframe fields. Most of these can probably be exported as controls?? Is
>     HDMI audio handled by alsa?

7. how does this interface/co-exist with something like DSS2 on the omap3?

who will "own" e.g. HDMI setup, DSS2 or V4L2?

