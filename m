Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:47793 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751915AbbLXMyM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 24 Dec 2015 07:54:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 24 Dec 2015 13:54:11 +0100
From: hverkuil <hverkuil@xs4all.nl>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Aviv Greenberg <avivgr@gmail.com>,
	linux-media-owner@vger.kernel.org
Subject: Re: per-frame camera metadata (again)
In-Reply-To: <4268557.IA99RCLRfS@avalon>
References: <Pine.LNX.4.64.1512160901460.24913@axis700.grange>
 <20165691.OGa4CkqcQt@avalon> <7eb32a870441220fc4f6738d03a96a36@xs4all.nl>
 <4268557.IA99RCLRfS@avalon>
Message-ID: <86a64428cff3a4056742bb169de13e70@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2015-12-24 12:29, Laurent Pinchart wrote:
>> Control classes are not deprecated, only the use of the control_class
>> field in struct v4l2_ext_controls to limit the controls in the list to 
>> a
>> single control class is deprecated. That old limitation was from pre-
>> control-framework times to simplify driver design. With the creation 
>> of the
>> control framework that limitation is no longer needed.
> 
> Doesn't that effectively deprecated control classes ? We can certainly 
> group
> controls in categories for documentation purposes, but the control 
> class as an
> API concept is quite useless nowadays.

No it's not. It is meant to be used by GUIs to group controls into tab 
pages or
something similar. See qv4l2 or v4l2-ctl. It's very useful.

Regards,

     Hans
