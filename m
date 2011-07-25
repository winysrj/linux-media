Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39401 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab1GYRZp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jul 2011 13:25:45 -0400
Received: by ewy4 with SMTP id 4so2572536ewy.19
        for <linux-media@vger.kernel.org>; Mon, 25 Jul 2011 10:25:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL8ugEc33uZBEz-5WxVd5aGArCRq8tv6X1K0uaJHiEVgqEfd6g@mail.gmail.com>
References: <1310581347-31102-1-git-send-email-agnel.joel@gmail.com>
	<CAL8ugEc33uZBEz-5WxVd5aGArCRq8tv6X1K0uaJHiEVgqEfd6g@mail.gmail.com>
Date: Mon, 25 Jul 2011 12:25:44 -0500
Message-ID: <CAD=GYpZAkXGEYVmLtz7iTe+OUKrA_bX2ZQdKMWNfB09DtVh3BA@mail.gmail.com>
Subject: Re: [beagleboard] [RFC v1] mt9v113: VGA camera sensor driver and
 support for BeagleBoard
From: Joel A Fernandes <agnel.joel@gmail.com>
To: Mark Grosen <mark@grosen.org>
Cc: beagleboard@googlegroups.com, jdk@ti.com,
	Javier Martin <javier.martin@vista-silicon.com>,
	laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org,
	k-kooi@ti.com, pprakash@ti.com, chase.maupin@ti.com,
	s-kipisz2@ti.com, saaguirre@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Mark,

Thanks for trying this out.

>> media-ctl/yavta commands you could use to get it to show a picture can be found at:
>> http://utdallas.edu/~joel.fernandes/stream.sh
>>
>
> Joel,
>
> I gave this a try this weekend. I ran into a few problems/questions.
>
> I wanted to try with pre-built (tested?) binaries so I grabbed yours
> (used your uImage):
> 1. media-ctl binary does not work because there is no libmediactl.so
> on my Angstrom root FS.

You could install the packages Koen mentioned and then use my
media-ctl binary, that would make sure you have all the library
dependencies.

You could also try copying my libmediactl.so from [1] to /usr/lib/ and
run 'ldconfig', but that would be sort of a hack :)

Thanks,
Joel

[1] http://www.utdallas.edu/~jaf090020/libmediactl.so.0
