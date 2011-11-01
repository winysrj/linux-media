Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1KAJSG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 1 Nov 2011 05:18:06 -0400
Message-ID: <4EAFB960.8040706@redhat.com>
Date: Tue, 01 Nov 2011 10:18:24 +0100
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Various ctrl and event frame work patches (version 2)
References: <1320074209-23473-1-git-send-email-hdegoede@redhat.com> <201110311717.32581.hverkuil@xs4all.nl>
In-Reply-To: <201110311717.32581.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/31/2011 05:17 PM, Hans Verkuil wrote:
> Hi Hans!
>
> On Monday, October 31, 2011 16:16:43 Hans de Goede wrote:
>> Hi All,
>>
>> This patch set obsoletes my previous "add v4l2_subscribed_event_ops" set,
>> while working on adding support for ctrl-events to the uvc driver I found
>> a few bugs in the event code, which this patchset fixes.
>
> Did you see my comments to patches 3/6, 4/6 and 5/6 in version 1?
> Those need to be addressed before I can ack them.

No I'm afraid I somehow completely missed those, I see them in the mailing
list archive. I'll reply to them by copy pasting from the archive,
so if my next replies look a bit out of place wrt their place in
threaded mail readers, that is why.

After that I'll respin the patchset addressing the issues you've pointed out.

Regards,

Hans


