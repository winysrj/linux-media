Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46667 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab1HVEMs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Aug 2011 00:12:48 -0400
Received: by gxk21 with SMTP id 21so3322273gxk.19
        for <linux-media@vger.kernel.org>; Sun, 21 Aug 2011 21:12:48 -0700 (PDT)
Message-ID: <4E51D739.7010000@gmail.com>
Date: Mon, 22 Aug 2011 16:12:41 +1200
From: CJ <cjpostor@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: javier Martin <javier.martin@vista-silicon.com>,
	Koen Kooi <koen@beagleboard.org>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	linux-media@vger.kernel.org, mch_kot@yahoo.com.cn
Subject: Re: [beagleboard] Re: [PATCH v7 1/2] Add driver for Aptina (Micron)
 mt9p031 sensor.
References: <1307014603-22944-1-git-send-email-javier.martin@vista-silicon.com> <BANLkTinqZ5xbTG=h+64rxVui=kXjjtehig@mail.gmail.com> <4E4DC6C3.1000800@gmail.com> <201108191212.49729.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108191212.49729.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 19/08/11 22:12, Laurent Pinchart wrote:
>> I am trying to get the mt9p031 working from nand with a ubifs file
>> system and I am having a few problems.
>>
>> /dev/media0 is not present unless I run:
>> #mknod /dev/media0 c 251 0
>> #chown root:video /dev/media0
>>
>> #media-ctl -p
>> Enumerating entities
>> media_open: Unable to enumerate entities for device /dev/media0
>> (Inappropriate ioctl for device)
>>
>> With the same rig/files it works fine running from EXT4 on an SD card.
>> Any idea why this does not work on nand with ubifs?
> Is the OMAP3 ISP driver loaded ? Has it probed the device successfully ? Check
> the kernel log for OMAP3 ISP-related messages.

Here is the version running from SD card:
# dmesg | grep isp
[    0.265502] omap-iommu omap-iommu.0: isp registered
[    2.986541] omap3isp omap3isp: Revision 2.0 found
[    2.991577] omap-iommu omap-iommu.0: isp: version 1.1
[    2.997406] omap3isp omap3isp: hist: DMA channel = 0
[    3.006256] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 
21600000 Hz
[    3.011932] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz

 From NAND using UBIFS:
# dmesg | grep isp
[    3.457061] omap3isp omap3isp: Revision 2.0 found
[    3.462036] omap-iommu omap-iommu.0: isp: version 1.1
[    3.467620] omap3isp omap3isp: hist: DMA channel = 0
[    3.472564] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 
21600000 Hz
[    3.478027] omap3isp omap3isp: isp_set_xclk(): cam_xclka set to 0 Hz

Seems to be missing:
omap-iommu omap-iommu.0: isp registered

Is that the issue? Why would this not work when running from NAND?

Cheers,
Chris

