Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.navvo.net ([74.208.67.6]:52701 "EHLO mail.navvo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672AbZKEQqi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Nov 2009 11:46:38 -0500
Message-ID: <4AF30178.7040008@ridgerun.com>
Date: Thu, 05 Nov 2009 10:46:48 -0600
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
References: <4AF1B89C.5000108@ridgerun.com> <200911051721.58407.hverkuil@xs4all.nl>
In-Reply-To: <200911051721.58407.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/4 v6] Support for TVP7002 in DM365
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Odd, I sent them all. Anyways, I just have re-sent them. Let me know if 
they arrive.

Regards,

Hans Verkuil wrote:
> On Wednesday 04 November 2009 18:23:40 Santiago Nunez-Corrales wrote:
>   
>> This series of patches provide support for the TVP7002 decoder in DM365.
>>
>> Support includes:
>>
>> * Inclusion of the chip in v4l2 definitions
>> * Definition of TVP7002 specific data structures
>> * Kconfig and Makefile support
>>
>> This series corrects many issued pointed out by Snehaprabha Narnakaje,
>> Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves
>> testing problems.  Tested on DM365 TI EVM with resolutions 720p,
>> 1080i@60, 576P and 480P with video capture application and video
>> output in 480P, 576P, 720P and 1080I. This driver depends upon 
>> board-dm365-evm.c and vpfe_capture.c to be ready for complete 
>> integration. Uses the new V4L2 DV API sent by Muralidharan Karicheri.
>>
>>
>>     
>
> Erm, where is the rest of the series? :-)
>
> Regards,
>
> 	Hans
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


