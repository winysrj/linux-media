Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab1HARjP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Aug 2011 13:39:15 -0400
Message-ID: <4E36E4B9.80701@redhat.com>
Date: Mon, 01 Aug 2011 14:39:05 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Ming Lei <tom.leiming@gmail.com>, linux-media@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH] uvcvideo: add SetInterface(0) in .reset_resume handler
References: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com> <201107311738.58462.laurent.pinchart@ideasonboard.com> <CACVXFVMJvZqYH3eS7LH_jgewL40KK74wrSX_-FhqLmyDJmPEGg@mail.gmail.com> <201108011326.31648.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201108011326.31648.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 01-08-2011 08:26, Laurent Pinchart escreveu:
> Hi Ming,
> 
> On Monday 01 August 2011 02:56:59 Ming Lei wrote:
>> On Sun, Jul 31, 2011 at 11:38 PM, Laurent Pinchart wrote:
>>> Hi Ming,
>>>
>>> Thanks for the patch. I've queued it for v3.2 with a small modification
>>> (the usb_set_interface() call has been moved to uvc_video.c).
>>
>> Thanks for queuing it.
>>
>> Considered it is a fix patch, could you queue it for 3.1 -rcX as fix patch?
>> But anyway, it is up to you, :-)
> 
> It's not completely up to me :-) This patch falls in the "features that never 
> worked" category. I've heard that Linus didn't want such non-regression fixes 
> during the 3.0-rc phase. Mauro, is it still true for v3.1-rc ? Can I push this 
> patch for 3.1, or does it need to wait until 3.2 ?

Theoretically, we're still with the open window. Well, send it to me. It is
a fix. I'll likely queue it to 3.1 and send on a next pull request, together with
a few other fixes probably on the next weekend.

Thanks,
Mauro
