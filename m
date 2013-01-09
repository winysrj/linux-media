Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46336 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757314Ab3AII3r (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 9 Jan 2013 03:29:47 -0500
MIME-Version: 1.0
In-Reply-To: <CAN_cFWPyrvO5RAvMHhZgQySf_Y5N2pz64uMurvdG0d-4zDjPFQ@mail.gmail.com>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<9690842.n93imGlCHA@avalon>
	<CAF6AEGt+gwUq-xGze5bTgrKUMRijSBo_ORreq=Ot1RMD-WrbYQ@mail.gmail.com>
	<1563062.kh1jqNm1kH@avalon>
	<CAN_cFWPyrvO5RAvMHhZgQySf_Y5N2pz64uMurvdG0d-4zDjPFQ@mail.gmail.com>
Date: Wed, 9 Jan 2013 13:53:30 +0530
Message-ID: <CAPdUM4P6riQVJ4m4Sdkh1O8xmpKF4YnhGq69p7DkxAdr165KYA@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rahul Sharma <r.sh.open@gmail.com>
To: Rob Clark <rob.clark@linaro.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Tom Gall <tom.gall@linaro.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

CDF will also be helpful in supporting Panels with integrated
audio (HDMI/DP) if we can add audio related control operations to
display_entity_control_ops. Video controls will be called by crtc
in DRM/V4L and audio controls from Alsa.

Secondly, if I need to support get_modes operation in hdmi/dp
panel, I need to implement edid parser inside the panel driver. It
will be meaningful to add get_edid control operation for hdmi/dp.

regards,
Rahul Sharma.

On Tue, Jan 8, 2013 at 9:43 PM, Rob Clark <rob.clark@linaro.org> wrote:
> On Tue, Jan 8, 2013 at 2:25 AM, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
>> Hi Rob,
>>
>> On Thursday 27 December 2012 09:54:55 Rob Clark wrote:
>>> What I've done to avoid that so far is that the master device registers the
>>> drivers for it's output sub-devices before registering it's own device.
>>
>> I'm not sure to follow you here. The master device doesn't register anything,
>> do you mean the master device driver ? If so, how does the master device
>> driver register its own device ? Devices are not registered by their driver.
>
> sorry, that should have read "master driver registers drivers for it's
> sub-devices.."
>
> BR,
> -R
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
