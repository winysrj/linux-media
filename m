Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta5.srv.hcvlny.cv.net ([167.206.4.200]:48966 "EHLO
	mta5.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZI1QZj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Sep 2009 12:25:39 -0400
Received: from steven-toths-macbook-pro.local
 (ool-18bfe0d5.dyn.optonline.net [24.191.224.213]) by mta5.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KQO00H95WAUW9O0@mta5.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 28 Sep 2009 12:25:43 -0400 (EDT)
Date: Mon, 28 Sep 2009 12:25:42 -0400
From: Steven Toth <stoth@kernellabs.com>
Subject: Re: CX23885 card Analog/Digital Switch
In-reply-to: <4AC0DC20.2070307@gmail.com>
To: "David T. L. Wong" <davidtlwong@gmail.com>
Cc: linux-media@vger.kernel.org
Message-id: <4AC0E386.7070803@kernellabs.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7BIT
References: <4AC0DC20.2070307@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 9/28/09 11:54 AM, David T. L. Wong wrote:
> Hello List,
>
> cx23885 card Magic-Pro ProHDTV Extreme 2, has a cx23885 GPIO pin to
> select Analog TV+Radio or Digital TV. How should I add that GPIO setting
> code into cx23885?
> The current model that all operations goes to FE instead of card is not
> very appropriate to model this case.
> I thought of adding a callback code for the tuner (XC5000), but my case
> is that this behavior is card specific, but not XC5000 generic.
>
> Is there any "Input Selection" hook / callback mechanism to notify the
> card, the device.

Digital TV is about to have mkrufky's ioctl override patch merged so that the 
bridge can be informed before/after a dtv frontend is opened, this is an entry 
point for you. The bridge can flip the GPIO on demand based on current hardware 
state.

Analog tv entry point could be the hooked into one of the video open ops, such 
as video_open(). Likewise, the bridge would be involved.

-- 
Steven Toth - Kernel Labs
http://www.kernellabs.com
