Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1911 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbZFQL1S (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 07:27:18 -0400
Message-ID: <16165.62.70.2.252.1245238018.squirrel@webmail.xs4all.nl>
Date: Wed, 17 Jun 2009 13:26:58 +0200 (CEST)
Subject: Re: Convert cpia driver to v4l2,
      drop parallel port version support?
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Andy Walls" <awalls@radix.net>
Cc: "Hans de Goede" <hdegoede@redhat.com>,
	"Linux Media Mailing List" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


> On Wed, 2009-06-17 at 09:43 +0200, Hans Verkuil wrote:
>
>> > I personally think that loosing support for the parallel port
>> > version is ok given that the parallel port itslef is rapidly
>> > disappearing, what do you think ?
>>
>> I agree wholeheartedly. If we remove pp support, then we can also remove
>> the bw-qcam and c-qcam drivers since they too use the parallel port.
>
> Maybe I just like keeping old hardware up and running, but...
>
> I think it may be better to remove camera drivers when a majority of the
> actual camera hardware is likely to reach EOL, as existing parallel
> ports will likely outlive the cameras.

For sure. But these are really old webcams with correspondingly very poor
resolutions. I haven't been able to track one down on ebay and as far as I
know nobody has one of these beasts to test with. I can't see anyone using
parallel port webcams. I actually wonder whether these drivers still work.
And converting to v4l2 without having the hardware is very hard indeed.

Regards,

         Hans

>
> My PC I got in Dec 2005 has a parellel port, as does the motherboard I
> purchased 2008.
>
> I have a 802.11g router (ASUS WL-500g) with a parallel port.  It works
> nicely as a remote print server.  From my perspective, that parallel
> port isn't going away anytime soon.
>
>
> <irrelevant aside>
> At least the custom firmware for the WL-500g
> ( http://oleg.wl500g.info/ ) has the ability to use webcams for snapping
> pictures and emailing away a notification.  I'm pretty sure PP webcams
> are not actually supported though.
>
> The wireless router surveillance case is probably not relevant though,
> as routers are usually using (very) old kernels.
> </irrelevant aside>
>
> -Andy
>
>


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG

