Return-path: <linux-media-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:31868 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752768AbaDHULL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 8 Apr 2014 16:11:11 -0400
Message-ID: <534457DD.4000406@austin.rr.com>
Date: Tue, 08 Apr 2014 15:11:09 -0500
From: Keith Pyle <kpyle@austin.rr.com>
MIME-Version: 1.0
To: Ryley Angus <ryleyjangus@gmail.com>,
	'Hans Verkuil' <hverkuil@xs4all.nl>,
	linux-media@vger.kernel.org
Subject: Re: [RFC] Fix interrupted recording with Hauppauge HD-PVR
References: <C2340839-C85B-4DDF-8590-FA9049D6E65E@gmail.com> <5342B115.2070909@xs4all.nl> <007a01cf52db$253a7fe0$6faf7fa0$@gmail.com> <5344077D.4030809@austin.rr.com> <00e901cf534d$15fd4220$41f7c660$@gmail.com>
In-Reply-To: <00e901cf534d$15fd4220$41f7c660$@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/08/14 12:07, Ryley Angus wrote:
> Hi Kyle.
>
> It may be possible that the delay in acceptable grace periods is due to a
> difference in our input AV sources more so than the Hauppauge units
> themselves. I'm wondering if it would be useful to control the timeout
> period via a module parameter that defaults to 3 seconds perhaps?
>
> As far as the issues with concatenated output, I've just looked at the files
> containing a channel change and realized that VLC does show the duration as
> 0:00. Seeking with a keyboard isn't functional. Seeking with the timeline
> and a mouse is fine. Avidemux seems to have trouble editing the file. If I
> cut a section from a file that is from a single recording "session" it's
> duration is correct, sync is correct and audio properties are correct. I
> cannot cut across segments. MPC-HC also has duration issues with the
> recording.
>
> If I run the recordings through "ffmpeg -fflags +genpts -I <INPUT> -c:v copy
> -c:a copy <OUTPUT>", the resultant file duration is correct in VLC, I can
> seek with the keyboard and mouse and editing is perfect with Avidemux. But
> would it be better if the device just cleanly stopped recording instead of
> automatically resuming? Or, continuing with the module parameters idea,
> could we determine whether or not it will automatically restart based off a
> module parameter?
>
> I feel bad for not noticing the VLC issues earlier, but I mostly just use
> VLC to broadcast the recordings through my home network to client instances
> of VLC. This works well, but obviously seeking isn't relevant.
>
> ryley
>
> ...
I doubt that the multiple segment problem can be easily fixed in the 
hdpvr Linux driver.  With the caveat that I'm far away from being an 
expert on MPEG, TS, and the like, I believe that the HD-PVR encoder 
generates the timing data into the stream with its origin being defined 
when the encoder starts the stream.  So, if the capture is restarted, 
the encoder is re-initialized by the HD-PVR firmware and the result is a 
new origin for the following stream segment.

The only real fix would be in the HD-PVR firmware - which we can't get 
and is why we have this problem in the first place.

Regardless of this problem, I think the proposed driver patch is a 
distinct improvement over the current situation.  Without the patch, we 
get truncated recordings.  With the patch, we get nearly complete 
recordings which have skip issues.  As you noted, this problem may be 
fixed with ffmpeg.

Keith

