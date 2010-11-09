Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:62990 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab0KISCU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 13:02:20 -0500
Message-ID: <4CD98CA8.9020003@redhat.com>
Date: Tue, 09 Nov 2010 16:02:16 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
References: <AANLkTi=tc_4ZAk20fEamcFQ-VDFkt4tBwFH+uGv9Fw62@mail.gmail.com>	<AANLkTimYMTa8zigTYbZhH5dN7VGZDBUFmw3PL4jRV9hv@mail.gmail.com>	<4CD970BB.5030307@redhat.com> <AANLkTin7pq=UZPTWvCJ+Zdj2SeqfmruJ8q=dktEZLZBP@mail.gmail.com>
In-Reply-To: <AANLkTin7pq=UZPTWvCJ+Zdj2SeqfmruJ8q=dktEZLZBP@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 09-11-2010 14:07, Devin Heitmueller escreveu:
> On Tue, Nov 9, 2010 at 11:03 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 02-11-2010 16:47, Devin Heitmueller escreveu:
>>> On Sat, Oct 9, 2010 at 2:40 PM, Devin Heitmueller
>>> <dheitmueller@kernellabs.com> wrote:
>>>> Hello,
>>>>
>>>> Please pull from the following for some basic fixes related to
>>>> applications such as tvtime hanging when no video is present, as well
>>>> as some quality improvements for analog.
>>>>
>>>> http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
>>>>
>>>> Please let me know if there are any questions/problems.
>>
>> I'm still importing your patches, but, at the very first one, you
>> forgot to send your Signed-off-by:
>>
>> Generating hg_15168_djh_merge_vbi_changes.patch
>> WARNING: please, no space before tabs
>> #39: FILE: drivers/media/video/au0828/au0828.h:155:
>> +^Istruct au0828_buffer    ^I*vbi_buf;$
>>
>> ERROR: Missing Signed-off-by: line(s)
>>
>> Cheers,
>> Mauro
>>
> 
> "djh - merge vbi changes" was just a rebase against the latest code.
> The very first patch in the series is one earlier (047a8c9fa9d5).

Ok.

Hmm... the second patch is also without SOB:

patches/hg_15169_au8522_properly_set_default_brightness.patch
Changeset: 15169
From: Devin Heitmueller  <dheitmueller@kernellabs.com>
Commiter: Devin Heitmueller <dheitmueller@kernellabs.com>
Date: Sun Jun 13 16:31:22 2010 -0400
Subject: au8522: Properly set default brightness

The chip's default value for the brightness didn't match what we were sending
back in the queryctrl ioctl(), so if the application actually set the
brightness to the "default", it would actually end up being way too bright.

This work was sponsored by GetWellNetwork Inc.

Priority: normal

---

diff -upNr oldtree/drivers/media/dvb/frontends/au8522_decoder.c linux/drivers/media/dvb/frontends/au8522_decoder.c
--- oldtree/drivers/media/dvb/frontends/au8522_decoder.c	2010-11-09 14:00:23.000000000 -0200
+++ linux/drivers/media/dvb/frontends/au8522_decoder.c	2010-11-09 14:00:13.000000000 -0200
@@ -623,7 +623,7 @@ static int au8522_queryctrl(struct v4l2_
 		return v4l2_ctrl_query_fill(qc, 0, 255, 1,
 					    AU8522_TVDEC_CONTRAST_REG00BH_CVBS);
 	case V4L2_CID_BRIGHTNESS:
-		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
+		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 109);
 	case V4L2_CID_SATURATION:
 		return v4l2_ctrl_query_fill(qc, 0, 255, 1, 128);
 	case V4L2_CID_HUE:
