Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776Ab1IFSQb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Sep 2011 14:16:31 -0400
Message-ID: <4E666417.9090706@redhat.com>
Date: Tue, 06 Sep 2011 20:19:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 01/10] alsa_stream: port changes made on xawtv3
References: <1315322996-10576-1-git-send-email-mchehab@redhat.com> <4E663EE2.3050403@redhat.com> <CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
In-Reply-To: <CAGoCfiz9YAHYNJdEAT51fyfLY8RS_TcRpzKzLYCdNFCc3JcbEA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 09/06/2011 06:24 PM, Devin Heitmueller wrote:

<snip>

> I've been thinking for a while that perhaps the project should be
> renamed (or I considered prepending "kl" onto the front resulting in
> it being called "kl-tvtime").  This isn't out of vanity but rather my
> concern that the fork will get confused with the original project (for
> example, I believe Ubuntu actually already calls their modified tree
> tvtime 1.0.3).  I'm open to suggestions in this regards.

I think that what should be done is contact the debian / ubuntu maintainers,
get any interesting fixes they have which the kl version misses merged,
and then just declare the kl version as being the new official upstream
(with the blessing of the debian / ubuntu guys, and if possible also
with the blessing of the original authors).

This would require kl git to be open to others for pushing, or we
could move the tree to git.linuxtv.org (which I assume may be
easier then for you to make the necessary changes to give
others push rights on kl.org).

Regards,

Hans
