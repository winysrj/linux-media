Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:34051 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761964AbZCPTiI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2009 15:38:08 -0400
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] pxa_camera: Fix overrun condition on last buffer
References: <1236986240-24115-1-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-2-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-3-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-4-git-send-email-robert.jarzmik@free.fr>
	<1236986240-24115-5-git-send-email-robert.jarzmik@free.fr>
	<Pine.LNX.4.64.0903161225020.4409@axis700.grange>
From: Robert Jarzmik <robert.jarzmik@free.fr>
Date: Mon, 16 Mar 2009 20:37:56 +0100
In-Reply-To: <Pine.LNX.4.64.0903161225020.4409@axis700.grange> (Guennadi Liakhovetski's message of "Mon\, 16 Mar 2009 12\:25\:28 +0100 \(CET\)")
Message-ID: <878wn5dzsb.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Guennadi Liakhovetski <g.liakhovetski@gmx.de> writes:

>> +		if (camera_status & overrun
>> +		    && !list_is_last(pcdev->capture.next, &pcdev->capture)) {
>>  			dev_dbg(pcdev->dev, "FIFO overrun! CISR: %x\n",
>
> Please, put "&&" on the first line:-)
Dammit, I thought I had them all cornered :) Will do.

Cheers.

--
Robert
