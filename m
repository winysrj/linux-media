Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58869 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126AbZJZQJm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Oct 2009 12:09:42 -0400
Received: by fxm18 with SMTP id 18so12199890fxm.37
        for <linux-media@vger.kernel.org>; Mon, 26 Oct 2009 09:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4AE5C7F9.6000502@iki.fi>
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
	 <4AE497B5.8050801@iki.fi>
	 <829197380910260836o4b17a65ex8c46d1db8d6d3027@mail.gmail.com>
	 <4AE5C7F9.6000502@iki.fi>
Date: Mon, 26 Oct 2009 12:09:45 -0400
Message-ID: <829197380910260909m42ed776bt56754b882d7ac426@mail.gmail.com>
Subject: Re: em28xx DVB modeswitching change: call for testers
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 26, 2009 at 12:02 PM, Antti Palosaari <crope@iki.fi> wrote:
> Is there any way to speed up Empia to handle streams bigger than ~45
> Mbit/sec?

Can you add a debug line that dumps out the values of register 0x01
and register 0x5d and then send me the values?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
