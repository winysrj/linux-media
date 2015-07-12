Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:34748 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbGLWRr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jul 2015 18:17:47 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: sadegh abbasi <sadegh612000@yahoo.co.uk>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] v4l2-ctrls: Add new S8, S16 and S32 compound control types
Date: Mon, 13 Jul 2015 01:18:04 +0300
Message-ID: <1738054.4vofqz5FHv@avalon>
In-Reply-To: <532636346.4083310.1436543123211.JavaMail.yahoo@mail.yahoo.com>
References: <54C8B7A3.9050801@xs4all.nl> <532636346.4083310.1436543123211.JavaMail.yahoo@mail.yahoo.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sadegh,

On Friday 10 July 2015 15:45:23 sadegh abbasi wrote:
> Hi Hans / Laurent,
> Just wondering what has happened to these patches. I used them in my driver
> and can not find them in 4.1 release. Have they been rejected?

Not exactly. The changes to v4l2-ctrls were considered to be fine, but we have 
a policy not to merge core changes without at least one driver using them. As 
the OMAP4 ISS part of the series still needs work, nothing got merged.

Hans, you mentioned you wanted to look at the RGB2RGB controls in a wider 
context (including the adv drivers for instance). Do you have anything to 
report ?

-- 
Regards,

Laurent Pinchart

