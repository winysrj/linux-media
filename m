Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:64401 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945916Ab2KNXS6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 14 Nov 2012 18:18:58 -0500
Received: by mail-wg0-f42.google.com with SMTP id fm10so2897052wgb.1
        for <linux-media@vger.kernel.org>; Wed, 14 Nov 2012 15:18:56 -0800 (PST)
Subject: Re: Regarding bulk transfers on stk1160
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Michael Hartup <michael.hartup@gmail.com>
In-Reply-To: <CALF0-+Xt4bEgXHYV3-4pX4q95yJONsOQvg3wKhKvO-g5mdV8Lw@mail.gmail.com>
Date: Wed, 14 Nov 2012 23:18:54 +0000
Cc: Greg KH <greg@kroah.com>,
	linux-media <linux-media@vger.kernel.org>,
	linux-rpi-kernel@lists.infradead.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <61FF45D8-A60A-432B-A735-8A050A8C4A49@gmail.com>
References: <CALF0-+XthyGJ-LzovTxLAKmMBif-YkLnNNcQBJvtnqTua+Ktag@mail.gmail.com> <20121113145809.GA15029@kroah.com> <CALF0-+Xt4bEgXHYV3-4pX4q95yJONsOQvg3wKhKvO-g5mdV8Lw@mail.gmail.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On 14 Nov 2012, at 22:53, Ezequiel Garcia wrote:

> Hi Greg,
> 
> On Tue, Nov 13, 2012 at 11:58 AM, Greg KH <greg@kroah.com> wrote:
>> 
>> Or better yet, buy a board with a working USB port, like a BeagleBone or
>> the like :)
>> 
> 
> Michael Hartup (the interested user) *has* a beaglebone.
> 
> I'm trying to help him getting it ready for stk1160.
> However, Michael is getting choppy video capture.
> (dmesg doesn't show anything relevant)
> 
> @Michael, could you upload those captures somewhere
> and post the links for everyone to see?

> 
> Is this related to beaglebone's known usb dma issues?
> 
> https://github.com/RobertCNelson/linux-dev/issues/2
> https://groups.google.com/forum/?fromgroups=#!topic/beagleboard/J94PUlo0wzs
> 
> Unfortunately, I don't own a beaglebone (and I can't afford one right now)
> so I can't really see for myself what's going on.
> 
> Any help, greatly appreciated.
> 
>    Ezequiel



Thanks for looking at this gentlemen. I have posted some examples here;

http://bufobufomagic.blogspot.co.uk/2012/11/image-corruption-on-beaglebone-with.html


Michael.