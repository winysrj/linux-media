Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:41274 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161018AbbEOMMI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 08:12:08 -0400
Message-ID: <5555E28A.2050207@xs4all.nl>
Date: Fri, 15 May 2015 14:11:54 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] DocBook/media: add missing entry for V4L2_PIX_FMT_Y16_BE
References: <1431685897-11153-1-git-send-email-hverkuil@xs4all.nl> <1431685897-11153-2-git-send-email-hverkuil@xs4all.nl> <CAPybu_1G7kD-O_xNE=QcqVjftDFsPVmNh-uhnHazTPgnSv3FVg@mail.gmail.com>
In-Reply-To: <CAPybu_1G7kD-O_xNE=QcqVjftDFsPVmNh-uhnHazTPgnSv3FVg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

You are completely right. I confused bits and bytes :-(

I've posted a v2.

Thanks!

	Hans

On 05/15/2015 02:02 PM, Ricardo Ribalda Delgado wrote:
> Hello Hans
> 
> My bad sorry, I should have send this patch myself.
> 
> Shouldn't it be? :
> 
> 00 high
> 00 low
> 01 high
> 01 low
> 02 high
> 02 low
> 03 high
> 03 low
> 
> 10 high
> 10 low
> 11 high
> 11 low
> 12 high
> 12 low
> 13 high
> 13 low
> 
> 20 high
> 20 low
> 21 high
> 21 low
> 22 high
> 22 low
> 23 high
> 23 low
> 
> 30 high
> 30 low
> 31 high
> 31 low
> 32 high
> 32 low
> 33 high
> 33 low
> 
> 
> Thanks
> 
> 
> ps: I am sending the patch for libv4lconvert right away, and the patch
> for qv4l during next week (I havent dont gl before)
> 

