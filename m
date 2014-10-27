Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:2922 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbaJ0KLU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 27 Oct 2014 06:11:20 -0400
Message-ID: <544E1A3A.9000007@xs4all.nl>
Date: Mon, 27 Oct 2014 11:11:06 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Christopher.Neufeld@cneufeld.ca, linux-media@vger.kernel.org
Subject: Re: VBI on PVR-500 stopped working between kernels 3.6 and 3.13
References: <201410252315.s9PNF6eB002672@cneufeld.ca> <544C8BAC.1070001@xs4all.nl> <201410261210.s9QCAQBD012612@cneufeld.ca>
In-Reply-To: <201410261210.s9QCAQBD012612@cneufeld.ca>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 10/26/2014 01:10 PM, Christopher Neufeld wrote:
> Hello Hans,
> 
> On Sun, 26 Oct 2014 06:50:36 +0100, Hans Verkuil <hverkuil@xs4all.nl> said:
> 
>>> The script that I use to set up captions invokes this command:
>>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc --set-ctrl=stream_vbi_format=1
>>>
>>> This now errors out.  Part of that is a parsing bug in v4l2-ctl, it wants
>>> to see more text after the 'cc'.  I can change it to 
>>> v4l2-ctl -d <DEV> --set-fmt-sliced-vbi=cc=1 --set-ctrl=stream_vbi_format=1
> 
>> This is a v4l2-ctl bug. I'll fix that asap. But using cc=1 is a valid workaround.

Fixed this in the v4l-utils git repository. This is now working again as
expected. This reason this worked in the past was a case of two bugs canceling
one another out.

After fixing one bug, parsing this option no longer worked.

Regards,

	Hans
