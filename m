Return-path: <mchehab@pedra>
Received: from lo.gmane.org ([80.91.229.12]:58683 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754443Ab1BXNuG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Feb 2011 08:50:06 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1Psba0-0001PN-Aa
	for linux-media@vger.kernel.org; Thu, 24 Feb 2011 14:50:04 +0100
Received: from 228.31.17-93.rev.gaoland.net ([228.31.17-93.rev.gaoland.net])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 14:50:04 +0100
Received: from akue.loic by 228.31.17-93.rev.gaoland.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Thu, 24 Feb 2011 14:50:04 +0100
To: linux-media@vger.kernel.org
From: =?utf-8?b?TG/Dr2M=?= Akue <akue.loic@gmail.com>
Subject: Re: omap3-isp: can't register subdev for new sensor driver mt9t001
Date: Thu, 24 Feb 2011 13:41:23 +0000 (UTC)
Message-ID: <loom.20110224T142616-389@post.gmane.org>
References: <AANLkTincndvx154DXHgeNCnxe+KhtaH+tFUTfqXufFdp@mail.gmail.com> <AANLkTikVTgo48gfSUc9DyOhTCwSOuGS0gnjP6xTomor-@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Hello Bastian,

As a newbie in kernel development, I'm facing the same issue about subdev
registration. 
I'm trying to capture some raw video from a SAA7113 connected to the ISP of an
omap3530. May I please have your help with this problem?

root@cm-t35:~# modprobe iommu
[ 8409.776123] omap-iommu omap-iommu.0: isp registered

root@cm-t35:~# modprobe omap3_isp
[ 8451.821533] omap3isp omap3isp: Revision 2.0 found
[ 8451.827056] omap-iommu omap-iommu.0: isp: version 1.1
[ 8453.291992] isp_register_subdev_group: Unable to register subdev saa7113

Regards 

Loïc Akue

