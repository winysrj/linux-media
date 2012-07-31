Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:33440 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2GaIN4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jul 2012 04:13:56 -0400
Received: from eusync2.samsung.com (mailout4.w1.samsung.com [210.118.77.14])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8000GCMMW833A0@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 09:14:32 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M80007NWMV5JP20@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 31 Jul 2012 09:13:53 +0100 (BST)
Message-id: <501793C0.1050603@samsung.com>
Date: Tue, 31 Jul 2012 10:13:52 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	patches@linaro.org
Subject: Re: [PATCH 1/2] [media] s5k6aa: Use devm_kzalloc function
References: <1343283813-24326-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1343283813-24326-1-git-send-email-sachin.kamat@linaro.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

On 07/26/2012 08:23 AM, Sachin Kamat wrote:
> devm_kzalloc() eliminates the need to free explicitly thereby
> making the code a bit simpler.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Thanks for the patch. Since I have nothing more for a pull request
right now,

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

--

Regards,
Sylwester
