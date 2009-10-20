Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:35883 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbZJTQjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 12:39:07 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: "Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Date: Tue, 20 Oct 2009 11:39:01 -0500
Subject: RE: [PATCH 0/6 v5] Support for TVP7002 in DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE40155609EC2@dlee06.ent.ti.com>
References: <4AD734B2.8050601@ridgerun.com>
In-Reply-To: <4AD734B2.8050601@ridgerun.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Santiago,

When you are submitting the next set of patches, please include only TVP7002 driver and Kconfig/Makefile changes for TVP7002. The vpfe capture driver in the upstream tree is not up to date with the Arago tree that we use for development. So as such your patches for board/platform code, vpfe capture etc may not work in upstream. I hope to update the upstream tree in few weeks from now. Also your tvp7002 patch needs to use the video timings APIs that I am currently developing. I plan to send a patch for this in a day or two for review to this mailing list.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

>-----Original Message-----
>From: Santiago Nunez-Corrales [mailto:snunez@ridgerun.com]
>Sent: Thursday, October 15, 2009 10:42 AM
>To: davinci-linux-open-source@linux.davincidsp.com
>Cc: Narnakaje, Snehaprabha; Karicheri, Muralidharan; Diego Dompe;
>todd.fischer@ridgerun.com; Grosen, Mark; Linux Media Mailing List
>Subject: [PATCH 0/6 v5] Support for TVP7002 in DM365
>
>This series of patches provide support for the TVP7002 decoder in DM365.
>Support
>includes:
>
>* Inclusion of the chip in v4l2 definitions
>* Definition in board specific data structures
>* Linking within the VPFE architecture
>* Definition of TVP7002 specific data structures
>* Kconfig and Makefile support
>
>The v5 series corrects many issued pointed out by Snehaprabha Narnakaje,
>Muralidharan Karicheri, Vaibhav Hiremath and Hans Verkuil and solves
>testing
> problems.  Tested on DM365 TI EVM with resolutions 720p, 1080i@60, 576P
>and
> 480P.
>
>--
>Santiago Nunez-Corrales, Eng.
>RidgeRun Engineering, LLC
>
>Guayabos, Curridabat
>San Jose, Costa Rica
>+(506) 2271 1487
>+(506) 8313 0536
>http://www.ridgerun.com
>

