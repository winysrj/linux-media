Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:28189 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZJPMq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 08:46:56 -0400
Message-ID: <4AD86ADF.2040107@maxwell.research.nokia.com>
Date: Fri, 16 Oct 2009 15:45:19 +0300
From: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Zutshi Vimarsh (Nokia-D-MSW/Helsinki)" <vimarsh.zutshi@nokia.com>,
	Ivan Ivanov <iivanov@mm-sol.com>,
	Cohen David Abraham <david.cohen@nokia.com>,
	Guru Raj <gururaj.nagendra@intel.com>
Subject: Re: [RFC] Video events, version 2
References: <4AD5CBD6.4030800@maxwell.research.nokia.com> <200910161024.13340.laurent.pinchart@ideasonboard.com> <4AD86854.8060803@maxwell.research.nokia.com> <200910161441.18415.laurent.pinchart@ideasonboard.com>
In-Reply-To: <200910161441.18415.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> That's not what I meant. The idea of a count field is to report the number of 
> events still pending after that one, type aside. If v4l2_event::count equals 0 
> the userspace application will know there is no need to call VIDIOC_G_EVENT 
> just to get a -EAGAIN. 

Thanks for the clarification.

Sounds good to me, I'll put this to the next version.

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
