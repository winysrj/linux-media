Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58261 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab3AaRvn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Jan 2013 12:51:43 -0500
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MHI00LZY49KNC80@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 17:51:41 +0000 (GMT)
Received: from [106.116.147.32] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MHI00H634A49540@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 31 Jan 2013 17:51:41 +0000 (GMT)
Message-id: <510AAF2B.8060008@samsung.com>
Date: Thu, 31 Jan 2013 18:51:39 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: g.liakhovetski@gmx.de, linux-media@vger.kernel.org,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	swarren@wwwdotorg.org, rob.herring@calxeda.com,
	thomas.abraham@linaro.org, t.figa@samsung.com,
	myungjoo.ham@samsung.com, sw0312.kim@samsung.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH RFC v5 1/2] [media] Add common video interfaces OF bindings
 documentation
References: <1359652738-1544-1-git-send-email-s.nawrocki@samsung.com>
 <1359652738-1544-2-git-send-email-s.nawrocki@samsung.com>
 <2299160.YVaS9PguWs@avalon>
In-reply-to: <2299160.YVaS9PguWs@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 01/31/2013 06:33 PM, Laurent Pinchart wrote:
>> Changes since v4:
>>  - added note that multiple endpoints at a port can be active at any time,
>>  - introduced optional 'ports' node aggregating 'port' nodes if required
>>    to avoid conflicts with any child bus of a device,
> 
> The 'ports' node seems to be missing from the documentation.

Ouch, indeed. I must have lost it somewhere during rebase :-/
I'll re-create it and resend.

--

Regards,
Sylwester
