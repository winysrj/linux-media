Return-path: <linux-media-owner@vger.kernel.org>
Received: from znsun1.ifh.de ([141.34.1.16]:45683 "EHLO znsun1.ifh.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbZETIxJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 20 May 2009 04:53:09 -0400
Date: Wed, 20 May 2009 10:52:59 +0200 (CEST)
From: Patrick Boettcher <patrick.boettcher@desy.de>
To: Alan Nisota <alannisota@gmail.com>
cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] Remove support for Genpix-CW3K (damages hardware)
In-Reply-To: <49D2338C.7040703@gmail.com>
Message-ID: <alpine.LRH.1.10.0905201051290.6762@pub3.ifh.de>
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


Finally I found the time to work on your patch. I adapted it to not remove 
the code, but to put it under comments and #if 0's .

Like that we protect "normal" users and advanced users need to do some 
efforts before getting in danger.

I hope it is OK with you.

regards,
Patrick.

--
   Mail: patrick.boettcher@desy.de
   WWW:  http://www.wi-bw.tfh-wildau.de/~pboettch/
