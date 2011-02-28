Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37123 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab1B1XRU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 18:17:20 -0500
Received: by bwz15 with SMTP id 15so4146918bwz.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 15:17:19 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mariusz Bialonczyk <manio@skyboo.net>
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK FAILED" issue
Date: Tue, 1 Mar 2011 01:17:28 +0200
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>
References: <4D3358C5.5080706@skyboo.net> <201102282237.07948.liplianin@me.by> <4D6C20A0.40705@skyboo.net>
In-Reply-To: <4D6C20A0.40705@skyboo.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103010117.28411.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 1 марта 2011 00:24:32 автор Mariusz Bialonczyk написал:
> On 02/28/2011 09:37 PM, Igor M. Liplianin wrote:
> > Sorry, I have nothing against you personally.
> 
> me too :)
> 
> > I have excuses, but you not intresting, I think.
> > Peace, friendship, chewing gum, like we use to say in my childhood :)
> > 
> > Switching to other driver not helps me, so be patient.
> > 
> > I patched stv0900 and send pull request.
> 
> I've tested it - and for the first sight it seems that it indeed
> solves the problem. Thank you :)
> 
> And about frontend: I think I found a solution which I hope will
> satisfy all of us. I think it would be great if user have
> an alternative option to use stv090x frontend anyway. I mean your
> frontend as default, but a module parameter which enables using
> stv090x instead of stv0900 (enabling what's is inside my patch).
> This will be a flexible solution which shouldn't harm anyone,
> but instead gives an option.
> 
> Igor, Mauro, do you have objections against this solution?
> If you agree, then I'll try to prepare an RFC patch for that.
Well, I didn't change my mind.
There is not an option, but splitting efforts in two ways.

> 
> regards,

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
