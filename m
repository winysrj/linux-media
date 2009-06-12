Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:33378 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753442AbZFLGuZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 02:50:25 -0400
Message-ID: <4A31FB0A.8030104@redhat.com>
Date: Fri, 12 Jun 2009 08:51:54 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Erik de Castro Lopo <erik@bcode.com>
CC: linux-media@vger.kernel.org
Subject: Re: GPL code for Omnivision USB video camera available.
References: <20090612110228.3f7e42ab.erik@bcode.com>
In-Reply-To: <20090612110228.3f7e42ab.erik@bcode.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 06/12/2009 03:02 AM, Erik de Castro Lopo wrote:
> Hi all,
>
> I have a driver for a USB video camera that I'd like to see added to
> the mainline kernel, mainly so I don't have to fix breakage due to
> constant changes in the kernel :-).
>
> The code is GPL and is available here:
>
>      http://stage.bcode.com/erikd/ovcamchip
>
> and the history of this code is here:
>
>      http://stage.bcode.com/erikd/ovcamchip/README
>
> My problem is that I am way too busy to sheperd this into the kernel
> myself. If someone is willing to work on getting this in, I can send
> them a camera to keep. If getting paid is more likely to help someone
> focus on the task then that is also a possibility.
>
> Any takers? Please email me privately.
>

This looks to me like its just ov51x-jpeg made to compile with the
latest kernel. Did you make any functional changes?

Note that ov51x-jpeg is not acceptable as is as it does in kernel
decompression of the ov51x jpeg-like compression format.

I'm currently finishing up adding ov511(+) and ov518(+) support
to the gspca ov519 subdriver. And I've already added support for
decompressing their format in userspace to libv4l.

Also I wonder if you're subscribed to the (low trafic) ov51x-jpeg
mailinglist, that seems to be the right thing todo for someone who tries
to get that driver in to the mainline. I've already announced my
work on getting the ov511(+) and ov518(+) supported properly in the
mainline kernel there.

May I ask what cam you have? I could certainly use more people testing
this.

Regards,

Hans
