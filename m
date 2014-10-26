Return-path: <linux-media-owner@vger.kernel.org>
Received: from 69-165-173-139.dsl.teksavvy.com ([69.165.173.139]:56386 "EHLO
	londo.cneufeld.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaJZVfb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 17:35:31 -0400
Received: from cneufeld.ca (localhost [127.0.0.1])
	by londo.cneufeld.ca (8.14.4/8.14.4) with ESMTP id s9QLZUIq030590
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 17:35:30 -0400
Date: Sun, 26 Oct 2014 17:35:30 -0400
Message-Id: <201410262135.s9QLZUSV030589@cneufeld.ca>
To: linux-media@vger.kernel.org
From: Christopher Neufeld <media-alias@cneufeld.ca>
In-reply-to: <1414345274.6342.13.camel@palomino.walls.org> (message from Andy
	Walls on Sun, 26 Oct 2014 13:41:14 -0400)
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
Reply-to: media-alias@cneufeld.ca
References: <201410252315.s9PNF6eB002672@cneufeld.ca>
	 <544C8BAC.1070001@xs4all.nl> <201410261210.s9QCAQBD012612@cneufeld.ca> <1414345274.6342.13.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Andy,

On Sun, 26 Oct 2014 13:41:14 -0400, Andy Walls <awalls@md.metrocast.net> said:

> Can you verify that 

> 	v4l2-ctl -d <DEV> --get-fmt-sliced-vbi --get-ctrl=stream_vbi_format

> also fails, and that

Yes, that also fails.

> 	v4l2-ctl --list-devices
> 	v4l2-ctl -d /dev/vbi<N> --set-fmt-sliced-vbi=cc=1 --set-ctrl=stream_vbi_format=1
> 	v4l2-ctl -d /dev/vbi<N> --get-fmt-sliced-vbi --get-ctrl=stream_vbi_format

> both succeed on the corresponding vbi node?

Yes, those succeed.  So, that solves my problem, thank you.

> If you can use the /dev/vbiN node as a work-around, please do.

I will switch to doing that, and update the MythTV wiki appropriately.  I
assume that this is the correct invocation for any similar capture devices,
not just the PVR-500 and family.


On Sun, 26 Oct 2014 14:28:15 -0400, Andy Walls <awalls@md.metrocast.net> said:

> FYI, MythTV has already worked around it:
> https://code.mythtv.org/trac/ticket/11723
> https://github.com/MythTV/mythtv/commit/25310069a1154213cbc94c903c8b0ace30893ec4

Ah, well then that part of my bug report was incorrect.  Sometimes shows
don't send caption data, even the same program one week later.  I happened
to have two recordings in standard definition that had no captions, but one
recorded last night did, as might be expected if MythTV already worked
around it.

Thank you for your time on this, Andy and Hans.  I will update my scripts,
and this will work perfectly for me.


-- 
 Christopher Neufeld
 Home page:  http://www.cneufeld.ca/neufeld
 "Don't edit reality for the sake of simplicity"
