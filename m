Return-path: <mchehab@pedra>
Received: from cain.gsoft.com.au ([203.31.81.10]:39623 "EHLO cain.gsoft.com.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790Ab1DDW5o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Apr 2011 18:57:44 -0400
Subject: Re: [linux-dvb] DVICO HDTV Dual Express2
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: "Daniel O'Connor" <darius@dons.net.au>
In-Reply-To: <BANLkTimBYhq_Ag3nkU1105Em0-AXvMiQbQ@mail.gmail.com>
Date: Tue, 5 Apr 2011 08:27:03 +0930
Cc: linux-media@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <B6690ADE-0D4F-4E22-8AB2-DB68AD43E749@dons.net.au>
References: <mailman.466.1301890961.26790.linux-dvb@linuxtv.org> <SNT124-W658C9CDE54575A79B73D6FACA30@phx.gbl> <BANLkTimEtbx6HkqBQLBTc7XX_wEYgs7fJg@mail.gmail.com> <F8BDDD6D-6870-4291-99C9-D8FCABFEEB05@dons.net.au> <BANLkTimBYhq_Ag3nkU1105Em0-AXvMiQbQ@mail.gmail.com>
To: Vincent McIntyre <vincent.mcintyre@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


On 05/04/2011, at 8:18, Vincent McIntyre wrote:
> On 4/4/11, Daniel O'Connor <darius@dons.net.au> wrote:
>> 
>> I take it you use both tuners? I find I can only use one otherwise one of
>> them hangs whatever app is using it.
>> 
> 
> I do. I haven't tested very carefully that I can use both tuners at
> once successfully but I am pretty sure there have been times when both
> have been running. I only use them with mythtv,
> unless I am testing something like new v4l modules and in that case I
> just use one tuner at a time.
> 
> The box has two tuner cards, and this one is usually the second one in
> the enumeration.

OK. I only have the one (dual tuner) card but I find that if I enable it mythtv eventually hangs opening one of them.

Perhaps the recent locking changes for that driver will help..

--
Daniel O'Connor software and network engineer
for Genesis Software - http://www.gsoft.com.au
"The nice thing about standards is that there
are so many of them to choose from."
  -- Andrew Tanenbaum
GPG Fingerprint - 5596 B766 97C0 0E94 4347 295E E593 DC20 7B3F CE8C






