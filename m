Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3276 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbaHDLGu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Aug 2014 07:06:50 -0400
Message-ID: <53DF693E.9050500@xs4all.nl>
Date: Mon, 04 Aug 2014 13:06:38 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH for v3.17 2/2] vb2: fix vb2 state check when start_streaming
 fails
References: <1407148032-41607-1-git-send-email-hverkuil@xs4all.nl> <1407148032-41607-3-git-send-email-hverkuil@xs4all.nl> <4228716.VErhQhH3PE@avalon>
In-Reply-To: <4228716.VErhQhH3PE@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/04/2014 12:44 PM, Laurent Pinchart wrote:
> Hi Hans,
> 
> Thank you for the patch.
> 
> On Monday 04 August 2014 12:27:12 Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Commit bd994ddb2a12a3ff48cd549ec82cdceaea9614df (vb2: Fix stream start and
>> buffer completion race) broke the buffer state check in vb2_buffer_done.
>>
>> So accept all three possible states there since I can no longer tell the
>> difference between vb2_buffer_done called from start_streaming or from
>> elsewhere.
>>
>> Instead add a WARN_ON at the end of start_streaming that will check whether
>> any buffers were added to the done list, since that implies that the wrong
>> state was used as well.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Cc: stable@vger.kernel.org      # for v3.15 and up
>> Cc: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Given that I've introduced a few vb2 bugs I hope my review still has some 
> value :-)

Since I reviewed your original patch as well, I'm not going to throw stones at
you :-)

Regards,

	Hans
