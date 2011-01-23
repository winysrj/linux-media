Return-path: <mchehab@pedra>
Received: from mail-px0-f174.google.com ([209.85.212.174]:40697 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab1AWOxl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Jan 2011 09:53:41 -0500
Received: by pxi15 with SMTP id 15so548318pxi.19
        for <linux-media@vger.kernel.org>; Sun, 23 Jan 2011 06:53:40 -0800 (PST)
Subject: Re: [RFC PATCH 3/3] v4l2-ctrls: update control framework documentation
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=euc-kr
From: Kim HeungJun <riverful@gmail.com>
In-Reply-To: <4D3C0C14.20100@gmail.com>
Date: Sun, 23 Jan 2011 23:53:32 +0900
Cc: Kim HeungJun <riverful@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <7306FADB-8EBA-4E95-886F-B9837A55A01A@gmail.com>
References: <1295694361-23237-1-git-send-email-hverkuil@xs4all.nl> <ebb5547e48e2d7e6e620d7218c6543d6dc7b06b1.1295693790.git.hverkuil@xs4all.nl> <4D3C0C14.20100@gmail.com>
To: Sylwester Nawrocki <snjw23@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Sylwester,

It's my humble opinions. Just read plz :)

2011. 1. 23., 오후 8:08, Sylwester Nawrocki 작성:

[snip]
 
>> +Handling autogain/gain-type Controls with Auto Clusters
>> +=======================================================
>> +
>> +A common type of control cluster is one that handles 'auto-foo/foo'-type
>> +controls. Typical examples are autogain/gain, autoexposure/exposure,
>> +autowhitebalance/red balance/blue balance. In all cases you have one controls
>> +that determines whether another control is handled automatically by the hardware,
>> +or whether it is under manual control from the user.
>> +
>> +The way these are supposed to be handled is that if you set one of the 'foo'
>> +controls, then the 'auto-foo' control should automatically switch to manual
>> +mode, except when you set the 'auto-foo' control at the same time, in which
> 
> Do "set the 'auto-foo' control at the same time" refer to what is done in
> a driver? I can't see how this statement could apply to userland.

If you are talking about how platform or user application can call CID twice in such specific
case, as you already know, yes, it happened. Actually, I have been faced the same
difficulty with platform and user application peoples. But, for now, this new control
framework seems to be easy handling the driver actions.

When the user controls the devices, the user application wants to call only one CID.
For example, when the user exposures camera device manually, they want to call
only V4L2_CID_EXPOSURE, not call additionally V4L2_CID_EXPOSURE_AUTO
setting the enumeration by V4L2_EXPOSURE_MANUAL.

IMHO, the ultimate reason seems that V4L2_CID_EXPOSURE is only responsible to
handle Manual Exposure, but the V4L2_CID_EXPOSURE_AUTO can influence Auto
and Manual case. The all CID having AUTO feature is likely to be the same case.
But, as I know, the previous driver using this CID having AUTO feature still exist now,
and it is very difficult to change the current control logic to handle devices. 

The birth of new v4l2_ctrl framework seems to be the better options I think, and
I'm very happy for that because it's ok not to be worry about how to set the
internal variables for matching the control sequence with platform and user any more.


