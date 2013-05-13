Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:50004 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab3EMKF4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 May 2013 06:05:56 -0400
Message-ID: <1368439554.1350.49.camel@x61.thuisdomein>
Subject: Re: [v3] media: davinci: kconfig: fix incorrect selects
From: Paul Bolle <pebolle@tiscali.nl>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
Cc: Sekhar Nori <nsekhar@ti.com>,
	davinci-linux-open-source@linux.davincidsp.com,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	linux-media@vger.kernel.org
Date: Mon, 13 May 2013 12:05:54 +0200
In-Reply-To: <CA+V-a8sEMsQENPN+40bMtOpTs5Xq9HbtiR49shhd=+kXU3-2YA@mail.gmail.com>
References: <1363079692-16683-1-git-send-email-nsekhar@ti.com>
	 <1368438071.1350.43.camel@x61.thuisdomein>
	 <CA+V-a8sEMsQENPN+40bMtOpTs5Xq9HbtiR49shhd=+kXU3-2YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Prabhakar,

On Mon, 2013-05-13 at 15:27 +0530, Prabhakar Lad wrote:
> Good catch! the dependency can be dropped now.

Great.

> Are you planning to post a patch for it or shall I do it ?

I don't mind submitting that trivial patch.

However, it's probably better if you do that. I can only state that this
dependency is now useless, because that is simply how the kconfig system
works. But you can probably elaborate why it's OK to not replace it with
another (negative) dependency. That would make a more informative commit
explanation.


Paul Bolle

