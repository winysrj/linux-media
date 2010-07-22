Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0GVCtH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Jul 2010 22:49:07 -0400
Received: by iwn7 with SMTP id 7so7418540iwn.19
        for <linux-media@vger.kernel.org>; Wed, 21 Jul 2010 19:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1007211542550.16933@axis700.grange>
References: <AANLkTilMPncmtk5OC4pe2Mbi-3bTmp3dxZM2JB5p5u-o@mail.gmail.com>
	<Pine.LNX.4.64.1007211542550.16933@axis700.grange>
Date: Thu, 22 Jul 2010 10:49:06 +0800
Message-ID: <AANLkTikuCDityRQCb0GON-JC4cHCU7OOuT48Rbup-7Ap@mail.gmail.com>
Subject: Re: Is it feasible to add another driver for CCIC?
From: Jun Nie <niej0001@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2010/7/21 Guennadi Liakhovetski <g.liakhovetski@gmx.de>:
> On Wed, 21 Jul 2010, Jun Nie wrote:
>
>> Hi,
>>     I am working on CCIC camera controller driver and want to push it
>> into kernel. This CCIC IP is similar with IP of cafe_ccic, but with
>> lots of change: no I2C bus, embedded in SOC/no PCI, support both
>> parallel and CSI interface. So some register definition changes.
>>     I just want to confirm that a new driver for SOC CCIC is
>> acceptable for community.
>>     Thanks!
>
> Well, if there is a well defined common "core" of the both
> implementations, e.g., common register set (or at least most of them),
> then, I think, it would make sense to split the current cafe_ccic, extract
> that core and reuse it... It is always an interesting decision, whether
> two devices are similar enough or not.
>
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
>

    DVP parallel part registers are 90% same, about 40% same for all
registers with about 5% conflict. My main concern is that cafe_ccic
driver structure and application usage is much simple and have no DMA
chain while SOC CCIC should support soc_camera/DMA chain/user pointer.
So it will take much effort to share DVP settings, such as image size
and HSYNC_PO/VSYNC_PO, etc.
    Is there any existing drivers with such similar abstraction for
decision making reference?

Thanks
Jun
