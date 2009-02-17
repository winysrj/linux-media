Return-path: <linux-media-owner@vger.kernel.org>
Received: from zone0.gcu-squad.org ([212.85.147.21]:2862 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZBQNXm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 08:23:42 -0500
Date: Tue, 17 Feb 2009 14:23:27 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Minimum kernel version supported by v4l-dvb
Message-ID: <20090217142327.1678c1a6@hyperion.delvare>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

These days I am helping Hans Verkuil convert the last users of the
legacy i2c device driver binding model to the new, standard binding
model. It turns out to be a very complex task because the v4l-dvb
repository is supposed to still support kernels as old as 2.6.16, while
the initial support for the new i2c binding model was added in kernel
2.6.22 (and even that is somewhat different from what is upstream now.)
This forces us to add quirks all around the place, which will surely
result in bugs because the code becomes hard to read, understand and
maintain.

In fact, without this need for backwards compatibility, I would
probably have been able to convert most of the drivers myself, without
Hans' help, and this would already be all done. But as things stand
today, he has to do most of the work, and our progress is slow.

So I would like you to consider changing the minimum kernel version
supported by the v4l-dvb repository from 2.6.16 to at least 2.6.22.
Ideal for us would even be 2.6.26, but I would understand that this is
too recent for you. Kernel 2.6.22 is one year and a half old, I
honestly doubt that people fighting to get their brand new TV adapter
to work are using anything older. As a matter of fact, kernel 2.6.22 is
what openSUSE 10.3 has, and this is the oldest openSUSE product that is
still maintained.

I understand and respect your will to let a large range of users build
the v4l-dvb repository, but at some point the cost for developers seems
to be too high, so there's a balance to be found between users and
developers. At the moment the balance isn't right IMHO.

Thanks,
-- 
Jean Delvare
