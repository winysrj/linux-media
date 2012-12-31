Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:59154 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2LaT46 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Dec 2012 14:56:58 -0500
Message-ID: <50E1ECBD.3020605@gmail.com>
Date: Mon, 31 Dec 2012 20:51:25 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, grant.likely@secretlab.ca
CC: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	rob.herring@calxeda.com, nicolas.thery@st.com,
	s.hauer@pengutronix.de, laurent.pinchart@ideasonboard.com,
	hverkuil@xs4all.nl, devicetree-discuss@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH] [media] Add common binding documentation for video interfaces
References: <1355168499-5847-9-git-send-email-s.nawrocki@samsung.com> <1355606016-6509-1-git-send-email-sylvester.nawrocki@gmail.com> <50D0A475.7010800@wwwdotorg.org>
In-Reply-To: <50D0A475.7010800@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/18/2012 06:14 PM, Stephen Warren wrote:
> On 12/15/2012 02:13 PM, Sylwester Nawrocki wrote:
>> From: Guennadi Liakhovetski<g.liakhovetski@gmx.de>
>>
>> This patch adds a document describing common OF bindings for video
>> capture, output and video processing devices. It is currently mainly
>> focused on video capture devices, with data interfaces defined in
>> standards like ITU-R BT.656 or MIPI CSI-2.
>> It also documents a method of describing data links between devices.
>
> (quickly/briefly)
> Reviewed-by: Stephen Warren<swarren@nvidia.com>

Thank you for the review. I'm just wondering if it is OK to merge this
patch through the media tree, together with the remainder of this series.
Or should it go through the device tree maintainer's tree ?
