Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp7.mail.ru ([94.100.176.52]:37786 "EHLO smtp7.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752906Ab1GWPT0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Jul 2011 11:19:26 -0400
Message-ID: <4E2AE55D.4010107@list.ru>
Date: Sat, 23 Jul 2011 19:14:37 +0400
From: Stas Sergeev <stsp@list.ru>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org
Subject: Re: [patch][saa7134] do not change mute state for capturing audio
References: <4E19D2F7.6060803@list.ru> <4E1E8108.3060305@list.ru> <4E1F9A25.1020208@infradead.org> <4E22AF12.4020600@list.ru> <4E22CCC0.8030803@infradead.org> <4E24BEB8.4060501@redhat.com> <4E257FF5.4040401@infradead.org> <4E258B60.6010007@list.ru> <4E25906D.3020200@infradead.org> <4E259B0C.90107@list.ru> <4E25A26A.2000204@infradead.org> <4E25A7C2.3050609@list.ru> <4E25C7AE.5020503@infradead.org> <4E25CF35.7000802@list.ru> <4E25DB37.8020609@infradead.org> <4E25FDE4.7040805@list.ru> <4E262772.9060509@infradead.org> <4E266799.8030706@list.ru> <4E26AEC0.5000405@infradead.org> <4E26B1E7.2080107@list.ru> <4E26B29B.4010109@infradead.org> <4E292BED.60108@list.ru> <4E296D00.9040608@infradead.org> <4E296F6C.9080107@list.ru> <4E2971D4.1060109@infradead.org> <4E29738F.7040605@list.ru> <4E297505.7090307@infradead.org> <4E29E02A.1020402@list.ru> <4E2A23C7.3040209@infradead.org> <4E2A7BF0.8080606@list.ru> <4E2AC742.8020407@infradead.org> <4E2ACAAD.4050602@list.ru> <4E2AE40F.7030108@infradead.org>
In-Reply-To: <4E2AE40F.7030108@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

23.07.2011 19:09, Mauro Carvalho Chehab wrote:
>> As I said, I propose the automute state to be a separate,
>> _third_ state. mute/unmute/automute.
>> Automute state is only set initially, but if the app
>> explicitly sets any other state, it is no longer affected.
>> Since an app can't rely on the state before it was
>> started, it should set the mute state explicitly first.
>> In this case, it will not be autounmuted after tuning.
> Hard to tell about your solution without seeing a patch.
I can try making this patch now only if we agree
on the technique first.

> Not sure if this will be consistent, especially if PA
> restarts for whatever reason (X restart? manual restart?).
I mean, this automute is set initially for every
new opening of the device node. So on every start
it will still have an automute mode.

> Anyway, we're discussing a lot for a kernel fix for PA,
> while the right thing to do is to fix PA itself.
I think both parts will better be fixed ideally, but
right now PA will probably not be fixed soon.
If we can agree on the logic, then I may take a
look into coding the patch itself.
