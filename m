Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx.stud.uni-hannover.de ([130.75.176.3]:58748 "EHLO
	studserv5d.stud.uni-hannover.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751276AbZINKg0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 06:36:26 -0400
Message-ID: <4AAE1975.6050707@stud.uni-hannover.de>
Date: Mon, 14 Sep 2009 12:22:45 +0200
From: Soeren Moch <Soeren.Moch@stud.uni-hannover.de>
MIME-Version: 1.0
To: pboettcher@kernellabs.com
CC: linux-media@vger.kernel.org
Subject: Re: DVB USB stream parameters
References: <4A16A8FF.2050308@stud.uni-hannover.de>
In-Reply-To: <4A16A8FF.2050308@stud.uni-hannover.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> I don't know exactly why (the USB/HW background for that is not 
> present in my brain), but at some point having less than 39480B for 
> one (high-level) URB for the dib0700 resulted in never having any URB 
> returning from the USB stack. I chose 4 of them because .. I don't 
> remember. It seems even 1 is working.

I vote for a single high-level URB. Besides the memory savings this is 
the only way I could get my nova-td stick working.
(see this thread: 
http://www.mail-archive.com/linux-media@vger.kernel.org/msg06376.html ) 
The patch runs flawlessly
on my vdr system for months now.

> I remember someone telling me that this is due to something in the 
> firmware. I need to wait for some people to be back from whereever 
> they are to know exactly what's going on (that's why I haven't 
> responded yet).
I hope you can sort out the dib0700_streaming_ctrl problems...

Soeren

