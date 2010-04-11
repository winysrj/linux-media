Return-path: <linux-media-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:51372 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0DKNZC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 11 Apr 2010 09:25:02 -0400
Message-ID: <4BC1CDA2.7070003@pobox.com>
Date: Sun, 11 Apr 2010 09:24:50 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Andy Walls <awalls@md.metrocast.net>
CC: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	ivtv-devel@ivtvdriver.org, Darren Blaber <dmbtech@gmail.com>
Subject: Re: cx18: "missing audio" for analog recordings
References: <4B8BE647.7070709@teksavvy.com>
 <1267493641.4035.17.camel@palomino.walls.org> <4B8CA8DD.5030605@teksavvy.com>
 <1267533630.3123.17.camel@palomino.walls.org> <4B9DA003.90306@teksavvy.com>
 <1268653884.3209.32.camel@palomino.walls.org>  <4BC0FB79.7080601@pobox.com>
 <1270940043.3100.43.camel@palomino.walls.org>  <4BC1401F.9080203@pobox.com>
 <1270961760.5365.14.camel@palomino.walls.org>
 <1270986453.3077.4.camel@palomino.walls.org>
In-Reply-To: <1270986453.3077.4.camel@palomino.walls.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/04/10 07:47 AM, Andy Walls wrote:
> On Sun, 2010-04-11 at 00:56 -0400, Andy Walls wrote:
>> Try this:
>>
>> 	http://linuxtv.org/hg/~awalls/cx18-audio2
>>
>> this waits 1.5 seconds after an input/channel change to see if the audio
>> standard micrcontroller can detect the standard.  If it can't, the
>> driver tells it to try a fallback detection.  Right now, only the NTSC-M
>> fallback detection is set to force a mode (i.e. BTSC), all the others
>> "fall back" to their same auto-detection.
>>
>> Some annoyances with the fallback to a forced audio standard, mode, and
>> format:
>>
>> 1. Static gets unmuted on stations with no signal. :(
>>
>> 2. I can't seem to force mode "MONO2 (LANGUAGE B)".  I'm guessing the
>> microcontroller keeps setting it back down to "MONO1 (LANGUAGE A/Mono L
>> +R channel for BTSC, EIAJ, A2)"  Feel free to experiment with the LSB of
>> the fallback setting magic number (0x1101) in
>> cx18-av-core.c:input_change().
>
> I fixed #2.  I had a bug so the first patch didn't properly set the
> fallback audio mode.
>
> I still need to fixup cx18_av_s_tuner() and cx18_av_g_tuner() to take
> into consideration that we might be using a forced audio mode vs. auto
> detection.  However, that is not essential for testing; this should be
> good enough for testing.
..

Those new patches don't want to coexist with the earlier hard/soft reset
changes.  There's always a chance that *both* things might be needed,
and the reset stuff didn't look obviously "bad".  Why dropped?

Thanks
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
