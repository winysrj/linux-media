Return-path: <linux-media-owner@vger.kernel.org>
Received: from ns.mm-sol.com ([37.157.136.199]:55899 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbcEMIpX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 13 May 2016 04:45:23 -0400
Subject: Re: gstreamer: v4l2videodec plugin
To: Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Stanimir Varbanov <stanimir.varbanov@linaro.org>,
	Discussion of the development of and with GStreamer
	<gstreamer-devel@lists.freedesktop.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Clark <robdclark@gmail.com>
References: <570B9285.9000209@linaro.org> <570B9454.6020307@linaro.org>
 <1460391908.30296.12.camel@collabora.com> <570CB882.4090805@linaro.org>
 <1460476636.2842.10.camel@collabora.com>
Cc: ayaka <ayaka@soulik.info>
From: Stanimir Varbanov <svarbanov@mm-sol.com>
Message-ID: <5735941E.6020703@mm-sol.com>
Date: Fri, 13 May 2016 11:45:18 +0300
MIME-Version: 1.0
In-Reply-To: <1460476636.2842.10.camel@collabora.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cc: ayaka

On 04/12/2016 06:57 PM, Nicolas Dufresne wrote:
> Le mardi 12 avril 2016 à 11:57 +0300, Stanimir Varbanov a écrit :
>>> I'm very happy to see this report. So far, we only had report that
>> this
>>> element works on Freescale IMX.6 (CODA) and Exynos 4/5.
>>
>> In this context, I would be very happy to see v4l2videoenc merged
>> soon :)
> 
> That will happen when all review comments are resolved.

yes, of course :)

Just FYI, I applied the WIP patches on my side and I'm very happy to
report that they just works. So If you need some testing on qcom video
accelerator just ping me.

One thing which bothers me is how the extra-controls property working,
i.e. I failed to change the h264 profile for example with below construct:

extra-controls="controls,h264_profile=4;"


-- 
regards,
Stan
