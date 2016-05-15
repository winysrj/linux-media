Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:48821 "EHLO
	kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbcESQIk (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2016 12:08:40 -0400
Subject: Re: gstreamer: v4l2videodec plugin
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
 <1460476636.2842.10.camel@collabora.com> <5735941E.6020703@mm-sol.com>
 <1463298116.4185.5.camel@collabora.com>
From: ayaka <ayaka@soulik.info>
Message-ID: <3c2bb18b-ad42-bf31-51d6-c772efde7baa@soulik.info>
Date: Sun, 15 May 2016 23:02:47 +0800
MIME-Version: 1.0
In-Reply-To: <1463298116.4185.5.camel@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



在 2016年05月15日 15:41, Nicolas Dufresne 写道:
> Le vendredi 13 mai 2016 à 11:45 +0300, Stanimir Varbanov a écrit :
>> One thing which bothers me is how the extra-controls property
>> working,
>> i.e. I failed to change the h264 profile for example with below
>> construct:
>>
>> extra-controls="controls,h264_profile=4;"
> Yes, and profile should be negotiated with downstream in GStreamer. For
> common controls, like bitrate, it should be exposed as separate
> properties instead.
Please try the new patches in
https://github.com/hizukiayaka/gst-plugins-good
And look at this commit
https://github.com/hizukiayaka/gst-plugins-good/commit/92b99ba9322cf8a1039b877315b12bc9813e95cf

NOTE: even you could set those extra controls and driver accepted. It 
doesn't mean it would work.
I looked at the s5p-mfc driver, it just set it then leave it alone. I 
may fix this bug in the few weeks.
>
> Nicolas

