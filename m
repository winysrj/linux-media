Return-path: <linux-media-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.184]:27800 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbZKIQt6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 Nov 2009 11:49:58 -0500
Received: by gv-out-0910.google.com with SMTP id r4so255050gve.37
        for <linux-media@vger.kernel.org>; Mon, 09 Nov 2009 08:50:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <cd9524450911082159p39f922b9r73d731b62789e7a8@mail.gmail.com>
References: <cd9524450911081743y92a616amfcb8c6c069112240@mail.gmail.com>
	 <829197380911081752x707d9e2bs99f4dc044544d66f@mail.gmail.com>
	 <cd9524450911081801i5e8d97f4nd5864d46a66c676e@mail.gmail.com>
	 <829197380911081834v445d36c1yd931c5af69a21505@mail.gmail.com>
	 <cd9524450911081958v57b77d27iae3ab37ffef1ee8d@mail.gmail.com>
	 <829197380911082006s5a575789rd1e2881e874177cd@mail.gmail.com>
	 <cd9524450911082035j7fa14b75q2b9edcdb1b1e85c3@mail.gmail.com>
	 <829197380911082047i5111615eo9e900290455b81dd@mail.gmail.com>
	 <cd9524450911082117h632bc437t28124ba727e7f915@mail.gmail.com>
	 <cd9524450911082159p39f922b9r73d731b62789e7a8@mail.gmail.com>
Date: Mon, 9 Nov 2009 11:50:02 -0500
Message-ID: <829197380911090850m21f6aceewfd30a56bda8af4ef@mail.gmail.com>
Subject: Re: bisected regression in tuner-xc2028 on DVICO dual digital 4
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Barry Williams <bazzawill@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 9, 2009 at 12:59 AM, Barry Williams <bazzawill@gmail.com> wrote:
> I appear to be good at doing silly things I of course forgot I
> unplugged the antenna cable from my first box to watch normal tv so
> that is why it is not tuning. However now my rev 1 tuner appears to no
> longer be working mythtv says it is asleep here is the output from
> dmesg.

Could you please clarify what you mean?  Are you saying that the patch
for the 0fe9:db78 device does not work?  And what do you mean by
"mythtv says it is asleep"?  Can you please provide an exact error
message?

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
