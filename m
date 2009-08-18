Return-path: <linux-media-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.245]:9445 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbZHRUkj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 Aug 2009 16:40:39 -0400
Received: by an-out-0708.google.com with SMTP id d40so3555044and.1
        for <linux-media@vger.kernel.org>; Tue, 18 Aug 2009 13:40:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250627515.8322.2.camel@marc-desktop>
References: <1250627515.8322.2.camel@marc-desktop>
Date: Tue, 18 Aug 2009 16:40:40 -0400
Message-ID: <829197380908181340i15f86cf5n99fc5757d8fff7b8@mail.gmail.com>
Subject: Re: Winfast TV USB 2
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Marc Arndt <arndt.marc@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Aug 18, 2009 at 4:31 PM, Marc Arndt<arndt.marc@gmail.com> wrote:
> Good day,
>
> I see the following when I plug in my Winfast TV USB 2 card, can you
> please assist? The correct card is card 7
>
> Sincerely,
>
> Marc

Hello Marc,

Do you actually know that the card=7 modprobe option works?  The
device profile for card 7 has a valid USB ID (0413:6023), suggesting
that you might have a different version of the board.

Can you take the unit apart and take some hi-resolution pictures of
the PCB?  That will tell us whether it is actually the same hardware.

Devin


-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
