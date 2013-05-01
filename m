Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:38986 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759423Ab3EAK2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 1 May 2013 06:28:25 -0400
Message-ID: <5180EE41.50302@gmail.com>
Date: Wed, 01 May 2013 12:28:17 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Kyungmin Park <kmpark@infradead.org>, t.stanislaws@samsung.com,
	linux-fbdev@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux@arm.linux.org.uk, jy0922.shim@samsung.com,
	alsa-devel@alsa-project.org, sbkim73@samsung.com,
	sw0312.kim@samsung.com, jg1.han@samsung.com,
	linux-mmc@vger.kernel.org, Tomasz Figa <tomasz.figa@gmail.com>,
	dri-devel@lists.freedesktop.org, inki.dae@samsung.com,
	jtp.park@samsung.com, dh09.lee@samsung.com,
	linux-arm-kernel@lists.infradead.org, s.nawrocki@samsung.com,
	k.debski@samsung.com, linux-media@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH] MAINTAINERS: Add linux-samsung-soc list
 to all related entries
References: <1366572050-626-1-git-send-email-tomasz.figa@gmail.com> <CAH9JG2U7Qdq_xQbuqHu6PXzURS2fWwBC=HJmyrXT5n3n_pAa0w@mail.gmail.com> <20130430132755.GB1023@sirena.org.uk>
In-Reply-To: <20130430132755.GB1023@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/30/2013 03:27 PM, Mark Brown wrote:
> On Mon, Apr 22, 2013 at 03:23:29PM +0900, Kyungmin Park wrote:
>
>> I don't think it's not required, each tree has each own mailing list. don't
>> need to post all patches to samsung-soc list.
>
> It can be useful to get system level input on some stuff, I guess it
> mostly depends if the people on the generic list mind the extra traffic
> or if they find it useful.

I think this could also improve testing coverage, if more people are aware
of stuff going in through various mailing lists.

Also on a specific subsystem mailing lists yet another SoC specific patches
may not get enough attention, as people care most about the core subsystem
changes.

So I would in general encourage others to Cc linux-samsung-soc, even if the
$subject patch gets ignored.

I seriously doubt anyone would have ever been disturbed with additional
traffic on the list, with its current average of about 20..50 emails per 
day.
