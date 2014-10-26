Return-path: <linux-media-owner@vger.kernel.org>
Received: from 69-165-173-139.dsl.teksavvy.com ([69.165.173.139]:51594 "EHLO
	londo.cneufeld.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaJZMjF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Oct 2014 08:39:05 -0400
Received: from cneufeld.ca (localhost [127.0.0.1])
	by londo.cneufeld.ca (8.14.4/8.14.4) with ESMTP id s9QCARot012613
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sun, 26 Oct 2014 08:10:27 -0400
Date: Sun, 26 Oct 2014 08:10:26 -0400
Message-Id: <201410261210.s9QCAQBD012612@cneufeld.ca>
From: Christopher Neufeld <neufeld@cneufeld.ca>
To: linux-media@vger.kernel.org
In-reply-to: <544C8BAC.1070001@xs4all.nl> (message from Hans Verkuil on Sun,
	26 Oct 2014 06:50:36 +0100)
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
Reply-to: Christopher.Neufeld@cneufeld.ca
References: <201410252315.s9PNF6eB002672@cneufeld.ca> <544C8BAC.1070001@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Hans,

On Sun, 26 Oct 2014 06:50:36 +0100, Hans Verkuil <hverkuil@xs4all.nl> said:

>> The script that I use to set up captions invokes this command:
>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc --set-ctrl=stream_vbi_format=1
>> 
>> This now errors out.  Part of that is a parsing bug in v4l2-ctl, it wants
>> to see more text after the 'cc'.  I can change it to 
>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc=1 --set-ctrl=stream_vbi_format=1

> This is a v4l2-ctl bug. I'll fix that asap. But using cc=1 is a valid workaround.

>> 
>> with this change, it no longer complains about the command line, but it
>> errors out in the ioctls.  This behaviour is seen with three versions of
>> v4l2-ctl: the old one packaged with the old kernel, the new one packaged
>> with the newer kernel, and the git-head, compiled against the headers of
>> the new kernel.

> Are you calling this when MythTV is already running? If nobody else is using
> the PVR-500, does it work?

When my script is running, MythTV is not using that unit of the PVR-500.  I
use the "recording groups" feature to ensure that that unit is made
unavailable for recordings whenever high-definition recordings are being
made.  The details of what I'm doing can be found here:
https://www.mythtv.org/wiki/Captions_With_HD_PVR

I would not expect this command to succeed if the unit were in use, in fact
the script detects that as an error case and loops until the device is
free.  The v4l2-ctl command that I use has historically returned an error
if somebody had the unit's video device open for reading.  Now, though, it
errors even when the unit is unused.

For my script, it is necessary that the MythTV backend be running, the
script is invoked by the backend, but when it is invoked, nobody is using
that unit of the PVR-500 (and, in practice, the other unit is almost never
used, as it's quite rare that I make standard-definition recordings).

My script is not used when MythTV directly makes a standard-definition
recording from the PVR-500.  In that case, the program presumably issues
its own ioctl equivalents of the v4l2-ctl command, and those are not
working, because the recordings produced do not have VBI data, while those
recorded before the kernel upgrade do.

> I won't be able to test this myself until next weekend at the earliest.

Captions are mostly for my wife's benefit, and I checked, most of her
upcoming shows are being recorded from OTA broadcasts, which provide ATSC
captions independently of the PVR-500, so I can wait for a week or two.


Thank you for looking into this.

-- 
 Christopher Neufeld
 Home page:  http://www.cneufeld.ca/neufeld
 "Don't edit reality for the sake of simplicity"
