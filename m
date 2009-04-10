Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.hauppauge.com ([167.206.143.4]:4680 "EHLO
	mail.hauppauge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304AbZDJE7Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 00:59:25 -0400
Message-ID: <49DED220.6000701@linuxtv.org>
Date: Fri, 10 Apr 2009 00:59:12 -0400
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Edwin Windes <ewindes@winlund.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: v4l-dvb - nxt2004 question
References: <ad3842890904091914v31b7dff2g18d855d850e9da31@mail.gmail.com>
In-Reply-To: <ad3842890904091914v31b7dff2g18d855d850e9da31@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Edwin Windes wrote:
> Mike - don't know if you still exist at this address...
> 
> Once upon a time you wrote this:
>   
> http://lists-archives.org/video4linux/10378-kworld-atsc110-philips-tuv1236d-f-h-multiple-inputs.html
> 
> I used that information to hack the driver for my ATSC-110 card - 
> swapping the digital inputs so that I could tune QAM/Analog on one 
> input, and ATSC on the other.
> 
> I'm rebuilding my PVR box, and I'd like to use the latest V4L-DVB 
> sources.  But, the source code is quite different in that area, and I 
> haven't found anything that looks like it's selecting an antenna input.  
> Would you have any idea where I should be focusing?  I'm not sure if 
> it's even possible anymore.
> 
> Thanks for any info you might be able to share, and thanks for your 
> efforts to get the driver working in the first place!
> 
> -- 
> Ed Windes
> ewindes@winlund.com <mailto:ewindes@winlund.com>

I've added cc to the linux-media mailing list.  Please include cc to 
linux-media@vger.kernel.org when asking these types of questions.

You can specify the rf input path behavior by using the atv_input / 
dtv_input module options.  see output of "modinfo tuner-simple"

Regards,

Mike
