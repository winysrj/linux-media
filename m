Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:60785 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751616AbaJZW1L (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 18:27:11 -0400
In-Reply-To: <201410262135.s9QLZUSV030589@cneufeld.ca>
References: <201410252315.s9PNF6eB002672@cneufeld.ca> <544C8BAC.1070001@xs4all.nl> <201410261210.s9QCAQBD012612@cneufeld.ca> <1414345274.6342.13.camel@palomino.walls.org> <201410262135.s9QLZUSV030589@cneufeld.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
From: Andy Walls <awalls@md.metrocast.net>
Date: Sun, 26 Oct 2014 18:27:02 -0400
To: media-alias@cneufeld.ca, linux-media@vger.kernel.org
Message-ID: <8F9EC1E7-D341-48DE-88BC-7494763DF8A9@md.metrocast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On October 26, 2014 5:35:30 PM EDT, Christopher Neufeld <media-alias@cneufeld.ca> wrote:
>Andy,
>
>On Sun, 26 Oct 2014 13:41:14 -0400, Andy Walls
><awalls@md.metrocast.net> said:
>
>> Can you verify that 
>
>> 	v4l2-ctl -d <DEV> --get-fmt-sliced-vbi --get-ctrl=stream_vbi_format
>
>> also fails, and that
>
>Yes, that also fails.
>
>> 	v4l2-ctl --list-devices
>> 	v4l2-ctl -d /dev/vbi<N> --set-fmt-sliced-vbi=cc=1
>--set-ctrl=stream_vbi_format=1
>> 	v4l2-ctl -d /dev/vbi<N> --get-fmt-sliced-vbi
>--get-ctrl=stream_vbi_format
>
>> both succeed on the corresponding vbi node?
>
>Yes, those succeed.  So, that solves my problem, thank you.
>
>> If you can use the /dev/vbiN node as a work-around, please do.
>
>I will switch to doing that, and update the MythTV wiki appropriately. 
>I
>assume that this is the correct invocation for any similar capture
>devices,
>not just the PVR-500 and family.
>
>
>On Sun, 26 Oct 2014 14:28:15 -0400, Andy Walls
><awalls@md.metrocast.net> said:
>
>> FYI, MythTV has already worked around it:
>> https://code.mythtv.org/trac/ticket/11723
>>
>https://github.com/MythTV/mythtv/commit/25310069a1154213cbc94c903c8b0ace30893ec4
>
>Ah, well then that part of my bug report was incorrect.  Sometimes
>shows
>don't send caption data, even the same program one week later.  I
>happened
>to have two recordings in standard definition that had no captions, but
>one
>recorded last night did, as might be expected if MythTV already worked
>around it.
>
>Thank you for your time on this, Andy and Hans.  I will update my
>scripts,
>and this will work perfectly for me.

Hi Chris,

Well, I didn't look at MythTV's logic for finding the correct vbi device.  You might not get captions from MythTV recordings, if it guessed the wrong vbi node or if it didn't have sufficient permissions to access the vbi node.

Regards,
Andy
