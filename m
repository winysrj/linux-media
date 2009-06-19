Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f212.google.com ([209.85.220.212]:52038 "EHLO
	mail-fx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbZFSMFP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jun 2009 08:05:15 -0400
Received: by fxm8 with SMTP id 8so7881fxm.37
        for <linux-media@vger.kernel.org>; Fri, 19 Jun 2009 05:05:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200906191343.59596.hverkuil@xs4all.nl>
References: <4A3B7851.6080008@gmx.de> <200906191343.59596.hverkuil@xs4all.nl>
Date: Fri, 19 Jun 2009 14:05:16 +0200
Message-ID: <268161120906190505v4100f87eh68b8b9e774aa32e9@mail.gmail.com>
Subject: Re: ivtv && Radio Data System (RDS) - is there something
	planned/already available
From: Edouard Lafargue <edouard@lafargue.name>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: wk <handygewinnspiel@gmx.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jun 19, 2009 at 1:43 PM, Hans Verkuil<hverkuil@xs4all.nl> wrote:
> On Friday 19 June 2009 13:36:49 wk wrote:
>> Is there anything planned/ongoing to support Radio Data System (RDS)
>> with ivtv supported cards?
>> Would be quite helpful for analogue radio channel scanning and finding
>> the matching channel names.
>> Is there something out to be tested?
>
> As far as I know there are no ivtv-based cards with RDS functionality. If
> you have one that can do RDS under Windows, then please let me know and I
> can take a look.

  A workaround can be to use a 10$ USB radio with RDS support and use
it as a secondary (silent) tuner for doing the scanning operations in
the background, so that you can have a fully up to date radio stations
list all the time without impacting the listening of your main radio
tuner - works very well!

Ed
