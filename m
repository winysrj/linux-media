Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:45471 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964892AbbHKOB5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Aug 2015 10:01:57 -0400
Message-ID: <55C9FFC7.8030308@xs4all.nl>
Date: Tue, 11 Aug 2015 15:59:35 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Junghak Sung <jh1009.sung@samsung.com>,
	linux-media@vger.kernel.org, mchehab@osg.samsung.com,
	sakari.ailus@iki.fi, pawel@osciak.com, inki.dae@samsung.com,
	sw0312.kim@samsung.com, nenggun.kim@samsung.com,
	sangbae90.lee@samsung.com, rany.kwon@samsung.com
Subject: Re: [RFC PATCH v2 4/5] media: videobuf2: Define vb2_buf_type and
 vb2_memory
References: <1438332277-6542-1-git-send-email-jh1009.sung@samsung.com> <1438332277-6542-5-git-send-email-jh1009.sung@samsung.com> <55C85F34.7040603@xs4all.nl> <30625903.5XtBkRR4hc@avalon>
In-Reply-To: <30625903.5XtBkRR4hc@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/11/15 15:56, Laurent Pinchart wrote:
> 
> Hijacking this e-mail thread a bit, would it make sense for the new vb2-core 
> to support different memory allocation for different planes ? I'm foreseeing 
> use cases for buffers that bundle image data with meta-data, where image data 
> should be captured to a dma-buf imported buffer, but meta-data doesn't need to 
> be shared. In that case it wouldn't be easy for userspace to find a dma-buf 
> provider for the meta-data buffers in order to import all planes. Being able 
> to use dma-buf import for the image plane(s) and mmap for the meta-data plane 
> would be easier.

Yes, that would make sense, but I'd postpone that until someone actually needs
it.

The biggest hurdle would be how to adapt the V4L2 API to this, and not the actual
vb2 core code.

Regards,

	Hans
