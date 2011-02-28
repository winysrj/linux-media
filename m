Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58185 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab1B1UhD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 15:37:03 -0500
Received: by bwz15 with SMTP id 15so4029154bwz.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 12:37:02 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mariusz Bialonczyk <manio@skyboo.net>
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK FAILED" issue
Date: Mon, 28 Feb 2011 22:37:07 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4D3358C5.5080706@skyboo.net> <201102281901.50579.liplianin@me.by> <4D6BFB6A.1090404@skyboo.net>
In-Reply-To: <4D6BFB6A.1090404@skyboo.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102282237.07948.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 28 февраля 2011 21:45:46 автор Mariusz Bialonczyk написал:
> On 02/28/2011 06:01 PM, Igor M. Liplianin wrote:
> > For those who ...
> > He asked me to get rid of my driver. Why should I?
> 
> Maybe because (now) your frontend has problems with tunning on this card?
> I though that references are known for you:
> 1.
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/24
> 573 2.
> http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/25
> 275 3. http://linuxdvb.org.ru/wbb/index.php?page=Thread&threadID=641
> 
> And to be more specific: I am not asking to get rid of your driver,
> my patch doesn't touch your stv0900 implementation, it only change the
> frontend for one particular card.
> 
> > I have 7301, test it myself and see nothing bad with stv0900.
> 
> If it is working for you - lucky you! But keep in mind that it it doesn't
> mean that it is working for others. Have you tested it with my patch
> applied? Besides it is not using your frontend, maybe it just *work*?
> 
> > Obviously, I better patch stv0900 then convert the driver to stv090x.
> 
> Sure, go ahead... I am only wondering why wasn't you so helpful when I was
> trying to contact you and offer debugging help when I discovered the
> problem after I started using this card. Your only response was:
> "I know this issue. Your card is fine."
> So now I resolved the problem myself and sent a working solution (tested
> by some people - always with good results) and you disagree now.
> 
> I'm only hoping that a hardware *usability* will win over an ego!
> 
> regards,
Sorry, I have nothing against you personally.
I have excuses, but you not intresting, I think.
Peace, friendship, chewing gum, like we use to say in my childhood :)

Switching to other driver not helps me, so be patient.

I patched stv0900 and send pull request.
Tested on Prof 7301, 7500, NetUP Dual DVB-S2, DVBWorld 2104 cards by myself.
With all of that vendors I have good relationships.

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
