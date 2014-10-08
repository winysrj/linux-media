Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:57211 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755174AbaJHKWj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 06:22:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Subject: Re: Intermittent Logitech C510 problems (with kernel OOPSes)
Date: Wed, 08 Oct 2014 13:22:43 +0300
Message-ID: <4947599.bpC5FBQtce@avalon>
In-Reply-To: <af04e00ec71b9b27b3e30a61f3ca608c@lycos.com>
References: <af04e00ec71b9b27b3e30a61f3ca608c@lycos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Artem,

On Tuesday 07 October 2014 11:48:48 Artem S. Tashkinov wrote:
> Hi,
> 
> I posted a bug report almost a year ago and since it's got zero
> attention so far I'm writing to this mailing list.

I've CC'ed the linux-media mailing list, as it wasn't in the recipients list 
of your e-mail.

> My problem is that video capturing doesn't work on Logitech C510 webcam
> in some cases.
> 
> Mind that audio input always works.
> 
> Video capturing is guaranteed not to work after I reboot from Windows 7.
> 
> In rare cases it doesn't work when I cold boot straight into Linux.
> 
> When I try to capture - either there's no signal and capturing fails to
> initiate or I get a black screen (a LED on the webcam doesn't turn on in
> both cases).
> 
> If I rmmod ehci_hcd and then modprobe ehci_hcd and uvcvideo, then
> everything starts working again.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=67551

The kernel log warning message is caused by an issue I'm aware of. I'll try to 
fix it ASAP, but due to attending conferences next week I might get a bit 
delayed.

-- 
Regards,

Laurent Pinchart
