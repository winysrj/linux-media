Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:56477 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751847AbcGKI5d (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jul 2016 04:57:33 -0400
Subject: Re: [PATCH 0/5] Pulse-Eight USB CEC driver
To: Lars Op den Kamp <lars@opdenkamp.eu>, linux-media@vger.kernel.org
References: <1468156281-25731-1-git-send-email-hverkuil@xs4all.nl>
 <57834C17.7030100@opdenkamp.eu>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <c004682e-1c9b-6722-25c2-625b3a5ce9fd@xs4all.nl>
Date: Mon, 11 Jul 2016 10:57:28 +0200
MIME-Version: 1.0
In-Reply-To: <57834C17.7030100@opdenkamp.eu>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/11/2016 09:34 AM, Lars Op den Kamp wrote:
> Hi Hans,
> 
> I'm subscribed to this mailing list, though haven't been participating 
> in discussions here (no time). I work for Pulse-Eight and did most of 
> the CEC software.
> 
> There's no difference between firmware v4 and v5 for the USB model of 
> the adapter. v5 just adds support for the new Intel NUC internal CEC 
> adapter.
> 
> You can snoop the bus by setting the ack mask to 0 and just read what 
> comes in (MSGCODE_SET_ACK_MASK 0)

It turned out to be two small bugs (one in the CEC framework and one in the
cec-ctl utility) that prevented this from working. The driver was actually
fine.

Thanks for the reply, it forced me to look more closely at the code.

Regards,

	Hans
