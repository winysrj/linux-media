Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57329 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1FKQ5S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Jun 2011 12:57:18 -0400
Received: by eyx24 with SMTP id 24so1211587eyx.19
        for <linux-media@vger.kernel.org>; Sat, 11 Jun 2011 09:57:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4a3fc9cd-d7e1-4692-92cb-af4d652c0224@email.android.com>
References: <1307804731-16430-1-git-send-email-hverkuil@xs4all.nl>
	<BANLkTikWiEb+aGGbSNSZ+YtdeVRB6QaJtg@mail.gmail.com>
	<201106111753.21581.hverkuil@xs4all.nl>
	<4a3fc9cd-d7e1-4692-92cb-af4d652c0224@email.android.com>
Date: Sat, 11 Jun 2011 12:57:16 -0400
Message-ID: <BANLkTikJbhC--Qp4KUBjFdrCMuvvoMuxaA@mail.gmail.com>
Subject: Re: [RFCv2 PATCH 0/5] tuner-core: fix s_std and s_tuner
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sat, Jun 11, 2011 at 12:06 PM, Andy Walls <awalls@md.metrocast.net> wrote:
> Devin,
>
> I think I have a Gotview or compro card with an xc2028.  Is that tuner capable of standby?  Would the cx18 or ivtv driver need to actively support using stand by?

An xc2028/xc3028 should be fine, as that does support standby.  The
problems we saw with VLC were related to calls like G_TUNER returning
prematurely if the device was in standby, leaving the returned
structure populated with garbage.

FWIW, I don't dispute your assertion that Hans found legitimate bugs -
just that we need to be careful to not cause regressions in the cases
that the last round of bug fixes addressed.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
