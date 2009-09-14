Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62156 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754210AbZINU5T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Sep 2009 16:57:19 -0400
Received: by bwz19 with SMTP id 19so2379254bwz.37
        for <linux-media@vger.kernel.org>; Mon, 14 Sep 2009 13:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.0909142211120.4359@axis700.grange>
References: <200908220850.07435.marek.vasut@gmail.com>
	 <200909141829.55485.marek.vasut@gmail.com>
	 <Pine.LNX.4.64.0909142128020.4359@axis700.grange>
	 <200909142202.46154.marek.vasut@gmail.com>
	 <Pine.LNX.4.64.0909142211120.4359@axis700.grange>
Date: Mon, 14 Sep 2009 16:57:21 -0400
Message-ID: <30353c3d0909141357g13506670j828a582d69d5c99c@mail.gmail.com>
Subject: Re: V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV9640
	sensor
From: David Ellingsworth <david@identd.dyndns.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Marek Vasut <marek.vasut@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Sep 14, 2009 at 4:30 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Mon, 14 Sep 2009, Marek Vasut wrote:
>
>> Dne Po 14. září 2009 21:29:26 Guennadi Liakhovetski napsal(a):
>> > From: Marek Vasut <marek.vasut@gmail.com>
>> >
>> > Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
>> > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
>> > ---
>> >
>> > Marek, please confirm, that this version is ok. I'll push it upstream for
>> > 2.6.32 then.
>>
>> No, it's not OK. You removed the RGB part. Either enclose those parts into ifdef
>> OV9640_RGB_BUGGY or preserve it in some other way. Someone will certainly want
>> to re-add RGB parts later and will have to figure it out all over again.
>
> Ok, make a proposal, how you would like to see it. But - I do not want
> commented out code, including "#ifdef MACRO_THAT_DOESNT_GET_DEFINED." I
> think, I described it in sufficient detail, so that re-adding that code
> should not take longer than 10 minutes for anyone sufficiently familiar
> with the code. Referencing another driver also has an advantage, that if
> we switch to imagebus or any other API, you don't get stale commented out
> code, but you look up updated code in a functional driver. But I am open
> to your ideas / but no commented out code, please.
>

I don't know much about this driver, but here's my $0.02. Since the
RGB code has known issues and this is a new driver, it is probably
best to submit it without the code for RGB support. As is, even
without direct support from the driver, users can retrieve RGB data
from the camera using libv4l. Your argument is therefore more or less
mute. If someone were to want to add RGB support to the driver, I'm
sure they'd prefer to have a clean and functional driver to work with
rather than wading through a bunch of dead/broken code.

Regards,

David Ellingsworth
