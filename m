Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:38576 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab1BUTVb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Feb 2011 14:21:31 -0500
Date: Mon, 21 Feb 2011 21:21:20 +0200
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbi@ti.com, David Cohen <dacohen@gmail.com>,
	linux-kernel@vger.kernel.org, mingo@elte.hu,
	linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221192046.GA6822@p183.telecom.by>
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
 <1298299131-17695-2-git-send-email-dacohen@gmail.com>
 <1298303677.24121.1.camel@twins>
 <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
 <1298305245.24121.7.camel@twins>
 <20110221162939.GK23087@legolas.emea.dhcp.ti.com>
 <1298306607.24121.18.camel@twins>
 <20110221165443.GL23087@legolas.emea.dhcp.ti.com>
 <1298307962.24121.27.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298307962.24121.27.camel@twins>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, Feb 21, 2011 at 06:06:02PM +0100, Peter Zijlstra wrote:
> 1) remove the inclusion of completion.h -- easy we can live with an
> incomplete type.

ACK

> 2) move the other wait_queue_head_t users (signal_struct sighand_struct)
> out of sched.h
> 
> 3) ...

Compile test! :^)

> 4) profit!
> 
> Just isolating the TASK_state bits isn't going to be enough, wait.h also
> wants wake_up goo and schedule*(), therefore either include sched.h from
> whatever .c file you're using wait.h bits or do the above cleanup.

Speaking of junk in sched.h, I'll send mm_types.h removal next merge window
and maybe cred.h.
