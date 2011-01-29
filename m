Return-path: <mchehab@pedra>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50059 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab1A2AWE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Jan 2011 19:22:04 -0500
Received: by vws16 with SMTP id 16so1326483vws.19
        for <linux-media@vger.kernel.org>; Fri, 28 Jan 2011 16:22:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87oc73muul.fsf@nemi.mork.no>
References: <AANLkTi=_LHucekW21KeGt3yWMNYHntQ5nVvHUO2EVHAO@mail.gmail.com>
	<AANLkTimDK7kwV3AeZm5+56W3V_yp+nghq67qYP2r4DWq@mail.gmail.com>
	<AANLkTimDVfv-SGv8d0TVPPQD+eU8yUQ08MrCGXrXhMtz@mail.gmail.com>
	<AANLkTi=wotgd2JQ5b65rh5ExoU=+c4cAOZNFAg-NzJwr@mail.gmail.com>
	<AANLkTin6LyzVV=xw7mPOx3TupmX0YjQ38Q2Jzzpve+nS@mail.gmail.com>
	<87oc73muul.fsf@nemi.mork.no>
Date: Sat, 29 Jan 2011 01:22:00 +0100
Message-ID: <AANLkTikgwQbrETmX7pOcBnsM2w+ipnMczCJBSa8LwEeQ@mail.gmail.com>
Subject: Re: DVB driver for TerraTec H7 - how do I install them?
From: Torfinn Ingolfsen <tingox@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Update:

On Wed, Jan 26, 2011 at 6:35 PM, Bjørn Mork <bjorn@mork.no> wrote:
>
> Sure is.  But even if you get past the build errors, you'll soon
> discover that Terratec "forgot" to include the necessary firmware as
> well.  You can find it and some other hints in this thread:
> http://www.vdr-portal.de/board/thread.php?threadid=103040

I just installed yaVDR 0.3.0 on a machine and connected the TerraTec
H7 to it, in the hope that the necessary drivers was included with
yaVDR already (I'm not very good at reading german). Yes, I did copy
the firmware  to /lib/firmware first.
Unfortunately, it doesn't look like the drivers for H7 are included. I
have now posted a question on the vdr-portal.de forum, I'll post here
if it leads to anything.
-- 
Regards,
Torfinn Ingolfsen
