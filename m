Return-path: <linux-media-owner@vger.kernel.org>
Received: from rouge.crans.org ([138.231.136.3]:43782 "EHLO rouge.crans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0AUMNe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jan 2010 07:13:34 -0500
Message-ID: <4B58459E.8060108@crans.org>
Date: Thu, 21 Jan 2010 13:16:30 +0100
From: Brice Dubost <dubost@crans.org>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Dump Complete DVB Stream,	How to Dump Complete DVB
 Stream
References: <fd9871421001210357i2f515829m2aad024173967b6a@mail.gmail.com>
In-Reply-To: <fd9871421001210357i2f515829m2aad024173967b6a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

dvbfreaky 007 wrote:
> Hi ,
> Can any one suggest me on linux, How to capture/dump/Save complete DVB
> Stream( Not elementary Streams).
> 
> To capture elementary stream, I know these
> 1. dvbstream -f xxxxxx -o pid > /home/user/111/ts
> 2. Through VLC also can able to store ( But i am not succeeding all times)
> 3. Dumpstream option in mplayer
> 
> 
> 
> Is there any application to stream out (via RTP) complete DVB TS
> throughout LAN??
> Note: Not elementary Stream Out ( VLC does only Elementary Stream Out)
> Can Any one help in this regard?
> 


Hello,

MuMuDVB can do it (you have to choose pid 8192)

Dvblast can do it

dvbstream can do it with pi 8192 (but without RTP)

Best regards

-- 
Brice
