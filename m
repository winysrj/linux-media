Return-path: <mchehab@gaivota>
Received: from mail-in-02.arcor-online.net ([151.189.21.42]:38047 "EHLO
	mail-in-02.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759478Ab0LNQ1O (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Dec 2010 11:27:14 -0500
Message-ID: <4D079ADF.2000705@arcor.de>
Date: Tue, 14 Dec 2010 17:27:11 +0100
From: Stefan Ringel <stefan.ringel@arcor.de>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Felipe Sanches <juca@members.fsf.org>,
	Bee Hock Goh <beehock@gmail.com>,
	Luis Henrique Fagundes <lhfagundes@hacklab.com.br>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: tm6000 and IR
References: <4CAD5A78.3070803@redhat.com> <20101008150301.2e3ceaff@glory.local> <4CAF0602.6050002@redhat.com> <20101012142856.2b4ee637@glory.local> <4CB492D4.1000609@arcor.de> <20101129174412.08f2001c@glory.local> <4CF51C9E.6040600@arcor.de> <20101201144704.43b58f2c@glory.local> <4CF67AB9.6020006@arcor.de> <20101202134128.615bbfa0@glory.local> <4CF71CF6.7080603@redhat.com> <20101206010934.55d07569@glory.local> <4CFBF62D.7010301@arcor.de> <20101206190230.2259d7ab@glory.local> <4CFEA3D2.4050309@arcor.de> <20101208125539.739e2ed2@glory.local> <4CFFAD1E.7040004@arcor.de> <20101214122325.5cdea67e@glory.local>
In-Reply-To: <20101214122325.5cdea67e@glory.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Am 14.12.2010 04:23, schrieb Dmitri Belimov:
> Hi
>
> What about my last patch?? This is OK or bad?
> Our customers kick me every day with IR remotes.
>
> With my best regards, Dmitry.
I think, you use the second variant, Dmitry.
Why you doesn't use this key map - RCMAP_BEHOLD.
The power led we can change to a separate function, right. The nec 
initiation looks right and must adding code for tm5600/6000 (going over 
message pipe). rc5 need some code for tm6010 (for tm5600/6000 are the 
hack). And the logic for your remote control is unused  for the second 
variant, but ir->rc_type = rc_type are o.k..
Then the function call usb_set_interface in tm6000_video, can write for 
example:

stop_ir_pipe
usb_set_interface
start_ir_pipe

I will adding vbi_buffer and device in the next, and isoc calculating 
without video_buffer size.

Stefan Ringel
