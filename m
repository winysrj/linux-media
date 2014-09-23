Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:54820 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752429AbaIWH2S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Sep 2014 03:28:18 -0400
Message-ID: <542120E4.5030403@st.com>
Date: Tue, 23 Sep 2014 09:27:32 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
MIME-Version: 1.0
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Patrice Chotard <patrice.chotard@st.com>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@stlinux.com>,
	<linux-media@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] media:st-rc: Misc fixes.
References: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
In-Reply-To: <1411424501-12673-1-git-send-email-srinivas.kandagatla@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Srini,

	Thanks for sending these fixes.

	For the series, you can add my:
Acked-by: Maxime Coquelin <maxime.coquelin@st.com>

Regards,
Maxime

On 09/23/2014 12:21 AM, Srinivas Kandagatla wrote:
> Hi Mauro,
>
> Thankyou for the "[media] enable COMPILE_TEST for media drivers" patch
> which picked up few things in st-rc driver in linux-next testing.
>
> Here is a few minor fixes to the driver, could you consider them for
> the next merge window.
>
> Thanks,
> srini
>
> Srinivas Kandagatla (3):
>    media: st-rc: move to using reset_control_get_optional
>    media: st-rc: move pm ops setup out of conditional compilation.
>    media: st-rc: Remove .owner field for driver
>
>   drivers/media/rc/st_rc.c | 8 +++-----
>   1 file changed, 3 insertions(+), 5 deletions(-)
>
