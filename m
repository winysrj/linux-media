Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:62880 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1I3NPm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 09:15:42 -0400
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LSC00HQK7HMRZO0@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Fri, 30 Sep 2011 22:15:40 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LSC00DCS7I0IX60@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Fri, 30 Sep 2011 22:15:40 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Subash Patel' <subash.ramaswamy@linaro.org>
Cc: 'Sachin Kamat' <sachin.kamat@linaro.org>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	mchehab@infradead.org, patches@linaro.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
References: <1317380162-16344-1-git-send-email-sachin.kamat@linaro.org>
 <001201cc7f69$9e690c80$db3b2580$%debski@samsung.com>
 <4E85BB23.70300@linaro.org>
In-reply-to: <4E85BB23.70300@linaro.org>
Subject: RE: [PATCH 1/1] [media] MFC: Change MFC firmware binary name
Date: Fri, 30 Sep 2011 15:15:34 +0200
Message-id: <001401cc7f73$0ce78d90$26b6a8b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Subash,

> From: Subash Patel [mailto:subash.ramaswamy@linaro.org]
> Sent: 30 September 2011 14:51
> 
> Hello,
> 
> There is option in menu->"Device Drivers"->"Generic Driver
> Options"->"External firmware blobs to build into the kernel binary".
> I have used this many times instead of /lib/firmware mechanism. If
> someone chooses to add firmware in that way, and gives different name,
> then this code too can break. So I have proposed another way to solve
> that. Have a look into this.

The CONFIG_EXTRA_FIRMWARE is a list of all firmware blobs that are going to
be embedded in the kernel. As such I am afraid your solution will not work.

I don't see the need for adding a configuration option for firmware name.
Some good solution would be adding the following line to s5p_mfc_commn.h

#define MFC_FIRMWARE_NAME "s5p-mfc.fw"

and using MFC_FIRMWARE_NAME in the code.

However I feel that the firmware name will change very rarely. If ever.
Such option to change the name using a configuration option might be 
useful during development and testing of various fw versions, but I have
serious doubts that it should enter the mainline.

> 
> 
> On 09/30/2011 05:38 PM, Kamil Debski wrote:
> > Hi Sachin,
> >
> > Thanks for the patch. I agree with you - MFC module could be used in other
> > SoCs as well.
> >
> >> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> >> Sent: 30 September 2011 12:56
> >>
> >> This patches renames the MFC firmware binary to avoid SoC name in it.
> >>
> >> Signed-off-by: Sachin Kamat<sachin.kamat@linaro.org>
> >
> > Acked-by: Kamil Debski<k.debski@samsung.com>
> >
> >> ---
> >>   drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c |    4 ++--
> >>   1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> >> b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> >> index 5f4da80..f2481a8 100644
> >> --- a/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> >> +++ b/drivers/media/video/s5p-mfc/s5p_mfc_ctrl.c
> >> @@ -38,7 +38,7 @@ int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev
> >> *dev)
> >>   	 * into kernel. */
> >>   	mfc_debug_enter();
> >>   	err = request_firmware((const struct firmware **)&fw_blob,
> >> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
> >> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
> >>   	if (err != 0) {
> >>   		mfc_err("Firmware is not present in the /lib/firmware directory
> >> nor compiled in kernel\n");
> >>   		return -EINVAL;
> >> @@ -116,7 +116,7 @@ int s5p_mfc_reload_firmware(struct s5p_mfc_dev *dev)
> >>   	 * into kernel. */
> >>   	mfc_debug_enter();
> >>   	err = request_firmware((const struct firmware **)&fw_blob,
> >> -				     "s5pc110-mfc.fw", dev->v4l2_dev.dev);
> >> +				     "s5p-mfc.fw", dev->v4l2_dev.dev);
> int s5p_mfc_alloc_and_load_firmware(struct s5p_mfc_dev *dev)
> {
>          struct firmware *fw_blob;
>          size_t bank2_base_phys;
>          void *b_base;
>          int err;
>          /* default name */
>          char firmware_name[30] = "s5p-mfc.fw";
> 
>          /* Firmare has to be present as a separate file or compiled
>           * into kernel. */
>          mfc_debug_enter();
> 
> #ifdef CONFIG_EXTRA_FIRMWARE
>          snprintf(firmware_name, sizeof(firmware_name), "%s",
>                                          CONFIG_EXTRA_FIRMWARE);
> #endif
>          err = request_firmware((const struct firmware **)&fw_blob,
>                                       firmware_name, dev->v4l2_dev.dev);
>          if (err != 0) {
>                  mfc_err("Firmware is not present in the /lib/firmware
> directory nor compiled in kernel\n");
>                  return -EINVAL;
>          }
> <snip>
> 
> >>   	if (err != 0) {
> >>   		mfc_err("Firmware is not present in the /lib/firmware directory
> >> nor compiled in kernel\n");
> >>   		return -EINVAL;
> >> --
> >> 1.7.4.1

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

