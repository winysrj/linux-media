Return-path: <mchehab@pedra>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53501 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab1DDWst (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 18:48:49 -0400
Received: by eyx24 with SMTP id 24so1919394eyx.19
        for <linux-media@vger.kernel.org>; Mon, 04 Apr 2011 15:48:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org>
	<SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl>
	<BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
	<F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au>
Date: Tue, 5 Apr 2011 08:48:47 +1000
Message-ID: <BANLkTimBYhq_Ag3nkU1105Em0-AXvMiQbQ@mail.gmail.com>
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
From: Vincent McIntyre <vincent.mcintyre@gmail.com>
To: "Daniel O'Connor" <darius@dons.net.au>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 4/4/11, Daniel O'Connor <darius@dons.net.au> wrote:
>
> I take it you use both tuners? I find I can only use one otherwise one of
> them hangs whatever app is using it.
>

I do. I haven't tested very carefully that I can use both tuners at
once successfully but I am pretty sure there have been times when both
have been running. I only use them with mythtv,
unless I am testing something like new v4l modules and in that case I
just use one tuner at a time.

The box has two tuner cards, and this one is usually the second one in
the enumeration.
