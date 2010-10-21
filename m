Return-path: <mchehab@pedra>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:46319 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376Ab0JUNqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Oct 2010 09:46:40 -0400
Received: by qyk12 with SMTP id 12so2447418qyk.19
        for <linux-media@vger.kernel.org>; Thu, 21 Oct 2010 06:46:40 -0700 (PDT)
Subject: Re: [PATCH RFC]  ir-rc5-decoder: don't wait for the end space to produce a code
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <4CBF2477.9020008@redhat.com>
Date: Thu, 21 Oct 2010 09:46:55 -0400
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <0C5A1128-33E7-4331-98EB-D36C1005F51F@wilsonet.com>
References: <4CBF2477.9020008@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Oct 20, 2010, at 1:18 PM, Mauro Carvalho Chehab wrote:

> The RC5 decoding is complete at a BIT_END state. there's no reason
> to wait for the next space to produce a code.

Well, if I'm reading things correctly here, I think the only true functional difference made to the decoder here was to skip the if (ev.pulse) break; check in STATE_FINISHED, no? In other words, this looks like it was purely an issue with the receiver data parsing, which was ending on a pulse instead of a space. I can make this guess in greater confidence having seen another patch somewhere that implements a different buffer parsing routine for the polaris devices though... ;)

The mceusb portion of the patch is probably a worthwhile micro-optimization of its ir processing routine though -- don't call ir_raw_event_handle if there's no event to handle. Lemme just go ahead and merge that part via my staging tree, if you don't mind. (I've got a dozen or so IR patches that have been queueing up, planning on another pull req relatively soon).

-- 
Jarod Wilson
jarod@wilsonet.com



