Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s7.bay0.hotmail.com ([65.54.190.82]:58860 "EHLO
	bay0-omc2-s7.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755316AbaEGL0j convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 7 May 2014 07:26:39 -0400
Message-ID: <BAY176-W38EDAC885E5441BBA2E0B2A94E0@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
Date: Wed, 7 May 2014 16:56:38 +0530
In-Reply-To: <536A0709.5090605@xs4all.nl>
References: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>,<536A0709.5090605@xs4all.nl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans

> Hmm, I always wondered when this would happen.

:)


> In theory we could make the number of maximum frames driver specific, but
> it would be more trouble than it's worth at the moment IMHO.

You mean to say adding a new field in struct vb2_queue.

Hmm, I will nod yes, because, the requirement for me is no more than 64.


> Which driver are you using? Is it something that you or someone else is
> likely to upstream to the linux kernel?
It's again TSMUXER. There are new data types defined, and some other stuff.

I cannot commit on this, however, I am currently seeing this driver.


Regards,

Divneil 		 	   		  