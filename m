Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail02a.mail.t-online.hu ([84.2.40.7]:55315 "EHLO
	mail02a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab0AHR3J (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jan 2010 12:29:09 -0500
Message-ID: <4B476B5E.7040909@freemail.hu>
Date: Fri, 08 Jan 2010 18:29:02 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>
CC: V4L Mailing List <linux-media@vger.kernel.org>
Subject: Re: gspca - pac7302: Add a delay on loading the bridge registers.
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

At http://linuxtv.org/hg/~jfrancois/gspca/rev/b0a374674388 :
> From: Jean-Francois Moine <moinejf@free.fr>
>
> Without the delay, the usb_control_msg() may fail when loading the
> page 3 with error -71 or -62.
>
> Priority: normal
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>

include/asm-generic/errno.h:
> #define ETIME           62      /* Timer expired */
> #define EPROTO          71      /* Protocol error */

I'm interested in which device have you used for testing this?

Regards,

	Márton Németh
