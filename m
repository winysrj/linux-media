Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:46851 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JILiY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Oct 2012 07:38:24 -0400
Received: from eusync2.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MBM0053OJ0L6S70@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 12:38:45 +0100 (BST)
Received: from [106.116.147.32] by eusync2.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0MBM004QBIZXB9C0@eusync2.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Oct 2012 12:38:21 +0100 (BST)
Message-id: <50740CAC.2040009@samsung.com>
Date: Tue, 09 Oct 2012 13:38:20 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Jan Hoogenraad <jan-conceptronic@hoogenraad.net>,
	linux-media@vger.kernel.org, a.hajda@samsung.com,
	sakari.ailus@iki.fi, hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	sw0312.kim@samsung.com
Subject: Re: Media_build broken by [PATCH RFC v3 5/5] m5mols: Implement
 .get_frame_desc subdev callback
References: <1348674853-24596-1-git-send-email-s.nawrocki@samsung.com>
 <1348674853-24596-6-git-send-email-s.nawrocki@samsung.com>
 <50704D26.9020201@hoogenraad.net> <2290105.hTRlMPSUYP@avalon>
In-reply-to: <2290105.hTRlMPSUYP@avalon>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent

On 10/08/2012 10:42 PM, Laurent Pinchart wrote:
> Hi,
> 
> When did the {get,set}_frame_desc subdev operations reach mainline ? Last I 
> knew is that they were an RFC, and they're now suddenly in, without even one 
> ack from an embedded v4l developer :-S I'm not totally happy with that.

Sorry to hear now you have issues with those patches. I've sent a pull request
on last Wednesday [1], after 3 RFC versions of the whole change set. I've Cced
many people on these patches, including you and Sakari. I have addressed comments 
to some patches you raised and I felt you're generally OK or don't have 
objections (since there was no comments on some patches and I explicitly 
mentioned there I'd like to get them in v3.7). I'm sorry if it was otherwise.

The problem I'm trying to address with those patches have been there for us for
over _one year_ [1], making JPEG capture with s5p-fimc effectively unusable in
the mainline kernel.

We've decided extending struct v4l2_mbus_framefmt was not an option, since it
is exposed to user-space now. Also using controls turned out to not be helpful,
since multiple values need to be passed, where there are multiple logical
streams transmitted by e.g. CSI-2 transmitter in single video frame [2].

It seemed like there is a general agreement on LMML to use the frame 
descriptor callbacks instead. These callbacks are all in-kernel API and can
be changed any time. I'll be happy adapt the drivers to whatever sane changes
are proposed. I've stated in the commit description it's just an preliminary
form. And it at least let's us to move forward and carry on with more serious
problems.

I'll try to do better on letting people know, when sending things upstream
in future.

--

Regards,
Sylwester

[1] http://patchwork.linuxtv.org/patch/14875
[2] https://patchwork.kernel.org/patch/1365451
