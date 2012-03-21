Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52412 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab2CUSyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Mar 2012 14:54:35 -0400
Received: by yenl12 with SMTP id l12so1236955yen.19
        for <linux-media@vger.kernel.org>; Wed, 21 Mar 2012 11:54:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1332291909.26972.3.camel@palomino.walls.org>
References: <CALF0-+U+H=mycbcWYP8J9+5TsGCA8NdBWC7Ge7xJ11F3Q6=j=g@mail.gmail.com>
	<1332291909.26972.3.camel@palomino.walls.org>
Date: Wed, 21 Mar 2012 15:54:34 -0300
Message-ID: <CALF0-+Wz9Gn0PUqDyeFkK36QGu9HNVm3SUfaGrpvsit==BKvkA@mail.gmail.com>
Subject: Re: [Q] v4l buffer format inside isoc
From: =?ISO-8859-1?Q?Ezequiel_Garc=EDa?= <elezegarcia@gmail.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2012/3/20 Andy Walls <awalls@md.metrocast.net>:

>
> Section 8.10 of the SAA7113 data sheet shows 16 "data formats".  The
> interesting one for video is #15 Y:U:V 4:2:2.

Thanks. Perhaps, I should have done my homework.

>
> The EM28xx chip programming might rearrange some data, but I have no
> knowledge or experience with the eMPIA chips.

The chip is not eMPIA, but rather stk1160. It's a new chipset that's not
currently supported (there is a similar one in stk-webcam).
