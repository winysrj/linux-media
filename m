Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39625 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2IGVlA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 7 Sep 2012 17:41:00 -0400
Received: by eekc1 with SMTP id c1so22275eek.19
        for <linux-media@vger.kernel.org>; Fri, 07 Sep 2012 14:40:59 -0700 (PDT)
Message-ID: <504A69E7.9090900@gmail.com>
Date: Fri, 07 Sep 2012 23:40:55 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Sangwook Lee <sangwook.lee@linaro.org>
CC: linux-media@vger.kernel.org, mchehab@infradead.org,
	laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
	hans.verkuil@cisco.com, linaro-dev@lists.linaro.org,
	patches@linaro.org, scott.bambrough@linaro.org,
	s.nawrocki@samsung.com
Subject: Re: [RFC PATCH v6] media: add v4l2 subdev driver for S5K4ECGX sensor
References: <1346944114-17527-1-git-send-email-sangwook.lee@linaro.org>
In-Reply-To: <1346944114-17527-1-git-send-email-sangwook.lee@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sangwook,

On 09/06/2012 05:08 PM, Sangwook Lee wrote:
> This patch adds driver for S5K4ECGX sensor with embedded ISP SoC,
> S5K4ECGX, which is a 5M CMOS Image sensor from Samsung
> The driver implements preview mode of the S5K4ECGX sensor.
> capture (snapshot) operation, face detection are missing now.
> Following controls are supported:
> contrast/saturation/brightness/sharpness
>
> Signed-off-by: Sangwook Lee<sangwook.lee@linaro.org>
> Reviewed-by: Sylwester Nawrocki<s.nawrocki@samsung.com>

Thanks for the update. I've done a few more minor fixes and improved
s_stream() subdev op handling, so it really enables/disables data
stream on the sensor's output. It's pushed to

git://linuxtv.org/snawrocki/media.git samsung_s5k4ecgx

Could you please squash the changes that you are willing to accept
and test if the last patch really does what it is intended to ?

After you send v7 I could add this patch to my tree for v3.7,
unless you want to handle it yourself.

--
Thanks,
Sylwester
