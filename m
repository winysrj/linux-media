Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([64.81.146.143]:53051 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709Ab0DXRNw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Apr 2010 13:13:52 -0400
Date: Sat, 24 Apr 2010 12:13:51 -0500 (CDT)
From: Mike Isely <isely@isely.net>
To: Sven Barth <pascaldragon@googlemail.com>
cc: linux-media@vger.kernel.org
Subject: Re: Problem with cx25840 and Terratec Grabster AV400
In-Reply-To: <4BD2EACA.5040005@googlemail.com>
Message-ID: <alpine.DEB.1.10.1004241212100.5135@ivanova.isely.net>
References: <4BD2EACA.5040005@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Actually the support in the pvrusb2 driver was never really completed.  
But since I don't have a sample of the hardware here I went on ahead and 
merged what was there so that it could get exposure and the remaining 
problems sorted out.

  -Mike


On Sat, 24 Apr 2010, Sven Barth wrote:

> Hello together!
> 
> I'm the owner of a Terratec Grabster AV400, which is supported by the pvrusb2
> (currently standalone version only). Video works well, but I have a problem
> with audio, when I use an unmodified v4l-dvb: the audio is too slow, as if the
> bitrate is set to low.
> 
> The device contains a cx25837-3 (according to dmesg) and audio routing has to
> be set to CX25840_AUDIO_SERIAL.
> 
> The problem now is, that this audio route setting is never applied, because
> there are (at least) two locations in cx25840-core.c where a check with
> is_cx2583x is done.
> Locally I've simply disabled that checks (see attached patch) and the AV400
> works as expected now. Of course this can't be the correct solution for the
> official v4l. Also I have to apply that patch after every kernel update (which
> happens rather often with ArchLinux ^^).
> 
> Thus I ask how this situation might be solved so that I can use the AV400
> without patching around in the source of v4l.
> 
> Attached:
> * dmesg output with unpatched cx25840 module
> * my "quick & dirty" patch for cx25840-core.c
> 
> Regards,
> Sven
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
