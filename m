Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38297 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752925AbeBEQ1R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 5 Feb 2018 11:27:17 -0500
Subject: Re: Please help test the new v4l-subdev support in v4l2-compliance
To: Tim Harvey <tharvey@gateworks.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <be1babc7-ed0b-8853-19e8-43b20a6f4c17@xs4all.nl>
 <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <ea5892a3-9fe3-953f-c16c-55329d5d2f76@xs4all.nl>
Date: Mon, 5 Feb 2018 17:27:11 +0100
MIME-Version: 1.0
In-Reply-To: <CAJ+vNU12FEWf6+FUdsYjJhjxZbiBmjR6RurNc4W-xC-ZsMTp+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/2018 05:21 PM, Tim Harvey wrote:

<snip>

> 
> I ran a 'make distclean; ./bootstrap.sh && ./configure && make'
> 
> last version I built successfully was '1bb8c70 v4l2-ctl: mention that
> --set-subdev-fps is for testing only'

That's a lot of revisions ago. I've been busy last weekend :-)

Do a new git pull and try again. I remember hitting something similar during
the weekend where I was missing a C++ include.

> 
> I haven't dug into the failure at all. Are you using something new
> with c++ requiring a new lib or specific version of something that
> needs to be added to configure?

Nope, bog standard C++. Real C++ pros are probably appalled by the code.

Regards,

	Hans
