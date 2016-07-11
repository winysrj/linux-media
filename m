Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:44598 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743AbcGKKCI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 06:02:08 -0400
Subject: Re: [PATCHv2 3/5] pulse8-cec: new driver for the Pulse-Eight USB-CEC
 Adapter
To: Lars Op den Kamp <lars@opdenkamp.eu>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <fd21234a-3ac4-44f5-1054-3430546596bb@xs4all.nl>
 <578369C5.5000402@opdenkamp.eu>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <8e011716-5d38-3475-ff87-1737b331e26c@xs4all.nl>
Date: Mon, 11 Jul 2016 12:02:02 +0200
MIME-Version: 1.0
In-Reply-To: <578369C5.5000402@opdenkamp.eu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars,

On 07/11/2016 11:41 AM, Lars Op den Kamp wrote:
> Hi Hans,
> 
> just did a quick scan of this patch.
> 
> The code should work on any firmware >= v2 revision 8, though older 
> versions may return 0 when the build date is requested. I believe I 
> added that in v3. Might want to add a !=0 check before writing to the log.
> 
> The CEC adapter has an "autonomous mode", used when it's not being 
> controlled by our userspace application or this kernel driver. It'll 
> respond to some basic CEC commands that allow the PC to be woken up by TV.
> If the adapter doesn't receive a MSGCODE_PING for 30 seconds when it's 
> in "controlled mode", then it'll revert to autonomous mode and it'll 
> reset all states internally.

Ah, that was rather obscure. Good to know.

What I do now (and that seems to work) is that in the pulse8_setup I turn
off the autonomous mode and then write that new setting to the EEPROM. After
that it looks like the autonomous mode stays off. Is that correct?

The autonomous mode really doesn't work well with the framework as it is
today.

CEC framework support for 'wakeup on CEC command' is something that is planned
for the future.

Regards,

	Hans
