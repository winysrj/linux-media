Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:39297 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588Ab1KNS3q (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Nov 2011 13:29:46 -0500
Received: by vcbgb30 with SMTP id gb30so764090vcb.19
        for <linux-media@vger.kernel.org>; Mon, 14 Nov 2011 10:29:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAA7M+FBKQ+uk-D9-ZZbvXW7-w3yfZ0sftpjLgd4xU7Ce2uRYFw@mail.gmail.com>
References: <CAA7M+FBvP0A7L6o-Fw4CQ2xR2CYqu233L+83BGGOcLooK0bk7w@mail.gmail.com>
	<CAGoCfiw+yy3Hz=7yvGTYrYQn5VfNh3CrabS_Kxx7G88jcwt9aQ@mail.gmail.com>
	<20111112141403.53708f28@hana.gusto>
	<CAGoCfiwnOTv=yhFeAsjQ+=5vrsUfy5b8HqtXGiFuimXe2M-+Bw@mail.gmail.com>
	<CAA7M+FAi517fUjLUxLsVSMr99N+2gpuhJMoiTbsuxyKGuf7-Kw@mail.gmail.com>
	<CAA7M+FCWHwRvX4UYGOqnN2yd+SyUDhbs7sn9djVy=Px0EMw6eg@mail.gmail.com>
	<4EBFE427.9010605@lockie.ca>
	<CAA7M+FBKQ+uk-D9-ZZbvXW7-w3yfZ0sftpjLgd4xU7Ce2uRYFw@mail.gmail.com>
Date: Mon, 14 Nov 2011 18:29:45 +0000
Message-ID: <CAA7M+FDbjMOck12hQu4CDCw8q7uVJw_ErZc-TB0bGb0Ucko40A@mail.gmail.com>
Subject: Re: HVR-4000 may be broken in kernel mods (again) ?
From: "jonathanjstevens@gmail.com" <jonathanjstevens@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'd be much obliged if someone could give me some interpretation on
the following?

If I read it right, this means that the tuner tunes OK, and then the
filter loads OK (no error message on the filter load), but no data is
being returned? If so, could this be a DMA problem? Would anyone know
a way to look closer at that?

This is from the a working USB DVB:




Take from a "strace -ttt -f -F -v scandvb -a 1 -f1 -d 0 -5 -v -v -v -5
~/dvbscan.channels.conf"
