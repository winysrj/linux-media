Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:9547 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1I3MIL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 08:08:11 -0400
Received: from epcpsbgm2.samsung.com (mailout1.samsung.com [203.254.224.24])
 by mailout1.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LSC0038T4DB2QB0@mailout1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Sep 2011 21:08:09 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LSC00CWY4DGY710@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Sep 2011 21:08:09 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org
Cc: kyungmin.park@samsung.com, mchehab@infradead.org,
	patches@linaro.org, Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1317380162-16344-1-git-send-email-sachin.kamat@linaro.org>
In-reply-to: <1317380162-16344-1-git-send-email-sachin.kamat@linaro.org>
Subject: RE: [PATCH 1/1] [media] MFC: Change MFC firmware binary name
Date: Fri, 30 Sep 2011 14:08:03 +0200
Message-id: <001201cc7f69$9e690c80$db3b2580$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sachin,

Thanks for the patch. I agree with you - MFC module could be used in other
SoCs as well.

> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: 30 September 2011 12:56
> 
> This patches renames the MFC firmware binary to avoid SoC name in it.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>

Acked-by: Kamil Debski <k.debski@samsung.com>

> ---
>  drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> index 5f4da80..f2481a8 100644
> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> @@ -38,7 +38,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> *dev)
>  	 * into kernel. */
>  	mfc_debug_enter();
>  	err = request_firmware((const struct firmware **)&fw_blob,
> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
>  	if (err != 0) {
>  		mfc_err("Firmware is not present in the /lib/firmware directory
> nor compiled in kernel\n");
>  		return -EINVAL;
> @@ -116,7 +116,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
>  	 * into kernel. */
>  	mfc_debug_enter();
>  	err = request_firmware((const struct firmware **)&fw_blob,
> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
>  	if (err != 0) {
>  		mfc_err("Firmware is not present in the /lib/firmware directory
> nor compiled in kernel\n");
>  		return -EINVAL;
> --
> 1.7.4.1

Best regards,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

