Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754455Ab1GVOHN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2011 10:07:13 -0400
Message-ID: <4E2983FB.3040301@redhat.com>
Date: Fri, 22 Jul 2011 10:06:51 -0400
From: Jarod Wilson <jarod@redhat.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Andy Walls <awalls@md.metrocast.net>,
	Chris W <lkml@psychogeeks.com>
Subject: Re: [PATCH] [media] imon: don't submit urb before rc_dev set up
References: <A91CBD95-B2AF-4F43-8BEC-6C8007ABB33C@wilsonet.com> <1311007609-28210-1-git-send-email-jarod@redhat.com>
In-Reply-To: <1311007609-28210-1-git-send-email-jarod@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jarod Wilson wrote:
> The interface 0 urb callback was being wired up before the rc_dev device
> was allocated, meaning the callback could be called with a null rc_dev,
> leading to an oops. This likely only ever happens on the older 0xffdc
> SoundGraph devices, which continually trigger interrupts even when they
> have no valid keydata, and the window in which it could happen is small,
> but its actually happening regularly for at least one user, and its an
> obvious fix. Compile and sanity-tested with one of my own imon devices.

Explicit self-nak on this one, just to crystal-clear, since this is 
handled without breaking ffdc device detection by a later patch.

-- 
Jarod Wilson
jarod@redhat.com


