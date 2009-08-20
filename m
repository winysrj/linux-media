Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:35737 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbZHTW3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Aug 2009 18:29:15 -0400
Received: by fxm17 with SMTP id 17so186637fxm.37
        for <linux-media@vger.kernel.org>; Thu, 20 Aug 2009 15:29:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <37219a840908201516p23f5164fs98ad7f8267362d85@mail.gmail.com>
References: <4A8C076C.8040109@deuromedia.com>
	 <37219a840908201516p23f5164fs98ad7f8267362d85@mail.gmail.com>
Date: Thu, 20 Aug 2009 18:29:15 -0400
Message-ID: <829197380908201529u4a41c87akf685bc599e481c41@mail.gmail.com>
Subject: Re: V4L-DVB issue in systems with >4Gb RAM?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Michael Krufky <mkrufky@kernellabs.com>
Cc: h.ungar@deuromedia.com,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Manfred Petz <m.petz@deuromedia.com>,
	Gerhard Achs <g.achs@deuromedia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Aug 20, 2009 at 6:16 PM, Michael Krufky<mkrufky@kernellabs.com> wrote:
> I have a server with three cx23885-based PCI-E boards, one of them
> single tuner, the other two with dual tuners.  This server has 8G RAM.
>  The single tuner is a Hauppauge board and the dual tuners are DViCO
> boards.  (I chose this setup for maximum tuner capacity and brand
> diversity for the sake of testing -- I plan to replace the DViCO
> boards with two HVR2250's)
>
> So, in summary, my 8G system has five digital tuners and I am not
> experiencing the problems that you report.  I doubt the issue is
> within the v4l-dvb subsystem.
>
> Good luck,
>
> Mike Krufky

Someone on v4l yesterday similarly reported a case where the driver
only started to work when switched from the PAE kernel to the non-PAE.
 Perhaps the two issues are related.

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
