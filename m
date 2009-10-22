Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:37859 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756363AbZJVT1R (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Oct 2009 15:27:17 -0400
Received: by fxm18 with SMTP id 18so9575731fxm.37
        for <linux-media@vger.kernel.org>; Thu, 22 Oct 2009 12:27:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091022211330.6e84c6e7@hyperion.delvare>
References: <20091022211330.6e84c6e7@hyperion.delvare>
Date: Thu, 22 Oct 2009 15:27:20 -0400
Message-ID: <829197380910221227sc3b6398xbd3061e8483ac41@mail.gmail.com>
Subject: Re: Details about DVB frontend API
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: LMML <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 22, 2009 at 3:13 PM, Jean Delvare <khali@linux-fr.org> wrote:
> Hi folks,
>
> I am looking for details regarding the DVB frontend API. I've read
> linux-dvb-api-1.0.0.pdf, it roughly explains what the FE_READ_BER,
> FE_READ_SNR, FE_READ_SIGNAL_STRENGTH and FE_READ_UNCORRECTED_BLOCKS
> commands return, however it does not give any information about how the
> returned values should be interpreted (or, seen from the other end, how
> the frontend kernel drivers should encode these values.) If there
> documentation available that would explain this?
>
> For example, the signal strength. All I know so far is that this is a
> 16-bit value. But then what? Do greater values represent stronger
> signal or weaker signal? Are 0x0000 and 0xffff special values? Is the
> returned value meaningful even when FE_HAS_SIGNAL is 0? When
> FE_HAS_LOCK is 0? Is the scale linear, or do some values have
> well-defined meanings, or is it arbitrary and each driver can have its
> own scale? What are the typical use cases by user-space application for
> this value?
>
> That's the kind of details I'd like to know, not only for the signal
> strength, but also for the SNR, BER and UB. Without this information,
> it seems a little difficult to have consistent frontend drivers.
>
> Thanks,
> --
> Jean Delvare

Hi Jean,

I try to raise this every six months or so.  Check the mailing list
archive for "SNR" in the subject line.

Yes, it's all screwed up and inconsistent across demods.  I took a
crack at fixing it a few months ago by proposing a standard (and even
offering to fix up all the demods to be consistent), and those efforts
were derailed by some individuals who wanted what I would consider a
"perfect interface" at the cost of something that worked for 98% of
the userbase (I'm not going to point any fingers).  And what did we
get as a result?  Nothing.

I could have had this problem solved six months ago for 98% of the
community, and instead we are right where we have been since the
beginning of the project.

/me stops thinking about this and goes and gets some coffee....

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
