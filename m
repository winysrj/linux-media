Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:1851 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaDQJ7U (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 05:59:20 -0400
Message-ID: <534FA5EC.9020104@xs4all.nl>
Date: Thu, 17 Apr 2014 11:59:08 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Steve Cookson <it@sca-uk.com>
CC: Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <xjuifxk76a4wghmign4a5brq.1397672108211@email.android.com> <534F9C7A.5050004@sca-uk.com>
In-Reply-To: <534F9C7A.5050004@sca-uk.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/17/2014 11:18 AM, Steve Cookson wrote:
> 
> On 16/04/14 19:15, Steve Cookson wrote:
>> For no good reason AFAICT the initial resolution is set to 320x240. But
>>> you can just set it to 640x480 (or more likely, 720x480 for NTSC or
>>> 720x576 for PAL):
>>>
>>> v4l2-ctl -v width=640,height=480
> Hi Guys,
> 
> The attachments here are sent using tinypic.com.  It's the first time 
> I've used it, so I hope it works OK.
> 
> I'm using the qv4l utility, but I did try it on v4l2-ctl and gst-launch 
> and the results are the same as the one's I shall post here.
> 
> Firstly, here is stk1160 s-video for a baseline comparison.  Look at the 
> word "File" in the file menu:
> 
> - http://tinypic.com/m/i50k8z/2
> 
> Now here is ImpactVCB-e composite.  Again look at the word "File" in the 
> file menu:
> 
> - http://tinypic.com/m/i50k8n/2
> 
> The quality is a little worse, but maybe that is just 
> Composite/S-Video.  Composite is not working on my stk1160, so I can't 
> do a direct comparison.
> 
> Now let's look at ImpactVCB-e s-video:
> 
> - http://tinypic.com/m/i50k8w/2
> 
> It looks like every other line is missing.  I'd guess it's 640x240. I've 
> tried v4l2-ctl -v width=640,height=480 etc, but no difference.
> 
> You can see it too with images but it's just not so obvious as with text.
> 
> Now when I switch back to ImpactVCB-e composite, I get the same problem, 
> but after a restart it goes away.
> 
> What do you think?

Looks like a driver bug to me. This driver needs some TLC, which I plan on
giving, but I need to finish a bunch of other stuff first.

Just use composite in the meantime.

Regards,

	Hans
