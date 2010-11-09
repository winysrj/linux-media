Return-path: <mchehab@pedra>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45596 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0KIQHf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Nov 2010 11:07:35 -0500
Received: by ewy7 with SMTP id 7so3643712ewy.19
        for <linux-media@vger.kernel.org>; Tue, 09 Nov 2010 08:07:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CD970BB.5030307@redhat.com>
References: <AANLkTi=tc_4ZAk20fEamcFQ-VDFkt4tBwFH+uGv9Fw62@mail.gmail.com>
	<AANLkTimYMTa8zigTYbZhH5dN7VGZDBUFmw3PL4jRV9hv@mail.gmail.com>
	<4CD970BB.5030307@redhat.com>
Date: Tue, 9 Nov 2010 11:07:33 -0500
Message-ID: <AANLkTin7pq=UZPTWvCJ+Zdj2SeqfmruJ8q=dktEZLZBP@mail.gmail.com>
Subject: Re: [PULL] http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tue, Nov 9, 2010 at 11:03 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> Em 02-11-2010 16:47, Devin Heitmueller escreveu:
>> On Sat, Oct 9, 2010 at 2:40 PM, Devin Heitmueller
>> <dheitmueller@kernellabs.com> wrote:
>>> Hello,
>>>
>>> Please pull from the following for some basic fixes related to
>>> applications such as tvtime hanging when no video is present, as well
>>> as some quality improvements for analog.
>>>
>>> http://www.kernellabs.com/hg/~dheitmueller/v4l-dvb-950q-final
>>>
>>> Please let me know if there are any questions/problems.
>
> I'm still importing your patches, but, at the very first one, you
> forgot to send your Signed-off-by:
>
> Generating hg_15168_djh_merge_vbi_changes.patch
> WARNING: please, no space before tabs
> #39: FILE: drivers/media/video/au0828/au0828.h:155:
> +^Istruct au0828_buffer    ^I*vbi_buf;$
>
> ERROR: Missing Signed-off-by: line(s)
>
> Cheers,
> Mauro
>

"djh - merge vbi changes" was just a rebase against the latest code.
The very first patch in the series is one earlier (047a8c9fa9d5).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
