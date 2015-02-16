Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:56610 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899AbbBPOjw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Feb 2015 09:39:52 -0500
Received: by mail-qa0-f42.google.com with SMTP id w8so21970860qac.1
        for <linux-media@vger.kernel.org>; Mon, 16 Feb 2015 06:39:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150216085925.3b52a558@recife.lan>
References: <cover.1423867976.git.mchehab@osg.samsung.com>
	<5c8a3752af88ba4c349d9d2416cad937f96a0423.1423867976.git.mchehab@osg.samsung.com>
	<54E1B3F0.7060807@xs4all.nl>
	<20150216085925.3b52a558@recife.lan>
Date: Mon, 16 Feb 2015 09:39:51 -0500
Message-ID: <CAGoCfiy+te9GRt=xPrHmUe+ckeO2X0u3XmJC77BSQG6VJ_aEFw@mail.gmail.com>
Subject: Re: [PATCHv4 15/25] [media] tuner-core: properly initialize media
 controller subdev
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Prabhakar Lad <prabhakar.csengg@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> Except for PVR-500, I can't remember any case where the same tuner is used
> more than once.
>
> There is the case of a device with two tuners, one for TV and another one
> for FM. Yet, on such case, the name of the FM tuner will be different,
> anyway. So, I don't think this is a current issue, but if the name should
> be unique, then we need to properly document it.

Perhaps I've misunderstood the comment, but HVR-2200/2250 and numerous
dib0700 designs are dual DVB tuners.  Neither are like the PVR-500 in
that they are a single entity with two tuners (as opposed to the
PVR-500 which is two PCI devices which happen to be on the same PCB).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
