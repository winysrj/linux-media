Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr14.xs4all.nl ([194.109.24.34]:2048 "EHLO
	smtp-vbr14.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaGVGjR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 02:39:17 -0400
Message-ID: <53CE0703.8070203@xs4all.nl>
Date: Tue, 22 Jul 2014 08:38:59 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Hans de Goede <hdegoede@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 0/3] rc_keymaps: Add 3 keymaps for various allwinner android
 tv
References: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1399578087-2365-1-git-send-email-hdegoede@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 05/08/2014 09:41 PM, Hans de Goede wrote:
> Hi All,
> 
> These patches add keymaps for the remotes found with various allwinner android
> tv boxes. I've checked that these are not duplicate with existing configs.
> 
> These tv-boxes can run regular Linux, and that is what these keymaps are
> intended for.
> 
> If there are no objections I'm going to push these in a couple of days.

These keymaps pose a problem: every time I sync with the latest kernel version
(make sync-with-kernel) the keymaps are regenerated from the source code and
you three keymaps are deleted.

I saw it in time and prevented their deletion, but I (or someone else) is going
to miss it and they are gone.

The gen_keytables.pl is the one that regenerates them, so you'll have to take
a look at that to see what the correct solution is. I know little about keymaps,
all I see is that something is guaranteed to go wrong in the near future :-)

Regards,

	Hans
