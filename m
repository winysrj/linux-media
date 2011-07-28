Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43608 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380Ab1G1CF2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Jul 2011 22:05:28 -0400
Received: by vxh35 with SMTP id 35so1591277vxh.19
        for <linux-media@vger.kernel.org>; Wed, 27 Jul 2011 19:05:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1107272227270.7435@axis700.grange>
References: <CAOy7-nMnE6_z4pAmw+Jc1riYSeCWwiNS2=_Ya==+7q5=bNrWuw@mail.gmail.com>
	<20110726194035.GF32629@valkosipuli.localdomain>
	<CAOy7-nNmeYy14Rm-NYBNqCoCkAs++rTUabiTZehWyBQ-k0M0og@mail.gmail.com>
	<Pine.LNX.4.64.1107272227270.7435@axis700.grange>
Date: Thu, 28 Jul 2011 10:05:27 +0800
Message-ID: <CAOy7-nNy9A8U4+zWmt7rtNc-rrVPqYVC37MuLFSb0zBkvPCtQA@mail.gmail.com>
Subject: Re: Parallel CMOS Image Sensor with UART Control Interface
From: James <angweiyang@gmail.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, michael.jones@matrix-vision.de,
	alexg@meprolight.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

>> We both have sensor that output CMOS H/V image and only have
>> UART/RS232 for control of the sensor operations via sending/reading
>> packet of bytes. i.e. AGC, contrast, brightness etc..
>>
>> Since the thread ended on 29-Jun, is there anymore update or information?
>
> Probably obvious, but just to have it mentioned in this thread, such UART
> driver should certainly be implemented as a line discipline.
>
> Thanks
> Guennadi

Do you have any working example that I can adapt as per your suggestion?

Thanks in adv.

-- 
Regards,
James
