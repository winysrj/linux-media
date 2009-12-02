Return-path: <linux-media-owner@vger.kernel.org>
Received: from vega.surpasshosting.com ([72.29.83.9]:45288 "EHLO
	vega.surpasshosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbZLBPI1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Dec 2009 10:08:27 -0500
Message-ID: <4B167539.2060109@embedded-sol.com>
Date: Wed, 02 Dec 2009 16:10:01 +0200
From: Felix Radensky <felix@embedded-sol.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
Subject: Trouble using OMAP3530 previewer in oneshot mode
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I'm trying to run OMAP3 ISP previewer in oneshot mode, without much success.
My goal is to put a 6MB Bayer10 image (captured on the same OMAP3 EVM)
into RAM, run previewer and get its output in RAM. I use linux-2.6.29 kernel
with ISP driver from omap3camera git tree.

For testing purposes Bayer10 image is stored into a file. My driver 
allocates
a 6MB buffer using iommu_vmalloc(), application maps this buffer  using
driver's mmap() method, copies input file into a buffer and signals the 
driver to
start a previewer. In PREV_DONE interrupt callback the driver wakes
application which stores previewer output from buffer into a file.

The following code runs previewer in oneshot mode (error checking 
removed for simplicity)

int isppreview_set_image_size(int width, int height)
{
    isp_obj.module.preview_input_height = height;
    isp_obj.module.preview_input_width = width;
    isp_obj.module.isp_pipeline = OMAP_ISP_PREVIEW;

    isppreview_try_size(isp_obj.module.preview_input_width,
                     isp_obj.module.preview_input_height,
                     &isp_obj.module.preview_output_width,
                     &isp_obj.module.preview_output_height);

    isppreview_config_inlineoffset(height * 2);
 
    isppreview_config_size(isp_obj.module.preview_input_width,
                    isp_obj.module.preview_input_height,
                    isp_obj.module.preview_output_width,
                    isp_obj.module.preview_output_height);
 }

int oneshot(int width, int height)
{
    isppreview_request();
    isp_set_callback(CBK_PREV_DONE, prev_done_cbk, NULL, NULL);

    isppreview_config_datapath(PRV_RAW_MEM, PREVIEW_MEM);
    isppreview_set_inaddr(prev_mem_mmu);
    isppreview_set_outaddr(prev_mem_mmu);
    isppreview_set_image_size(width, height);
    isp_enable_interrupts(0);
    isppreview_enable(1);
}

The PREV_DONE interrupt arrives, application saves resulting
image into a file, but it contains junk. The input file is known to
be good. The buffer mapping is good as well.

What am I doing wrong ?

Thanks a lot for your help.

Felix.
 
