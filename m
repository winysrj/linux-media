Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:52261 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753983AbbETSe1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2015 14:34:27 -0400
Message-ID: <555CD3AB.7010103@xs4all.nl>
Date: Wed, 20 May 2015 20:34:19 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Patrice Levesque <video4linux.wayne@ptaff.ca>
Subject: Re: ATI TV Wonder regression since at least 3.19.6
References: <20150511161203.GG3206@ptaff.ca> <55519647.5010007@xs4all.nl> <20150514125607.GA3303@ptaff.ca> <5554C7BB.3070300@xs4all.nl> <20150515151218.GA5466@ptaff.ca>
In-Reply-To: <20150515151218.GA5466@ptaff.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/15/2015 05:12 PM, Patrice Levesque wrote:
> 
> Hi Hans,
> 
> 
>>> Function isn't used; when compiling I get:
>> That makes no sense. This function is most definitely used.
> 
> Idiot guy here did not follow simple instructions and didn't patch the
> right kernel source.  He just did, and function is used.
> 
> 
>> Did you start a capturing video first before running dmesg? I want to
>> see if capturing video will generate messages in dmesg.
> 
> Sending you again my (truncated) dmesg, but here's the annotated salient bit:
> 
> Starting video capture first time:
> [Fri May 15 11:01:43 2015] restart_video_queue
> [Fri May 15 11:01:44 2015] restart_video_queue
> [Fri May 15 11:01:55 2015] restart_video_queue
> [Fri May 15 11:01:56 2015] restart_video_queue
> [Fri May 15 11:01:56 2015] restart_video_queue
> [Fri May 15 11:02:00 2015] restart_video_queue
> [Fri May 15 11:02:05 2015] restart_video_queue
> [Fri May 15 11:02:06 2015] restart_video_queue
> [Fri May 15 11:02:06 2015] restart_video_queue
> [Fri May 15 11:02:06 2015] restart_video_queue
> [Fri May 15 11:02:07 2015] restart_video_queue
> [Fri May 15 11:02:07 2015] restart_video_queue
> [Fri May 15 11:02:07 2015] restart_video_queue
> [Fri May 15 11:02:09 2015] restart_video_queue
> Stopping video capture:
> [Fri May 15 11:03:26 2015] restart_video_queue
> Re-Starting video capture:
> [Fri May 15 11:03:40 2015] restart_video_queue
> Stopping video capture:
> [Fri May 15 11:04:18 2015] restart_video_queue
> 
> Changing channels didn't provoke restart_video_queue events.

FYI: I've bought this card on ebay and I am waiting for it to arrive.
Hopefully I can reproduce it and then I'll fix it. It's a fair bit of
work, unfortunately.

The fact that this function is called means that the DMA stalls every
so often, and I'd like to know why that happens.

Regards,

	Hans
