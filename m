Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16455 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646Ab2JYPu6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Oct 2012 11:50:58 -0400
Date: Thu, 25 Oct 2012 13:50:47 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-media@vger.kernel.org,
	laurent.pinchart@ideasonboard.com, hverkuil@xs4all.nl,
	rusty@rustcorp.com.au, dsd@laptop.org, hdegoede@redhat.com
Subject: Re: [PATCH v3 0/4] ov7670: migrate this sensor and its users to
 ctrl framework.
Message-ID: <20121025135047.30674062@redhat.com>
In-Reply-To: <CACKLOr0DQZ9q0yN7NEShAtEMaXf50HgWwaq2s1c84yAj7HShSw@mail.gmail.com>
References: <1348831603-18007-1-git-send-email-javier.martin@vista-silicon.com>
	<20120929132556.22c48312@hpe.lwn.net>
	<CACKLOr0DQZ9q0yN7NEShAtEMaXf50HgWwaq2s1c84yAj7HShSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Em Thu, 25 Oct 2012 15:27:08 +0200
javier Martin <javier.martin@vista-silicon.com> escreveu:

> Hi Mauro, Jon,
> any more issues related with this series?

Patch doesn't apply anymore:

patching file drivers/media/i2c/ov7670.c
Hunk #2 succeeded at 191 (offset -32 lines).
Hunk #3 succeeded at 220 (offset -35 lines).
Hunk #4 succeeded at 1062 (offset -153 lines).
Hunk #5 succeeded at 1091 (offset -153 lines).
Hunk #6 succeeded at 1127 (offset -153 lines).
Hunk #7 succeeded at 1147 (offset -153 lines).
Hunk #8 succeeded at 1195 (offset -153 lines).
Hunk #9 succeeded at 1211 (offset -153 lines).
Hunk #10 succeeded at 1237 (offset -153 lines).
Hunk #11 succeeded at 1255 (offset -153 lines).
Hunk #12 succeeded at 1351 (offset -153 lines).
Hunk #13 FAILED at 1605.
Hunk #14 FAILED at 1616.
Hunk #15 succeeded at 1434 (offset -189 lines).
2 out of 15 hunks FAILED -- rejects in file drivers/media/i2c/ov7670.c

Could you please rebase it? I tried to force its merge, but
it seemed that the conflicts are not that trivial, so I prefer
if you could do it and test if everything still applies.

Regards,
Mauro
-- 
Regards,
Mauro
