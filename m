Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:3669 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847AbZHOMJx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 15 Aug 2009 08:09:53 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: m-karicheri2@ti.com
Subject: Re: [PATCH v1 - 1/5] DaVinci - restructuring code to support vpif capture driver
Date: Sat, 15 Aug 2009 14:09:43 +0200
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	khilman@deeprootsystems.com
References: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
In-Reply-To: <1250283702-5582-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908151409.44219.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Friday 14 August 2009 23:01:41 m-karicheri2@ti.com wrote:
> From: Muralidharan Karicheri <m-karicheri2@ti.com>
> 
> This patch makes the following changes:-
> 	1) Modify vpif_subdev_info to add board_info, routing information
> 	   and vpif interface configuration. Remove addr since it is
> 	   part of board_info
> 	 
> 	2) Add code to setup channel mode and input decoder path for
> 	   vpif capture driver
> 
> Also incorporated comments against version v0 of the patch series and
> added a spinlock to protect writes to common registers

A quick question: against which git tree are these arch changes applied?
I've lost track of that :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
