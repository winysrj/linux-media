Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53942 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330Ab1GOOop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2011 10:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1107151023070.1866-100000@iolanthe.rowland.org>
References: <CACVXFVM=P7dongW660zmcSdapyqYz3Yr0R4DUGbQtQEKUG_tcw@mail.gmail.com>
	<Pine.LNX.4.44L0.1107151023070.1866-100000@iolanthe.rowland.org>
Date: Fri, 15 Jul 2011 22:44:44 +0800
Message-ID: <CACVXFVPHfskUCxhznpATknNxokmL5hft-b+KoxWiMzprVmuJ4w@mail.gmail.com>
Subject: Re: [PATCH] uvcvideo: add fix suspend/resume quirk for Microdia camera
From: Ming Lei <tom.leiming@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Ming Lei <ming.lei@canonical.com>, linux-media@vger.kernel.org,
	linux-usb@vger.kernel.org, Jeremy Kerr <jeremy.kerr@canonical.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On Fri, Jul 15, 2011 at 10:27 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

> This is fine with me.  However, it is strange that the Set-Interface
> request is necessary.  After being reset, the device should
> automatically be in altsetting 0 for all interfaces.

For uvc devices, seems it is not strange, see uvc_video_init(), which
is called in .probe path and executes Set-Interface 0 first, then starts
to get/set video control.

thanks,
-- 
Ming Lei
