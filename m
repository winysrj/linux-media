Return-path: <mchehab@pedra>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46938 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab1B1RBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Feb 2011 12:01:45 -0500
Received: by bwz15 with SMTP id 15so3827745bwz.19
        for <linux-media@vger.kernel.org>; Mon, 28 Feb 2011 09:01:43 -0800 (PST)
From: "Igor M. Liplianin" <liplianin@me.by>
To: Andreas Oberritter <obi@linuxtv.org>
Subject: Re: [PATCH] Prof 7301: switching frontend to stv090x, fixing "LOCK FAILED" issue
Date: Mon, 28 Feb 2011 19:01:50 +0200
Cc: Mariusz Bialonczyk <manio@skyboo.net>, linux-media@vger.kernel.org
References: <4D3358C5.5080706@skyboo.net> <201102281741.26950.liplianin@me.by> <4D6BC8D4.3080001@linuxtv.org>
In-Reply-To: <4D6BC8D4.3080001@linuxtv.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201102281901.50579.liplianin@me.by>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

В сообщении от 28 февраля 2011 18:09:56 автор Andreas Oberritter написал:
> Hello Igor,
> 
> On 02/28/2011 04:41 PM, Igor M. Liplianin wrote:
> > В сообщении от 28 февраля 2011 13:37:01 автор Mariusz Bialonczyk написал:
> >> On 2011-01-16 21:44, Mariusz Bialonczyk wrote:
> >>> Fixing the very annoying tunning issue. When switching from DVB-S2 to
> >>> DVB-S, it often took minutes to have a lock.
> >>> 
> >>  > [...]
> >>> 
> >>> The patch is changing the frontend from stv0900 to stv090x.
> >>> The card now works much more reliable. There is no problem with
> >>> switching from DVB-S2 to DVB-S, tunning works flawless.
> >> 
> >> Igor, can I get your ACK on this patch?
> >> 
> >> regards,
> > 
> > Never.
> > Think first what you are asking for.
> 
> for those who aren't involved in the development of these drivers, may I
> ask you what's the problem with this patch?
For those who ...
He asked me to get rid of my driver. Why should I?
I have 7301, test it myself and see nothing bad with stv0900.
Obviously, I better patch stv0900 then convert the driver to stv090x.
And if you ask something then be prepaired to not be given smth.

Best Regards
Igor
> 
> Regards,
> Andreas

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks
