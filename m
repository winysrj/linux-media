Return-path: <linux-media-owner@vger.kernel.org>
Received: from 132.79-246-81.adsl-static.isp.belgacom.be ([81.246.79.132]:35588
	"EHLO viper.mind.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960Ab0CQWxs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Mar 2010 18:53:48 -0400
From: Arnout Vandecappelle <arnout@mind.be>
To: linux-media@vger.kernel.org, mchehab@infradead.org, arnout@mind.be
Subject: [PATCH v3] Support for zerocopy to DMA buffers
Date: Wed, 17 Mar 2010 23:53:03 +0100
Message-Id: <1268866385-15692-1-git-send-email-arnout@mind.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

 Hoi,

 [Please CC me, I'm not subscribed.]

 I'm implementing zerocopy transfer from a v4l2 camera to the DSP on an 
OMAP3 (based on earlier work by Stefan Kost [1][2]).  Therefore I'm using 
V4L2_MEMORY_USERPTR to pass in the memory area allocated by TI's DMAI 
driver.  However, this has flags VM_IO | VM_PFNMAP.  This means that it is 
not possible to do get_user_pages() on it - it's an area that is not 
pageable and possibly even doesn't pass the MMU.

 In order to support this kind of zerocopy construct, I propose to add 
checks for VM_IO | VM_PFNMAP and only get pages from areas that don't have 
these flags set.

 I also fixed another issue: it was assumed that dma->sglen == dma->nr_pages,
which is not true for the USERPTR memory.  Thanks to Sakari Ailus for
pointing out a bug I introduced there.

 Regards,
 Arnout

[1] https://bugzilla.gnome.org/show_bug.cgi?id=583890
[2] http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/6209

