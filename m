Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:45002 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbZFHBL6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Jun 2009 21:11:58 -0400
Received: by pzk1 with SMTP id 1so1884881pzk.33
        for <linux-media@vger.kernel.org>; Sun, 07 Jun 2009 18:12:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
References: <ab60605f580782732ecd676ecbab3ea3.squirrel@mail.voxel.net>
Date: Sun, 7 Jun 2009 21:12:00 -0400
Message-ID: <829197380906071812m591c3c3dy2cdac036d116a574@mail.gmail.com>
Subject: Re: funny colors from XC5000 on big endian systems
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: "W. Michael Petullo" <mike@flyn.org>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 7, 2009 at 8:22 PM, W. Michael Petullo<mike@flyn.org> wrote:
> Is it possible that the XC5000 driver does not work properly on big endian
> systems? I am using Linux/PowerPC 2.6.29.4. I have tried to view an analog
> NTSC video stream from a Hauppauge 950Q using various applications
> (including GStreamer v4lsrc and XawTV). The video is always present, but
> in purple and green hues.
>
> Mike
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hello Mike,

Yes, there was an issue that resulted in purple/green colors, but I
thought I had it fixed.  Perhaps the fix I made was endian specific (I
will have to check the code).  Note that this is entirely an issue
with the au8522 decoder driver, not the xc5000 tuner driver.

Admittedly, I have done all my testing with x86, so it wouldn't
surprise me if an endianness bug snuck in there (although I try to be
conscious of these sorts of issues).

Two questions:

Do you see the issue using tvtime?  This will help isolate whether
it's an application compatibility issue or whether it's related to
endianness (and I do almost all my testing with tvtime).

You indicated that you had reason to believe it's a PowerPC issue.  Is
there any reason that you came to that conclusion other than that
you're running on ppc?  I'm not discounting the possibility, but it
would be good to know if you have other information that supports your
theory.

Regards,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
