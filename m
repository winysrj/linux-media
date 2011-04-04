Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:13311 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab1DDLOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 07:14:35 -0400
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
Date: Mon, 4 Apr 2011 20:17:03 +0930
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org> <SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl> <BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 04/04/2011, at 20:01, Vincent McIntyre wrote:
Could you post the output of
>  lspci -vvv -nn
> for the device in question - you'll also need to give the -s argument,
> eg -s 02:00.0
> or whatever.
> 
> This is so it is clear what chips your example of the card is using -
> a given card may be implemented with different chipsets over time
> depending on how organised the manufacturer is.
> 
> Some kernel output similar to that shown on the wiki page, showing
> what happens at boot time, may be useful as well.
> 
> I have this card, and it is working reasonably well with recent
> media_build code:

I take it you use both tuners? I find I can only use one otherwise one of them hangs whatever app is using it.

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






