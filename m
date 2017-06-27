Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:40444 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752539AbdF0Iix (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 27 Jun 2017 04:38:53 -0400
Subject: Re: [PATCH 1/8] arm: omap4: enable CEC pin for Pandaboard A4 and ES
To: Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <20170414102512.48834-1-hverkuil@xs4all.nl>
 <20170414102512.48834-2-hverkuil@xs4all.nl>
 <4355dab4-9c70-77f7-f89b-9a1cf24976cf@ti.com>
 <20170626110711.GW3730@atomide.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <701dbbfa-000a-2b93-405b-246aa90b6dd6@xs4all.nl>
Date: Tue, 27 Jun 2017 10:38:45 +0200
MIME-Version: 1.0
In-Reply-To: <20170626110711.GW3730@atomide.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 26/06/17 13:07, Tony Lindgren wrote:
> Tomi,
> 
> * Tomi Valkeinen <tomi.valkeinen@ti.com> [170428 04:15]:
>> On 14/04/17 13:25, Hans Verkuil wrote:
>>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>>
>>> The CEC pin was always pulled up, making it impossible to use it.
> ...
> 
>> Tony, can you queue this? It's safe to apply separately from the rest of
>> the HDMI CEC work.
> 
> So the dts changes are merged now but what's the status of the CEC driver
> changes? Were there some issues as I don't see them in next?

Tomi advised me to wait until a 'hotplug-interrupt-handling series' for the
omap driver is merged to prevent conflicts. Last I heard (about 3 weeks ago)
this was still pending review.

Tomi, any updates on this? It would be nice to get this in for 4.14.

Regards,

	Hans
