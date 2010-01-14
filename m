Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:60089 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411Ab0ANWJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2010 17:09:16 -0500
Received: by fxm25 with SMTP id 25so27869fxm.21
        for <linux-media@vger.kernel.org>; Thu, 14 Jan 2010 14:09:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B4F9408.2060901@rogers.com>
References: <753580.52410.qm@web32707.mail.mud.yahoo.com>
	 <4B4F9408.2060901@rogers.com>
Date: Thu, 14 Jan 2010 17:09:14 -0500
Message-ID: <829197381001141409i6b666e78t175aadf31fd93b68@mail.gmail.com>
Subject: Re: Kworld 315U and SAA7113?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: CityK <cityk@rogers.com>
Cc: Franklin Meng <fmeng2002@yahoo.com>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jan 14, 2010 at 5:00 PM, CityK <cityk@rogers.com> wrote:
> Franklin Meng wrote:
>> As far as I can tell, the Kworld 315U is the only board that uses this combination of parts..  Thomson tuner, LG demod, and SAA7113.  I don't think any other device has used the SAA7113 together with a digital demod.  Most products seem to only have the SAA711X on an analog only board.  Since I don't have any other USB adapters with the SAA chip I was unable to do any further testing on the SAA code changes.
>>
>
> IIRC, a couple of the Sasem/OnAir devices use a saa7113 together with a
> digital demod. I seem to also recall something else, though maybe I'm
> mistaken.

I'm actually not really concerned about it's interaction with a demod.
 I'm more worried about other products that have saa711[345] that use
a bridge other than em28xx.  The introduction of power management
could always expose bugs in those bridges (I had this problem in
several different cases where I had to fix problems in other drivers
because of the introduction of power management).

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
