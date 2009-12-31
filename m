Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45700 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbZLaPXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Dec 2009 10:23:47 -0500
Received: by bwz27 with SMTP id 27so7987671bwz.21
        for <linux-media@vger.kernel.org>; Thu, 31 Dec 2009 07:23:45 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Guillem =?utf-8?q?Sol=C3=A0_Aranda?= <garanda@flumotion.com>
Subject: Re: IR Receiver on an Tevii S470
Date: Thu, 31 Dec 2009 17:23:55 +0200
Cc: linux-media@vger.kernel.org
References: <200912120230.36902.liplianin@me.by> <1260637174.3085.3.camel@palomino.walls.org> <59335d7a0912310446q9b457a3u5cba0f60dfdd009e@mail.gmail.com>
In-Reply-To: <59335d7a0912310446q9b457a3u5cba0f60dfdd009e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200912311723.55794.liplianin@me.by>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 31 декабря 2009 14:46:49 Guillem Solà Aranda wrote:
> Hi,
>
> I have a s470 and with
>
> s2-liplianin-7212833be10d
> s2-liplianin-ab3a80e883ba
>
> began to work, but today I have tested
>
> s2-liplianin-b663b38d616f
>
> and seems that there are some problems trying to load the driver
>
> Linux video capture interface: v2.00
> cx23885: disagrees about version of symbol ir_codes_hauppauge_new_table
> cx23885: Unknown symbol ir_codes_hauppauge_new_table
> cx23885: disagrees about version of symbol ir_input_init
> cx23885: Unknown symbol ir_input_init
> cx23885: disagrees about version of symbol ir_input_nokey
> cx23885: Unknown symbol ir_input_nokey
> cx23885: disagrees about version of symbol ir_input_keydown
> cx23885: Unknown symbol ir_input_keydown
>
> I'm running this on a DELL Server with RHEL and kernel 2.6.31.
>
> regards,
> Guillem
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Since module ir-common.ko moved to IR directory just remove old one.

rm /lib/modules/$(uname -r)/kernel/drivers/media/common/ir-common.ko

Happy New Year!

