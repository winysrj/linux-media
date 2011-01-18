Return-path: <mchehab@pedra>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3738 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab1ARWp3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Jan 2011 17:45:29 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Luca Tettamanti <kronos.it@gmail.com>
Subject: Re: Upstreaming syntek driver
Date: Tue, 18 Jan 2011 23:45:17 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Nicolas VIVIEN <progweb@free.fr>
References: <AANLkTi=bv+NkwS+ASUDeAjbpNht8+YJaPRKYF7TTZDes@mail.gmail.com>
In-Reply-To: <AANLkTi=bv+NkwS+ASUDeAjbpNht8+YJaPRKYF7TTZDes@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182345.17725.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday, January 18, 2011 23:17:11 Luca Tettamanti wrote:
> Hello,
> I'm a "lucky" owner of a Syntek USB webcam (embedded on my Asus
> laptop); as you might know Nicolas (CC) wrote a driver for these
> cams[1][2], but it's still not included in mainline kernel.
> Since I'd rather save myself and the other users the pain of compiling
> an out-of-tree driver I'm offering my help to make the changes
> necessary to see this driver upstreamed; I'm already a maintainer of
> another driver (in hwmon), so I'm familiar with the development
> process.
> From a quick overview of the code I've spotted a few problems:
> - minor style issues, trivially dealt with
> - missing cleanups in error paths, idem
> - possible memory leak, reported on the bug tracker - requires investigation
> - big switch statements for all the models, could be simplified with
> function pointers
> 
> Another objection could be that the initialization is basically
> writing magic numbers into magic registers... I guess that Nicolas
> recorded the initialization sequence with a USB sniffer. No solution
> for this one; does anybody have a contact inside Syntek?
> 
> Are there other issues blocking the inclusion of this driver?

After a quick scan through the sources in svn I found the following (in no
particular order):

- Supports easycap model with ID 05e1:0408: a driver for this model is now
  in driver/staging/easycap.

- format conversion must be moved to libv4lconvert (if that can't already be
  used out of the box). Ditto for software brightness correction.

- kill off the sysfs bits

- kill off V4L1

- use the new control framework for the control handling

- use video_ioctl2 instead of the current ioctl function

- use unlocked_ioctl instead of ioctl

But probably the first step should be to see if this can't be made part of the
gspca driver. I can't help thinking that that would be the best approach. But
I guess the gspca developers can give a better idea of how hard that is.

Regards,

       Hans

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
