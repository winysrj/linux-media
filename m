Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37771 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab1CJUgP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 15:36:15 -0500
Received: by qyk7 with SMTP id 7so5250017qyk.19
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 12:36:14 -0800 (PST)
References: <AANLkTik_W1uE05J+BSY8K6siOdgYxsB1CLmiFUmGy-s8@mail.gmail.com>
In-Reply-To: <AANLkTik_W1uE05J+BSY8K6siOdgYxsB1CLmiFUmGy-s8@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Message-Id: <BF6ACC3F-C9C0-42F4-B649-B4D28AB9B4A4@wilsonet.com>
Content-Transfer-Encoding: 7bit
From: Jarod Wilson <jarod@wilsonet.com>
Subject: Re: mygica hdcap
Date: Thu, 10 Mar 2011 15:30:29 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mar 10, 2011, at 12:26 PM, James Klaas wrote:

> I just got one of these the other day and I was wondering if anyone
> has looked at it.  It will take HDMI, component and composite input
> plus stereo.  I have a picture I can post somewhere of the board.  It
> has 3 main chips.
> 
> AD9985A - Component/composite input?
> SIL9013CLU - Audio input?
> TM6202 - HDMI input
> 
> I'm not sure if this falls under v4l since it has no tuner or dvb
> since it captures digital video.

It looks like an at least semi-similar device to the Hauppauge HD-PVR,
which is under v4l, so it probably does make sense here. Not aware of
anyone working on your specific hardware, but Hans Verkuil posted some
patches for some at least similar-ish Analog Devices chips not too
long ago, which might be relevant to at least that part of your card...

http://git.linuxtv.org/hverkuil/cisco.git?a=shortlog;h=refs/heads/cobalt

-- 
Jarod Wilson
jarod@wilsonet.com



