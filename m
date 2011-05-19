Return-path: <mchehab@pedra>
Received: from mail.meprolight.com ([194.90.149.17]:34018 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756558Ab1ESMwF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 08:52:05 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Alex Gershgorin <alexg@meprolight.com>,
	"'linux-media@vger.kernel.org'" <linux-media@vger.kernel.org>
CC: "'sakari.ailus@iki.fi'" <sakari.ailus@iki.fi>,
	"'laurent.pinchart@ideasonboard.com'"
	<laurent.pinchart@ideasonboard.com>,
	"'agersh@rambler.ru'" <agersh@rambler.ru>
Date: Thu, 19 May 2011 15:51:16 +0300
Subject: RE: FW: OMAP 3 ISP
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D38@MEP-EXCH.meprolight.com>
In-Reply-To: <4875438356E7CA4A8F2145FCD3E61C0B15D3557D37@MEP-EXCH.meprolight.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


Thanks Laurent,

My video source is not the video camera and performs many other functions.
For this purpose I have RS232 port.
As for the video, it runs continuously and is not subject to control except for the power supply.

Regards,
Alex Gershgorin


Can the video source be controlled at all, or is it always running?
If it can be controlled, how do you control it?

Regards,
Laurent Pinchart

-----Original Message-----
From: Alex Gershgorin
Sent: Thursday, May 19, 2011 2:36 PM
To: 'linux-media@vger.kernel.org'
Cc: 'sakari.ailus@iki.fi'; 'laurent.pinchart@ideasonboard.com'; 'agersh@rambler.ru'
Subject: FW: FW: OMAP 3 ISP

Thanks for your quick response :-)

Unfortunately, my video source has no additional interfaces.

Best Regards,
Alex Gershgorin
Embedded Software Engineer
E-mail: alexg@meprolight.com

-----Original Message-----
From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
Sent: Thursday, May 19, 2011 2:09 PM
To: Alex Gershgorin
Cc: 'agersh@rambler.ru'
Subject: Re: FW: OMAP 3 ISP

On Thu, May 19, 2011 at 12:08:41PM +0300, Alex Gershgorin wrote:
>
>
>
>
>  Hi Sakari,

Hi Alex,

>
>
> We wish to develop video device and use omap3530.
>
> Our video source has an 8-bit raw data, vertical and horizontal signals,
> and has no i2c bus.
>
> I was briefly acquainted with Linux OMAP 3 Image Signal Processor (ISP)
> and found, that
>
> to register video device I need to provide I2C subdevs board information
> array, but my device does not have i2c information.
>
> I'm asking for your support on this issue.

Does your image data source have some other kind of control interface,
possibly SPI?

Please reply to linux-media@vger.kernel.org and cc myself and
laurent.pinchart@ideasonboard.com.

Regards,

--
Sakari Ailus
sakari dot ailus at iki dot fi


__________ Information from ESET NOD32 Antivirus, version of virus signature database 6134 (20110519) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



__________ Information from ESET NOD32 Antivirus, version of virus signature database 6134 (20110519) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com



__________ Information from ESET NOD32 Antivirus, version of virus signature database 6134 (20110519) __________

The message was checked by ESET NOD32 Antivirus.

http://www.eset.com

