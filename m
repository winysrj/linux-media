Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:11588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab0KIQDL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Nov 2010 11:03:11 -0500
Message-ID: <4CD970BB.5030307@redhat.com>
Date: Tue, 09 Nov 2010 14:03:07 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
References: <AANLkTi=tc_4ZAk20fEamcFQ-VDFkt4tBwFH+uGv9Fw62@mail.gmail.com> <AANLkTimYMTa8zigTYbZhH5dN7VGZDBUFmw3PL4jRV9hv@mail.gmail.com>
In-Reply-To: <AANLkTimYMTa8zigTYbZhH5dN7VGZDBUFmw3PL4jRV9hv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 02-11-2010 16:47, Devin Heitmueller escreveu:
> On Sat, Oct 9, 2010 at 2:40 PM, Devin Heitmueller
> <dheitmueller@kernellabs.com> wrote:
>> Hello,
>>
>> Please pull from the following for some basic fixes related to
>> applications such as tvtime hanging when no video is present, as well
>> as some quality improvements for analog.
>>
>> http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
>>
>> Please let me know if there are any questions/problems.

I'm still importing your patches, but, at the very first one, you
forgot to send your Signed-off-by:

Generating hg_15168_djh_merge_vbi_changes.patch
WARNING: please, no space before tabs
#39: FILE: drivers/media/video/au0828/au0828.h:155:
+^Istruct au0828_buffer    ^I*vbi_buf;$

ERROR: Missing Signed-off-by: line(s)

Cheers,
Mauro
