Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:62590 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab0AICGE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 21:06:04 -0500
Received: by fxm25 with SMTP id 25so13165532fxm.21
        for <linux-media@vger.kernel.org>; Fri, 08 Jan 2010 18:06:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100109015521.GK2257@harvey.netwinder.org>
References: <20100108191459.GJ2257@harvey.netwinder.org>
	 <20100109015521.GK2257@harvey.netwinder.org>
Date: Fri, 8 Jan 2010 21:06:01 -0500
Message-ID: <829197381001081806i29b3898fn28de19a9d1beb61d@mail.gmail.com>
Subject: Re: cx23885 oops during loading, WinTV-HVR-1850 card -- SOLVED
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Ralph Siemsen <ralphs@netwinder.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jan 8, 2010 at 8:55 PM, Ralph Siemsen <ralphs@netwinder.org> wrote:
> Now the driver loads, and I follow it up with "modprobe tuner".
> Unfortunately, no luck yet using tvtime, it just reports:
> videoinput: No inputs available on video4linux2 device '/dev/video0'.
> But I suspect that is a different issue!

The cx23885 driver doesn't work with tvtime, due to bugs in the v4l
controls in the driver.  Michael Krufky has some patches but they need
some more work before they can go in the mainline.  Even if they were
committed though, there is currently no support for raw audio, so
tvtime would not be a good application to use for this device.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
