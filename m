Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:41271 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751435AbbGMIN3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Jul 2015 04:13:29 -0400
Message-ID: <55A372EE.4040103@xs4all.nl>
Date: Mon, 13 Jul 2015 10:12:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 1/6] v4l2-ctrls: Add new S8, S16 and S32 compound control
 types
References: <54C8B7A3.9050801@xs4all.nl> <532636346.4083310.1436543123211.JavaMail.yahoo@mail.yahoo.com> <1738054.4vofqz5FHv@avalon>
In-Reply-To: <1738054.4vofqz5FHv@avalon>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 07/13/2015 12:18 AM, Laurent Pinchart wrote:
> Hi Sadegh,
> 
> On Friday 10 July 2015 15:45:23 sadegh abbasi wrote:
>> Hi Hans / Laurent,
>> Just wondering what has happened to these patches. I used them in my driver
>> and can not find them in 4.1 release. Have they been rejected?
> 
> Not exactly. The changes to v4l2-ctrls were considered to be fine, but we have 
> a policy not to merge core changes without at least one driver using them. As 
> the OMAP4 ISS part of the series still needs work, nothing got merged.
> 
> Hans, you mentioned you wanted to look at the RGB2RGB controls in a wider 
> context (including the adv drivers for instance). Do you have anything to 
> report ?

Yes and no :-)

It's part of my work to support colorspace conversion hardware. Now for 4.2 I merged
a lot of patches that pave the way for the remaining code to go in. But that remaining
code still needs to be cleaned up. My code can be found here:

http://git.linuxtv.org/cgit.cgi/hverkuil/media_tree.git/log/?h=csc

Unfortunately it's on hold because the CEC framework has priority for me (and Cisco).

In addition, for drm Intel is working on color manager code as well (see the patch
series titled "Color Manager Implementation" at dri-devel). I would like to be able
to share the low-level matrix/vector calculation code with them. So I am waiting to
see how that turns out.

So quite some work has been done, but it's not ready for merging.

Regards,

	Hans
