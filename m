Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:58166 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932842AbZLGUOl (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Dec 2009 15:14:41 -0500
Message-ID: <4B1D6233.1040704@ridgerun.com>
Date: Mon, 07 Dec 2009 14:14:43 -0600
From: Santiago Nunez-Corrales <snunez@ridgerun.com>
Reply-To: santiago.nunez@ridgerun.com
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>
References: <4B13E9EB.8020309@ridgerun.com>
In-Reply-To: <4B13E9EB.8020309@ridgerun.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/4 v11] Support for TVP7002 in DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,


Hi. Have you had a chance to look at this version of the driver?

Regards,


Santiago.

Santiago Nunez-Corrales wrote:
> This series of patches provide support for the TVP7002 decoder in DM365.
>
> Support includes:
>
> * Inclusion of the chip in v4l2 definitions
> * Definition of TVP7002 specific data structures
> * Kconfig and Makefile support
>
> This series corrects many issued pointed out by Snehaprabha Narnakaje,
> Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves
> testing problems.  Tested on DM365 TI EVM with resolutions 720p,
> 1080i@60, 576P and 480P with video capture application and video
> output in 480P, 576P, 720P and 1080I. This driver depends upon
> board-dm365-evm.c and vpfe_capture.c to be ready for complete
> integration. Uses the new V4L2 DV API sent by Muralidharan Karicheri.
> Removed shadow register values. Removed unnecesary power down and up
> of the device (tests work fine). Improved readability.
>
>


-- 
Santiago Nunez-Corrales, Eng.
RidgeRun Engineering, LLC

Guayabos, Curridabat
San Jose, Costa Rica
+(506) 2271 1487
+(506) 8313 0536
http://www.ridgerun.com


