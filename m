Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33417 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756380Ab3AHQNt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 Jan 2013 11:13:49 -0500
Received: by mail-ie0-f181.google.com with SMTP id 16so696989iea.40
        for <linux-media@vger.kernel.org>; Tue, 08 Jan 2013 08:13:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1563062.kh1jqNm1kH@avalon>
References: <1353620736-6517-1-git-send-email-laurent.pinchart@ideasonboard.com>
	<9690842.n93imGlCHA@avalon>
	<CAF6AEGt+gwUq-xGze5bTgrKUMRijSBo_ORreq=Ot1RMD-WrbYQ@mail.gmail.com>
	<1563062.kh1jqNm1kH@avalon>
Date: Tue, 8 Jan 2013 10:13:48 -0600
Message-ID: <CAN_cFWPyrvO5RAvMHhZgQySf_Y5N2pz64uMurvdG0d-4zDjPFQ@mail.gmail.com>
Subject: Re: [RFC v2 0/5] Common Display Framework
From: Rob Clark <rob.clark@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Dave Airlie <airlied@gmail.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Tom Gall <tom.gall@linaro.org>,
	Ragesh Radhakrishnan <ragesh.r@linaro.org>,
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Vikas Sajjan <vikas.sajjan@linaro.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sebastien Guiriec <s-guiriec@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 8, 2013 at 2:25 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Rob,
>
> On Thursday 27 December 2012 09:54:55 Rob Clark wrote:
>> What I've done to avoid that so far is that the master device registers the
>> drivers for it's output sub-devices before registering it's own device.
>
> I'm not sure to follow you here. The master device doesn't register anything,
> do you mean the master device driver ? If so, how does the master device
> driver register its own device ? Devices are not registered by their driver.

sorry, that should have read "master driver registers drivers for it's
sub-devices.."

BR,
-R
