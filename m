Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:54658 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756498AbcCRPBP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2016 11:01:15 -0400
Subject: Re: [RFC PATCH 0/3] [media] tvp515p: Proposal for MC input connector
 support
To: linux-media@vger.kernel.org
References: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Shuah Khan <shuahkh@osg.samsung.com>
From: Javier Martinez Canillas <javier@osg.samsung.com>
Message-ID: <56EC1832.6080602@osg.samsung.com>
Date: Fri, 18 Mar 2016 12:01:06 -0300
MIME-Version: 1.0
In-Reply-To: <1457550566-5465-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 03/09/2016 04:09 PM, Javier Martinez Canillas wrote:
> 
> I was waiting for the MC input connector support discussion to settle before
> attempting to propose another patch series for the tvp5150 video decoder but
> IIUC you are going to continue the discussion at ELC so I'm posting a series
> that I believe is aligned with the latest conversations.
> 
> This is of course a RFC and not meant to be merged but just to start looking
> how the DT binding using OF graph for connectors could look like and to see
> an implementation that uses a PAD (and thus link) per electrical signal (the
> 1:1 model mentioned by Laurent).
>

Any comments about this series?
 
Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
