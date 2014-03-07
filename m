Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17019 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaCGJ33 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Mar 2014 04:29:29 -0500
Message-id: <53199175.6030606@samsung.com>
Date: Fri, 07 Mar 2014 10:29:25 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Arun Kumar K <arun.kk@samsung.com>, avnd.kiran@samsung.com
Cc: linux-media@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	k.debski@samsung.com, posciak@chromium.org,
	arunkk.samsung@gmail.com
Subject: Re: [PATCH] [media] s5p-mfc: add init buffer cmd to MFCV6
References: <1394181090-16446-1-git-send-email-arun.kk@samsung.com>
In-reply-to: <1394181090-16446-1-git-send-email-arun.kk@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 07/03/14 09:31, Arun Kumar K wrote:
> From: avnd kiran <avnd.kiran@samsung.com>
> 
> Latest MFC v6 firmware requires tile mode and loop filter
> setting to be done as part of Init buffer command, in sync
> with v7. So, move these settings out of decode options reg.
> Also, make this register definition applicable from v6 onwards.
> 
> Signed-off-by: avnd kiran <avnd.kiran@samsung.com>
> Signed-off-by: Arun Kumar K <arun.kk@samsung.com>

Will the driver also work with older version of the firmware
after this change ? If not, shouldn't things like this be done
depending on what firmware version is loaded ?

Regards,
Sylwester
