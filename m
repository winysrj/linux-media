Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:41409 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaDQJTA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:19:00 -0400
Message-ID: <534F9C7A.5050004@sca-uk.com>
Date: Thu, 17 Apr 2014 10:18:50 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <xjuifxk76a4wghmign4a5brq.1397672108211@email.android.com>
In-Reply-To: <xjuifxk76a4wghmign4a5brq.1397672108211@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 16/04/14 19:15, Steve Cookson wrote:
> For no good reason AFAICT the initial resolution is set to 320x240. But
> >you can just set it to 640x480 (or more likely, 720x480 for NTSC or
> >720x576 for PAL):
> >
> >v4l2-ctl -v width=640,height=480
Hi Guys,

The attachments here are sent using tinypic.com.  It's the first time 
I've used it, so I hope it works OK.

I'm using the qv4l utility, but I did try it on v4l2-ctl and gst-launch 
and the results are the same as the one's I shall post here.

Firstly, here is stk1160 s-video for a baseline comparison.  Look at the 
word "File" in the file menu:

- http://tinypic.com/m/i50k8z/2

Now here is ImpactVCB-e composite.  Again look at the word "File" in the 
file menu:

- http://tinypic.com/m/i50k8n/2

The quality is a little worse, but maybe that is just 
Composite/S-Video.  Composite is not working on my stk1160, so I can't 
do a direct comparison.

Now let's look at ImpactVCB-e s-video:

- http://tinypic.com/m/i50k8w/2

It looks like every other line is missing.  I'd guess it's 640x240. I've 
tried v4l2-ctl -v width=640,height=480 etc, but no difference.

You can see it too with images but it's just not so obvious as with text.

Now when I switch back to ImpactVCB-e composite, I get the same problem, 
but after a restart it goes away.

What do you think?

Regards

Stev
