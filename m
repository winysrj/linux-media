Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:65165 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758AbaKKEhH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 23:37:07 -0500
Received: by mail-oi0-f44.google.com with SMTP id h136so6521655oig.17
        for <linux-media@vger.kernel.org>; Mon, 10 Nov 2014 20:37:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1411101243230.23739@axis700.grange>
References: <CANC6fRFjG6002rDiJjfDHteQSAnRkwfpyWV8wB39oHu5P8Q2mA@mail.gmail.com>
	<Pine.LNX.4.64.1411101243230.23739@axis700.grange>
Date: Tue, 11 Nov 2014 12:37:06 +0800
Message-ID: <CANC6fRGVdWq5sBxLW=Z2ijVTrLv-RsuMkiq94uQV7yHQq7vi3Q@mail.gmail.com>
Subject: Re: Add controls to query camera read only paramters
From: Bin Chen <bin.chen@linaro.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On 10 November 2014 19:46, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> Hi Bin,
>
> On Sat, 8 Nov 2014, Bin Chen wrote:
>
>> Hi Everyone,
>>
>> I need suggestions with regard to adding controls to query camera read
>> only parameters (e.g maxZoom/maxExposureCompensation) as needed by
>> Android Camera API[1].
>
> I'm not sure all Android HAL metadata tags should be 1-to-1 implemented in
> V4L2.

Yes, we won't need 1-1 mapping and I'm just trying to identify the
gaps and will add only those that are make sense.

> Some of them can be derived from existing information, some are even
> more relevant to the HAL, then to the camera (kernel driver).
We can do it in both places and the boundary is kind of blur, at least
for me:). Any guideline to follow? Putting them in driver maybe
reasonable in the sense that all hardware related information are put
together in one place - the driver. V4L2_CID_PIXEL_RATE is an example
in V4l2 to provide such read-only information.
