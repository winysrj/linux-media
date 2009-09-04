Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:33906 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753432AbZIDNC7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Sep 2009 09:02:59 -0400
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id n84D2vEX000443
	for <linux-media@vger.kernel.org>; Fri, 4 Sep 2009 08:03:02 -0500
Received: from dlep20.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id n84D2udA011427
	for <linux-media@vger.kernel.org>; Fri, 4 Sep 2009 08:02:56 -0500 (CDT)
Received: from dsbe71.ent.ti.com (localhost [127.0.0.1])
	by dlep20.itg.ti.com (8.12.11/8.12.11) with ESMTP id n84D2upD007819
	for <linux-media@vger.kernel.org>; Fri, 4 Sep 2009 08:02:56 -0500 (CDT)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Fri, 4 Sep 2009 08:03:00 -0500
Subject: Handling second output from vpfe capture  - Any suggestion ?
Message-ID: <A69FA2915331DC488A831521EAE36FE40154FACF34@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am working on to add additional capabilities to vpfe capture driver to allow capture two frames simultaneously for each received frame from the input video decoder or sensor device. This is done using the IPIPE and Resizer hw available in DM355. In our internal release this is done by configuring IPIPE to receive from directly from CCDC and then passing it to 
the Resizer. Resizer has two outputs that operates on the same input frame. One output is usually used for capturing full resolution frame and the other is limited to output VGA or less resolution frames. Typically this will be useful for previewing the video on a smaller LCD screen using the second output while using the full resolution frame for encoding.

Since input frame is same for both these inputs, we had implemented using a bigger capture buffer that can hold both the frames. The second frame is captured at the end of the first frame. This allowed us to DQBUF both frames simultaneously. But we used proprietary IOCTL to change the output size or format. I think a better alternative is to implement another Queue in the vpfe capture that can take a V4L2_BUF_TYPE_PRIVATE. This will allow me to configure the output format of second output independently for the second output. Looking at the v4l2-ioctl.c there is support for this buffer type. But this buffer type is not used by any driver and I am not sure if this will work or is the right approach to deal with this problem. Any suggestion here? 

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

