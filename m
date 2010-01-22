Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:54270 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0AVOhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jan 2010 09:37:10 -0500
Message-ID: <4B59B7C0.1020104@maxwell.research.nokia.com>
Date: Fri, 22 Jan 2010 16:35:44 +0200
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: "Aguirre, Sergio" <saaguirre@ti.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: gitorious.org/omap3camera: Falied attempt to migrate sensor driver
 to Zoom2/3 platform
References: <A24693684029E5489D1D202277BE8944517F0987@dlee02.ent.ti.com> <201001221246.24330.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201001221246.24330.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sergio,
> 
> On Friday 22 January 2010 10:49:17 Aguirre, Sergio wrote:
>> Laurent, Sakari,
>>
>> While I was trying to adapt my Zoom2/3 sensor drivers into latest 'devel'
>>  branch with latest commit:
>>
>> commit 2e7d09ec5e09ee80462a611c9958e99866ee337c
>> Author: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
>> Date:   Wed Jan 20 13:49:31 2010 +0100
>>
>>     omap3isp: Work around sg_alloc_table BUG_ON
>>
>>     Work in progress
>>
>>     Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> That last patch shouldn't have been applied to the linux-omap tree. The patch 
> itself is correct, but the commit message isn't. I'll check that with Sakari.

Killed the commit...

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
