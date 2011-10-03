Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60060 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab1JCOsd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Oct 2011 10:48:33 -0400
Received: by vws1 with SMTP id 1so2807679vws.19
        for <linux-media@vger.kernel.org>; Mon, 03 Oct 2011 07:48:32 -0700 (PDT)
Message-ID: <4E89CB3B.7080608@gmail.com>
Date: Mon, 03 Oct 2011 11:48:27 -0300
From: =?ISO-8859-1?Q?S=E9bastien_le_Preste_de_Vauban?=
	<ulpianosonsi@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Bttv and composite audio
References: <4E88EA0F.2090700@gmail.com>
In-Reply-To: <4E88EA0F.2090700@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So, I was corrected by irc #v4l user iive who told me there is no such 
thing as composite audio, but what happens is that composite video comes 
often paired with rca audio connectors.

Thanks for the clarification.

Now the problem may be in switching the audio inputs. Because tv-tuner 
audio works fine.
Also when I switch to composite I still hear the tv-tuner audio.

iive also mentioned the issue might be about how to multiplex the audio 
inputs and some gpio.

Is this some sort of bttv driver bug? or can it be sorted out with a 
modprobe bttv parameter?
If there is any other info I can include please tell me.

Thanks.
