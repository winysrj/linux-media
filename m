Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45046 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031678AbbD2LfE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 29 Apr 2015 07:35:04 -0400
Date: Wed, 29 Apr 2015 13:35:01 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Jemma Denson <jdenson@gmail.com>
Subject: Re: [PULL] For 4.2 (or even 4.1?) add support for cx24120/Technisat
 SkyStar S2
Message-ID: <20150429133501.38eacfa0@dibcom294.coe.adi.dibcom.com>
In-Reply-To: <20150427214022.1ff9f61f@recife.lan>
References: <20150420092720.3cb092ba@dibcom294.coe.adi.dibcom.com>
	<20150427171628.5ba22752@recife.lan>
	<20150427232523.08c1c8f1@lappi3.parrot.biz>
	<20150427214022.1ff9f61f@recife.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 27 Apr 2015 21:40:22 -0300 Mauro Carvalho Chehab
<mchehab@osg.samsung.com> wrote:
> > Could we send an additional patch for coding-style or would you prefer
> > a new patch which has everything inside? This would maintain the
> > author-attribution of the initial commit.
> 
> An additional patch is fine.

I fixed the files cx24120.[ch] in a --strict manner. Do you want me to
send each of these patches to the list? They are not really
interesting. But if it might help to review for any obvious mistakes...

I rebased my tree on the media-tree of this morning.

I checked the fe_stat-stuff and I saw that you need to keep the old
unc, ber and snr functions anyway.

I doubt that the cx24120 in its current state reports anything useful
for statistical uses. Do you think there is an added value adding
it to a driver which is very simple in this regards?

Regarding the wait for channel-lock I think it could be written
differently using a state and checking in the get_status-function
whether it is locked for the first time. This will need testing. I
haven't done it yet.

regards,
--
Patrick.

