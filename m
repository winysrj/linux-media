Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:32609 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932683AbaGWRX0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jul 2014 13:23:26 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: devicetree@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH v4 1/2] media: soc_camera: pxa_camera device-tree support
References: <1404051600-20838-1-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.1407231126210.30243@axis700.grange>
	<Pine.LNX.4.64.1407231915310.1526@axis700.grange>
Date: Wed, 23 Jul 2014 19:23:22 +0200
In-Reply-To: <Pine.LNX.4.64.1407231915310.1526@axis700.grange> (Guennadi
	Liakhovetski's message of "Wed, 23 Jul 2014 19:17:24 +0200 (CEST)")
Message-ID: <87a980ugz9.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

> Add device-tree support to pxa_camera host driver.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>
> [g.liakhovetski@gmx.de: added of_node_put()]
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>
> Robert, could you review and test this version, please?
Yeah, sure, a couple of hours and it will be tested.

Cheers.

--
Robert
