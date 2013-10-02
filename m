Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23128 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab3JBUQh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 2 Oct 2013 16:16:37 -0400
Message-ID: <524C80C3.8030306@linux.intel.com>
Date: Wed, 02 Oct 2013 23:23:31 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, hverkuil@xs4all.nl,
	teemux.tuominen@intel.com
Subject: Re: [RFC v2 4/4] v4l: events: Don't sleep in dequeue if none are
 subscribed
References: <1380721516-488-1-git-send-email-sakari.ailus@linux.intel.com> <1380721516-488-5-git-send-email-sakari.ailus@linux.intel.com> <2284638.0TjbNMnX7g@avalon>
In-Reply-To: <2284638.0TjbNMnX7g@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Laurent Pinchart wrote:
> Hi Sakari,
>
> On Wednesday 02 October 2013 16:45:16 Sakari Ailus wrote:
>> Dequeueing events was is entirely possible even if none are subscribed,
>
> was or is ? :-)

Was. :-) I'll fix that.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
