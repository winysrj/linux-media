Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54114 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406Ab3GUNMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Jul 2013 09:12:51 -0400
Received: by mail-wg0-f49.google.com with SMTP id a12so5053456wgh.28
        for <linux-media@vger.kernel.org>; Sun, 21 Jul 2013 06:12:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1307211144440.10557@axis700.grange>
References: <CA+V-a8uDrtsRrtKh9ac+S70C2ycGZcpqXCsOLgEr4nCwBPNCHw@mail.gmail.com>
 <51EBA8BF.7030303@gmail.com> <Pine.LNX.4.64.1307211144440.10557@axis700.grange>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sun, 21 Jul 2013 18:42:29 +0530
Message-ID: <CA+V-a8sCcAGnLCZsAEq3Jb9jcyBf4kyo+ruEphcDLJEx99XXLg@mail.gmail.com>
Subject: Re: Few Doubts on adding DT nodes for bridge driver
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Sun, Jul 21, 2013 at 3:17 PM, Guennadi Liakhovetski
<g.liakhovetski@gmx.de> wrote:
> On Sun, 21 Jul 2013, Sylwester Nawrocki wrote:
>
[snip]
>> >                             remote =<&tvp514x_2>;
>
> BTW, just occurred to me: shouldn't also these rather be
> "remote-endpoint?" The documentation example should then be fixed too.
>
Ah correct I was referring the same and added in the 'remote' in device node.
Shall I go ahead and post a patch fixing it ?

>> >                     };
>> >             };
>> >     };
>>
>> Are tvp514x@5c and tvp514x@5d decoders really connected to same bus, or are
>> they on separate busses ? If the latter then you should have 2 'port' nodes.
>> And in such case don't you need to identify to which
>>
>> > I have added two endpoints for the bridge driver. In the bridge driver
>> > to build the pdata from DT node,I do the following,
>> >
>> > np = v4l2_of_get_next_endpoint(pdev->dev.of_node, NULL);
>> >
>> > The above will give the first endpoint ie, endpoint@1
>> >  From here is it possible to get the tvp514x_1 endpoint node and the
>> > parent of it?
>>
>> Isn't v4l2_of_get_remote_port_parent() what you need ?
>
> Right, forgot we've got a helper for that already.
>
Yes this works for me now thank :)

Regards,
--Prabhakar Lad
