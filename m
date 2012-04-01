Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:56942 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753Ab2DAWL5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 1 Apr 2012 18:11:57 -0400
Message-ID: <4F78D2AA.1020503@iki.fi>
Date: Mon, 02 Apr 2012 01:11:54 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans-Frieder Vogt <hfvogt@gmx.net>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH] AF9033 read_ber and read_ucblocks implementation
References: <4F75A7FE.8090405@iki.fi> <201204012011.29830.hfvogt@gmx.net> <201204012307.31742.hfvogt@gmx.net> <201204012319.12575.hfvogt@gmx.net> <4F78CF26.3080704@iki.fi>
In-Reply-To: <4F78CF26.3080704@iki.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02.04.2012 00:56, Antti Palosaari wrote:
> On 02.04.2012 00:19, Hans-Frieder Vogt wrote:
>> Implementation of af9033_read_ber and af9033_read_ucblocks functions.
>> + sw = ~sw;
>
> I don't see any reason for that?

Now I see, it is some kind of switch to make operation every second call?
As it is defined static:
+	static u8 sw = 0;
[...]
+		if (sw)
+			state->ucb = abort_cnt;
+		else
+			state->ucb = +abort_cnt;
+		sw = ~sw;

Unfortunately I am almost sure it will not work as it should. In my 
understanding this kind of static variables are shared between driver 
instances... and if you have device where is two or more af9033 demods 
it will share it. Also if you have multiple af9033 devices, are are 
shared. It works only if you have one af9033 demodulator in use.

Instead, this kind of switches should be but to driver private aka 
state. Also think twice if all that logic is correct and needed.

regards
Antti
-- 
http://palosaari.fi/
