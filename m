Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:4605 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206AbZLRTBN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Dec 2009 14:01:13 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: santiago.nunez@ridgerun.com
Subject: Re: [PATCH 0/4 v13] Support for TVP7002 in DM365
Date: Fri, 18 Dec 2009 20:00:59 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"Grosen, Mark" <mgrosen@ti.com>,
	Diego Dompe <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>
References: <4B2BB6BB.2040701@ridgerun.com>
In-Reply-To: <4B2BB6BB.2040701@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912182000.59933.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 18 December 2009 18:07:07 Santiago Nunez-Corrales wrote:
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
> of the device (tests work fine). Improved readability. Uses Murali's
> preset helper function. Last issues resolved.
> 
> 

Looks good! Unless someone else finds more issues I'm going to make a tree
with this driver in it and issue a pull request early next week.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
