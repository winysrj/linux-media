Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:47036 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753937AbaGDHsG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 4 Jul 2014 03:48:06 -0400
Message-ID: <53B65C2E.9040503@xs4all.nl>
Date: Fri, 04 Jul 2014 09:47:58 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Divneil Wadhawan <divneil@outlook.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: vb2_reqbufs() is not allowing more than VIDEO_MAX_FRAME
References: <BAY176-W18F88DAF5A1C8B5194F30DA94E0@phx.gbl>,<536A0709.5090605@xs4all.nl>,<BAY176-W38EDAC885E5441BBA2E0B2A94E0@phx.gbl>,<536A1A45.6080201@xs4all.nl> <BAY176-W960662BE81D5920B94F97A9350@phx.gbl>
In-Reply-To: <BAY176-W960662BE81D5920B94F97A9350@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 05/12/2014 01:38 PM, Divneil Wadhawan wrote:
> Hi Hans,
>  
> Please find attached the patch. I hope its okay.
> I have only touched filed which were vb2 based in my understanding.
>  
> Yeah! I was referring to the define as it's the easier way and also fulfilling my use case.
> However, I am looking forward for queue->depth kind of approach where driver can specify its own choice for max buffers.
> 
> Regards,
> Divneil
> PS: I was on travel, hence the delay.


Sorry for the delay, I missed your patch.

It looks good, but you need to update a few more files:

include/media/davinci/vpfe_capture.h
drivers/media/platform/vivi-core.c
drivers/media/pci/saa7134/*

Regards,

	Hans
