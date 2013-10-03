Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f172.google.com ([209.85.192.172]:48000 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3JCPOb (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 3 Oct 2013 11:14:31 -0400
Received: by mail-pd0-f172.google.com with SMTP id z10so2606647pdj.3
        for <linux-media@vger.kernel.org>; Thu, 03 Oct 2013 08:14:30 -0700 (PDT)
Message-ID: <524DEC22.5090107@gmail.com>
Date: Fri, 04 Oct 2013 00:13:54 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@iki.fi>
CC: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, a.hajda@samsung.com
Subject: Re: [PATCH v2 1/4] media: Add pad flag MEDIA_PAD_FL_MUST_CONNECT
References: <1380755873-25835-1-git-send-email-sakari.ailus@iki.fi> <524CD39B.9020400@samsung.com> <20131003084301.GM3022@valkosipuli.retiisi.org.uk> <1797993.sG828KdLkP@avalon>
In-Reply-To: <1797993.sG828KdLkP@avalon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 10/03/2013 11:40 AM, Laurent Pinchart wrote:
>>>>> Documentation/DocBook/media/v4l/media-ioc-enum-links.xml |   10 ++++++
>>>>> >  >  >>    include/uapi/linux/media.h                               |    1 +
>>>>> >  >  >>    2 files changed, 11 insertions(+)
>>>>> >  >  >>
>>>>> >  >  >>  diff --git a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>>>>> >  >  >>  b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml index
>>>>> >  >  >>  355df43..e357dc9 100644
>>>>> >  >  >>  --- a/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>>>>> >  >  >>  +++ b/Documentation/DocBook/media/v4l/media-ioc-enum-links.xml
>>>>> >  >  >>  @@ -134,6 +134,16 @@
>>>>> >  >  >>    	<entry>Output pad, relative to the entity. Output pads source
>>>>> >  >  >>    	data and are origins of links.</entry>
>>>>> >  >  >>    	</row>
>>>>> >  >  >>  +	<row>
>>>>> >  >  >>  +	<entry><constant>MEDIA_PAD_FL_MUST_CONNECT</constant></entry>
>>>>> >  >  >>  +	<entry>If this flag is set and the pad is linked to any other
>>>>> >  >  >>  +	    pad, then at least one of those links must be enabled for the
>>>>> >  >  >>  +	    entity to be able to stream. There could be temporary reasons
>>>>> >  >  >>  +	    (e.g. device configuration dependent) for the pad to need
>>>>> >  >  >>  +	    enabled links even when this flag isn't set; the absence of the
>>>>> >  >  >>  +	    flag doesn't imply there is none. The flag has no effect on pads
>>>>> >  >  >>  +	    without connected links.</entry>
>>> >  >
>>> >  >  Probably MEDIA_PAD_FL_MUST_CONNECT name is fine, but isn't it more
>>> >  >  something like MEDIA_PAD_FL_NEED_ACTIVE_LINK ? Or presumably
>>> >  >  MEDIA_PAD_FL_MUST_CONNECT just doesn't make sense on pads without
>>> >  >  connected links and should never be set on such pads ? From the last
>>> >  >  sentence it feels the situation where a pad without a connected link has
>>> >  >  this flags set is allowed and a valid configuration.
>
> If I'm not mistaken, that's a valid configuration. The flag merely says that,
> if a pad has any link, then one of them must be active (Sakari, please correct
> me if I'm wrong).

It may be valid but it just sounds odd to me. Since the pad without a link
cannot be connected to anything, how could setting MUST_CONNECT flag on 
it be
logical ? :) I think it's more about name of the flag, since its semantics
seems very well described.

>>> >  >  Perhaps the last sentence should be something like:
>>> >  >
>>> >  >  "The flag should not be used on pads without connected links and has no
>>> >  >  effect on such pads."
>> >
>> >  Hmm. Good question. My assumption was that such cases might appear when an
>> >  external entity could be connected to the pad, but receivers typically have
>> >  just a single pad. So streaming would be out of question in such case
>> >  anyway. But my thought was that we shouldn't burden drivers by forcing them
>> >  to unset the flag if there happens to be nothing connected to an entity.
>> >
>> >  How about just that I remove the last sentence, and s/ and the pad is linked
>> >  to any other pad, then at least one of those links must be enabled/, the
>> >  pad must be connected by an enabled link/?:-)

I guess removing the last sentence could be enough, IMHO it's pretty 
clear also
without this sentence the MEDIA_PAD_FL_MUST_CONNECT flag is meaningless 
on a pad
without links.

>> >  The purpose is two-fold: to allow automated pipeline validation and also
>> >  hint the user what are the conditions for that configuration.

Regards,
Sylwester
