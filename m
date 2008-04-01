Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yw-out-2324.google.com ([74.125.46.31])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <knowledgejunkie@gmail.com>) id 1JgoTA-0005lv-8L
	for linux-dvb@linuxtv.org; Tue, 01 Apr 2008 23:56:41 +0200
Received: by yw-out-2324.google.com with SMTP id 5so281625ywh.41
	for <linux-dvb@linuxtv.org>; Tue, 01 Apr 2008 14:56:31 -0700 (PDT)
Message-ID: <5387cd30804011456h6ef9c46bu99d8c8290a33ca7a@mail.gmail.com>
Date: Tue, 1 Apr 2008 22:56:31 +0100
From: "Nick Morrott" <knowledgejunkie@gmail.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <9F2076E5-6941-444E-94D3-B4F174DA31FB@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <47EEE49F.4060202@andrei.myip.org>
	<9F2076E5-6941-444E-94D3-B4F174DA31FB@gmail.com>
Subject: Re: [linux-dvb] Hauppauge WinTV Nova-S Plus
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

On 30/03/2008, Timothy Parez <timothyparez@gmail.com> wrote:
> Hey,
>
> I got it working once.
> Then I had scanning problems,
> now I don't have scanning problems
>
> but szap -r "BBC THREE"     for example works,
> but doesn't put any data in /dev/dvb/adapter0
>
> So I get a lock, but no data.

Shouldn't you be using /dev/dvb/adapter0/dvr0 ?

If you have mplayer installed, try

$ mplayer /dev/dvb/adapter0/dvr0

whilst szap is running and has a channel lock

-- 
Nick Morrott

MythTV Official wiki:
http://mythtv.org/wiki/
MythTV users list archive:
http://www.gossamer-threads.com/lists/mythtv/users

"An investment in knowledge always pays the best interest." - Benjamin Franklin

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
