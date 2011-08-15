Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp23.services.sfr.fr ([93.17.128.22]:28916 "EHLO
	smtp23.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab1HOTq5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2011 15:46:57 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2314.sfr.fr (SMTP Server) with ESMTP id 02CC4700055E
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 21:46:55 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (108.98.30.93.rev.sfr.net [93.30.98.108])
	by msfrf2314.sfr.fr (SMTP Server) with SMTP id AE831700055C
	for <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 21:46:54 +0200 (CEST)
Received: FROM [192.168.1.62] ([192.168.1.62])
	BY smtp-in.softsystem.co.uk [93.30.98.108] (SoftMail 1.0.6, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Mon, 15 Aug 2011 21:46:52 +0200
Subject: Re: [mythtv-users] Anyone tested the DVB-T2 dual tuner TBS6280?
From: Lawrence Rust <lvr@softsystem.co.uk>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Discussion about MythTV <mythtv-users@mythtv.org>,
	linux-media@vger.kernel.org
In-Reply-To: <3976b67f-b55f-44c2-99fe-ef3968105563@email.android.com>
References: <CAC3jWv+c1HOqmo0B18Z3vWOwjr=RoPrN7sfR3bqzz4Tw7=fPAQ@mail.gmail.com>
	 <1313226504.2840.22.camel@gagarin>
	 <CAC3jWvLszU4gTSVW0mXUFrhnHCpPWRUqErytF9jXs39sbCJd3Q@mail.gmail.com>
	 <1313400289.1648.22.camel@gagarin>
	 <3976b67f-b55f-44c2-99fe-ef3968105563@email.android.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 21:46:51 +0200
Message-ID: <1313437611.18940.11.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2011-08-15 at 06:19 -0400, Andy Walls wrote:
> One of the bigger problems with the cx23885 driver and hardware was that things don't appear to work well with MSI enabled in the driver.  Hack your version of the driver to make sure MSI is not enabled for CX2388[578] chips.
> 
> As far as the unclearable IR interrupt with MSI disabled, I've only seen that with the CX23885 on nonHauppauge cards; the CX23888 seems to be ok.  I'm sure the problem on nonHauppauge cards is simply me no knowing for sure how some of the pins on the CX23885 were wired up.

Thanks for your pointers on the pitfalls and CX25840 similarity.  That
helps considerably.

Progressing well at present.  Will keep you posted.

How would it stand legally etc if I posted a patch to this list to
support the tbs6981?  Two possible scenarios:

1. Referencing, but not requiring, a blob module built from from TBS's
tuner FE object file that they distribute.
2. Using a reversed engineered FE driver.

-- 
Lawrence


