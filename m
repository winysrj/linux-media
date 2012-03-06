Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38639 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031094Ab2CFVFw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Mar 2012 16:05:52 -0500
Received: by obbuo6 with SMTP id uo6so5905267obb.19
        for <linux-media@vger.kernel.org>; Tue, 06 Mar 2012 13:05:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
References: <CALF0-+V7DXB+x-FKcy00kjfvdvLGKVTAmEEBP7zfFYxm+0NvYQ@mail.gmail.com>
Date: Tue, 6 Mar 2012 18:05:52 -0300
Message-ID: <CALF0-+UQ5+uJ=nm5qeveqno5EHKV=Ty+G-fC5s1og_CR=CmD2A@mail.gmail.com>
Subject: A second easycap driver implementation
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
	gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

After some research on v4l2 and videbuf2, and considering that easycap
driver is pretty
outdated I've decided to start writing a new driver from scratch.

I am using the excellent vivi driver and some usb video capture drivers as
a starting point. And of course, I'm using the current easycap implementation
as a reference (it works pretty well).

I have a couple of doubts regarding the development itself (how to
trace properly,
where to allocate urbs, and such) but perhaps the maintainers prefer
to take a look
at the code.

However, currently the driver is just a skeleton: it does all v4l2 and
videobuf2 intialization
but it doesn't actually stream video or submit urbs.

So,
1. Should I try to have something more finished before submit or can I
submit as it is?
2. In any case, how should I submit it? (Considering there is already
a working driver).

Thanks,
Ezequiel.
