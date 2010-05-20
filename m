Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:57213 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754419Ab0ETUKK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 May 2010 16:10:10 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1OFC4A-0008Lj-R5
	for linux-media@vger.kernel.org; Thu, 20 May 2010 22:10:03 +0200
Received: from proxyle01.ext.ti.com ([192.91.75.29])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 20 May 2010 22:10:02 +0200
Received: from asheeshb by proxyle01.ext.ti.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 20 May 2010 22:10:02 +0200
To: linux-media@vger.kernel.org
From: Asheesh Bhardwaj <asheeshb@ti.com>
Subject: MMAP buffer allocation Davinci 
Date: Thu, 20 May 2010 20:03:12 +0000 (UTC)
Message-ID: <loom.20100520T212708-677@post.gmane.org>
References: <1274287478-14661-1-git-send-email-asheeshb@ti.com> <A69FA2915331DC488A831521EAE36FE4016AFDE3A6@dlee06.ent.ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Karicheri, Muralidharan <m-karicheri2 <at> ti.com> writes:

> 
> Asheesh,
> 
> Please re-send this patch with following:-
> 
> 1) A detailed description of what you are trying to fix in each of this 
patch. You need to also run the
> checkpatch.pl script to make sure there are no errors.
> 2) Please make this patch based on the http://git.linuxtv.org/v4l-dvb.git 
master branch. I am assuming
> you have based it upon the Arago tree.
> 3) add the Signed-off-by field.
> 
> Murali Karicheri
> Software Design Engineer
> Texas Instruments Inc.
> Germantown, MD 20874
> phone: 301-407-9583
> email: m-karicheri2 <at> ti.com
> 
> >-----Original Message-----
> >From: linux-media-owner <at> vger.kernel.org [mailto:linux-media-
> >owner <at> vger.kernel.org] On Behalf Of Bhardwaj, Asheesh
> >Sent: Wednesday, May 19, 2010 12:45 PM
> >To: linux-media <at> vger.kernel.org
> >Subject:
> >
> >The patches will be applied to the davinci tree
> >the ../drivers/media/video/davinci and will affect the both the capture and
> >display drivers. Apply these patches to the git kernel.
> >From asheeshb <at> ti.com # This line is ignored.
> >GIT:
> >From: asheeshb <at> ti.com
> >Subject:
> >In-Reply-To:
> >
> >--
> >To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >the body of a message to majordomo <at> vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
The following portion of the mail was truncted from the originla post. Thers 
are 1-7 patches on this series. The kernel patches are targetted for support 
of memory allocation during boot time for large buffers. This will allow the 
user to get contiguous buffers beyond linux memory and can configure the 
location and size of the buffer using parametrs configured during boot time 
using bootargs. The current implementation will allow the application to get 
MMAP buffers but those buffers cannot be contiguous  and create 
defragmentation. The approach to provide contiguous buffers is inherited from 
the ../drivers/media/video/sh_mobile_ceu_camera.c already exist in the 
community code which uses dma_alloc_coherent function to get the contiguous 
buffers from the memory. During runtime the driver will allocate the required 
buffers from the contiguous memory.
The memory can be configured using the following arguments on the bootargs
1. Davinci display and vpfe cature driver
davinci_display.cont2_bufsize=<size of the total display buffers in bytes> 
davinci_display.cont2_bufoffset=<offset for the display buffers from linux 
memory in bytes> 
vpfe_capture.cont_bufsize==<size of the total capture buffers in bytes>
vpfe_capture.cont_bufoffset==<offset for the capture buffer from linux memory 
bytes> 
 

2. DavinciHD VPIF display and capture driver
vpif_display.cont_bufsize=<size of the display buffers in bytes> 
vpif_display.cont_bufoffset=<offset for the display buffers from linux memory 
in bytes> 
vpif_capture.cont_bufsize=<size of the capture buffers in 
bytes>                                             
vpif_capture.cont_bufoffset=<offset for the capture buffers from linux memory 
in bytes>
 


The patches will be applied to the davinci tree 
the ../drivers/media/video/davinci and will affect the both the capture and 
display drivers. Apply these patches to the git kernel.



