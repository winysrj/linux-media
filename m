Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f173.google.com ([209.85.192.173]:36835 "EHLO
        mail-pf0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753192AbcHWTwC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 15:52:02 -0400
Date: Tue, 23 Aug 2016 12:51:58 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Nick Dyer <nick@shmanahar.org>, Hans Verkuil <hverkuil@xs4all.nl>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Benson Leung <bleung@chromium.org>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Chris Healy <cphealy@gmail.com>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Andrew Duggan <aduggan@synaptics.com>,
        James Chen <james.chen@emc.com.tw>,
        Dudley Du <dudl@cypress.com>,
        Andrew de los Reyes <adlr@chromium.org>,
        sheckylin@chromium.org, Peter Hutterer <peter.hutterer@who-t.net>,
        Florian Echtler <floe@butterbrot.org>
Subject: Re: [PATCH v8 03/10] Input: atmel_mxt_ts - add support for T37
 diagnostic data
Message-ID: <20160823195158.GA6712@dtor-ws>
References: <1468876238-24599-1-git-send-email-nick@shmanahar.org>
 <1468876238-24599-4-git-send-email-nick@shmanahar.org>
 <20160823163047.0ba303cc@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160823163047.0ba303cc@vento.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 23, 2016 at 04:30:47PM -0300, Mauro Carvalho Chehab wrote:
> Hi Dmitry,
> 
> Em Mon, 18 Jul 2016 22:10:31 +0100
> Nick Dyer <nick@shmanahar.org> escreveu:
> 
> > Atmel maXTouch devices have a T37 object which can be used to read raw
> > touch deltas from the device. This consists of an array of 16-bit
> > integers, one for each node on the touchscreen matrix.
> 
> Is it ok to merge this patch (and the other patches on this series)
> via my tree?


Yes, please (I do not think I have any other Atmel changes pending).
Feel free to add my

Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Thanks.

-- 
Dmitry
