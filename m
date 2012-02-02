Return-path: <linux-media-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45895 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828Ab2BBMC7 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Feb 2012 07:02:59 -0500
Date: Thu, 2 Feb 2012 13:02:57 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, linux-input@vger.kernel.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 6/6] hid-core: ignore the Keene FM transmitter.
In-Reply-To: <b385adb918f71c1276e9f0cee4e1501b2186dca5.1328183271.git.hans.verkuil@cisco.com>
Message-ID: <alpine.LNX.2.00.1202021301420.18918@pobox.suse.cz>
References: <1328183796-3168-1-git-send-email-hverkuil@xs4all.nl> <b385adb918f71c1276e9f0cee4e1501b2186dca5.1328183271.git.hans.verkuil@cisco.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2 Feb 2012, Hans Verkuil wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The Keene FM transmitter USB device has the same USB ID as
> the Logitech AudioHub Speaker, but it should ignore the hid.
> Check if the name is that of the Keene device.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Mauro, feel free to take this one with the rest of the patchset with my

	Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Thanks,

-- 
Jiri Kosina
SUSE Labs
