Return-path: <linux-media-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:49626 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075AbZFVRdr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Jun 2009 13:33:47 -0400
Message-ID: <2840372.1245692029927.JavaMail.root@elwamui-ovcar.atl.sa.earthlink.net>
Date: Mon, 22 Jun 2009 10:33:49 -0700 (GMT-07:00)
From: whelky-82852@mypacks.net
To: Steven Toth <stoth@kernellabs.com>, whelky-82852@mypacks.net
Subject: Re: Hauppauge HVR-1250 IR Support? (CX23885)
Cc: linux-media@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



-----Original Message-----
>From: Steven Toth <stoth@kernellabs.com>
>Sent: Jun 22, 2009 7:29 AM
>To: whelky-82852@mypacks.net
>Cc: linux-media@vger.kernel.org
>Subject: Re: Hauppauge HVR-1250 IR Support? (CX23885)
>
>whelky-82852@mypacks.net wrote:
>> I was wondering if anyone is working on IR support for this card? I looked through cx23885-cards.c and its not supported.
>> 
>> 627         switch (dev->board) {
>> 628         case CX23885_BOARD_HAUPPAUGE_HVR1250:
>> 629         case CX23885_BOARD_HAUPPAUGE_HVR1500:
>> 630         case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
>> 631         case CX23885_BOARD_HAUPPAUGE_HVR1800:
>> 632         case CX23885_BOARD_HAUPPAUGE_HVR1200:
>> 633         case CX23885_BOARD_HAUPPAUGE_HVR1400:
>> 634                 /* FIXME: Implement me */
>> 635                 break;
>
>Not currently.
>
>-- 
>Steven Toth - Kernel Labs
>http://www.kernellabs.com

Thanks for reply.

Are there some roadblocks that make this card different from others that are supported? Is is possible to take a working driver and tweak/hack it, or is it way more complex that that?

Thanks!
