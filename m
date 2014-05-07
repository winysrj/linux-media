Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1564 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932368AbaEGLeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 May 2014 07:34:36 -0400
Message-ID: <536A1A45.6080201@xs4all.nl>
Date: Wed, 07 May 2014 13:34:29 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
References: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>,<536A0709.5090605@xs4all.nl> <BAY176-W38EDAC885E5441BBA2E0B2A94E0@phx.gbl>
In-Reply-To: <BAY176-W38EDAC885E5441BBA2E0B2A94E0@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/07/14 13:26, Divneil Wadhawan wrote:
> Hi Hans
> 
>> Hmm, I always wondered when this would happen.
> 
> :)
> 
> 
>> In theory we could make the number of maximum frames driver specific, but
>> it would be more trouble than it's worth at the moment IMHO.
> 
> You mean to say adding a new field in struct vb2_queue.

No, just add a VB2_MAX_FRAME define and use that everywhere in vb2 and any
driver depending on vb2 instead of VIDEO_MAX_FRAME.

The VIDEO_MAX_FRAME define is used for vb2 internal array sizes, and those
need to be increased. So replacing VIDEO_MAX_FRAME by VB2_MAX_FRAME is the
easiest approach.

Regards,

	Hans

> Hmm, I will nod yes, because, the requirement for me is no more than 64.
> 
> 
>> Which driver are you using? Is it something that you or someone else is
>> likely to upstream to the linux kernel?
> It's again TSMUXER. There are new data types defined, and some other stuff.
> 
> I cannot commit on this, however, I am currently seeing this driver.
> 
> 
> Regards,
> 
> Divneil 		 	   		  
> 

