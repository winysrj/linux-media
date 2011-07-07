Return-path: <mchehab@localhost>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58132 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889Ab1GGX6U (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Jul 2011 19:58:20 -0400
Received: by pzk9 with SMTP id 9so1103929pzk.19
        for <linux-media@vger.kernel.org>; Thu, 07 Jul 2011 16:58:20 -0700 (PDT)
Date: Thu, 7 Jul 2011 16:58:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [git:v4l-dvb/for_v3.1] [media] rc: call input_sync after
 scancode reports
Message-ID: <20110707235813.GA9684@core.coreip.homeip.net>
References: <E1QevX3-000086-VJ@www.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1QevX3-000086-VJ@www.linuxtv.org>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@infradead.org>

On Fri, Jul 01, 2011 at 09:34:45PM +0200, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the 
> http://git.linuxtv.org/media_tree.git tree:
> 
> Subject: [media] rc: call input_sync after scancode reports
> Author:  Jarod Wilson <jarod@redhat.com>
> Date:    Thu Jun 23 10:40:55 2011 -0300
> 
> Due to commit cdda911c34006f1089f3c87b1a1f31ab3a4722f2, evdev only
> becomes readable when the buffer contains an EV_SYN/SYN_REPORT event. If
> we get a repeat or a scancode we don't have a mapping for, we never call
> input_sync, and thus those events don't get reported in a timely
> fashion.

Hmm, any chance to get it into 3.0?

-- 
Dmitry
