Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:41167 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbcEIINP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 9 May 2016 04:13:15 -0400
Subject: Re: gstreamer: v4l2videodec plugin
To: Nicolas Dufresne <nicolas@ndufresne.ca>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
 <CAF6AEGvjin7Ya4wAXF=5vAa=ky=yvUHnYSo8Of_cyd8TCc04UQ@mail.gmail.com>
 <1460736595.973.5.camel@ndufresne.ca> <5721F4FC.30001@linaro.org>
 <1462139288.25248.33.camel@ndufresne.ca>
Cc: Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <57304693.4010007@mm-sol.com>
Date: Mon, 9 May 2016 11:13:07 +0300
MIME-Version: 1.0
In-Reply-To: <1462139288.25248.33.camel@ndufresne.ca>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/02/2016 12:48 AM, Nicolas Dufresne wrote:
> Le jeudi 28 avril 2016 à 14:33 +0300, Stanimir Varbanov a écrit :
>> So I'm wondering is that intensional?
>>
>> Depending on the answer I should make the same in the Gallium dri2 in
>> dri2_from_dma_bufs().
> 
> It's DRI format that are confusing. In GStreamer DRI_FORMAT_GR88 would
> be named RG88 (if it existed). That's because DRI API present it in the
> way it would look on the CPU after loading that 16bit word into a
> register. In GStreamer instead, we expose is as the way you'll find it
> in the data array. Let's see it this way, DRI present the information
> in a way people writing rasterizer see it.

Thanks Nicolas,

I will cook up patches based on this for Gallium dri2 and will see the
comments.

-- 
regards,
Stan
