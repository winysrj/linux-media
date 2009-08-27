Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.216.174]:44728 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbZH0UX7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 27 Aug 2009 16:23:59 -0400
Received: by pxi4 with SMTP id 4so1405746pxi.21
        for <linux-media@vger.kernel.org>; Thu, 27 Aug 2009 13:24:01 -0700 (PDT)
Date: Thu, 27 Aug 2009 13:17:52 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Peter Brouwer <pb.maillists@googlemail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Linux Input <linux-input@vger.kernel.org>
Subject: Re: [RFC] Infrared Keycode standardization
References: <20090827045710.2d8a7010@pedra.chehab.org> <4A96BD05.1080205@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A96BD05.1080205@googlemail.com>
Message-Id: <20090827205005.8F7AD526EC9@mailhub.coreip.homeip.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 27, 2009 at 06:06:13PM +0100, Peter Brouwer wrote:
> Mauro Carvalho Chehab wrote:
>
> Hi Mauro, All
>
> Would it be an alternative to let lirc do the mapping and just let the 
> driver pass the codes of the remote to the event port.

I don't think that blindly passing IR codes through input layer is a
good idea, for the same reason we don't do that for HID and PS/2
anymore - task of the kernel is to provide unified interface to the
hardware devices instead of letting userspace deal with the raw data
streams.

-- 
Dmitry
