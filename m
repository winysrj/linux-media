Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:33577 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760464AbZDAHgQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Apr 2009 03:36:16 -0400
Date: Wed, 1 Apr 2009 09:35:58 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Alan Nisota <alannisota@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove support for Genpix-CW3K (damages hardware)
In-Reply-To: <49D2338C.7040703@gmail.com>
Message-ID: <alpine.LRH.1.10.0904010934590.21921@pub4.ifh.de>
References: <49D2338C.7040703@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Alan,

On Tue, 31 Mar 2009, Alan Nisota wrote:

> I have been informed by the manufacturer that the patch currently in the v4l 
> tree to support the Genpix-CW3K version of the hardware will actually damage 
> the firmware on recent units.  As he seems to not want this hardware 
> supported in Linux, and I do not know how to detect the difference between 
> affected and not-affected units, I am requesting the immediate removal of 
> support for this device.  This patch removes a portion of the changeset 
> dce7e08ed2b1 applied 2007-08-18 relating to this specific device.
>
> Signed off by: Alan Nisota <anisota@gmail.com>

Don't you think it is enough to put a Kconfig option to activate the 
USB-IDs (by default: off) rather than throwing everything away?

Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
