Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37609 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbcENMID (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 14 May 2016 08:08:03 -0400
Received: by mail-wm0-f42.google.com with SMTP id a17so67573172wme.0
        for <linux-media@vger.kernel.org>; Sat, 14 May 2016 05:08:02 -0700 (PDT)
Subject: Re: gstreamer: v4l2videodec plugin
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
 <1463223553.4185.3.camel@collabora.com>
Cc: ayaka <ayaka@soulik.info>,
	"p.zabel@pengutronix.de" <p.zabel@pengutronix.de>
From: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Message-ID: <5737151F.2090201@linaro.org>
Date: Sat, 14 May 2016 15:07:59 +0300
MIME-Version: 1.0
In-Reply-To: <1463223553.4185.3.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/14/2016 01:59 PM, Nicolas Dufresne wrote:
> Le vendredi 13 mai 2016 à 11:45 +0300, Stanimir Varbanov a écrit :
>> yes, of course :)
>>
>> Just FYI, I applied the WIP patches on my side and I'm very happy to
>> report that they just works. So If you need some testing on qcom
>> video
>> accelerator just ping me.
>>
>> One thing which bothers me is how the extra-controls property
>> working,
>> i.e. I failed to change the h264 profile for example with below
>> construct:
>>
>> extra-controls="controls,h264_profile=4;"
> 
> While I got you. I would be very interested to know who QCOM driver
> interpreted the width and height expose on capture side of the decoder.
> I'm adding Philippe Zabel in CC here (he's maintaining the
> CODA/Freescale decoder). In Samsung MFC driver, the width and height
> expose by the driver is the display size. Though, recently, Philippe is
> reporting that his driver is exposing the coded size. Fixing one in
> GStreamer will break the other, so I was wondering what other drivers
> are doing.

In qcom driver s_fmt on capture queue will return bigger or the same as
coded resolution depending on the width/height. This is related to hw
alignment restrictions i.e 1280x720 on output queue will become 1280x736
on capture queue. The the userspace can/must call g_crop to receive the
active resolution for displaying.

-- 
regards,
Stan
