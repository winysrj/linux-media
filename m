Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.wow.synacor.com ([64.8.70.55]:36277 "EHLO
	smtp.mail.wowway.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717AbZEEXeg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2009 19:34:36 -0400
Received: from aqui.slotcar.prv ([172.16.1.3])
	by sordid.slotcar.chicago.il.us with esmtp (Exim 4.67)
	(envelope-from <johnr@wowway.com>)
	id 1M1U9k-0000Do-L3
	for linux-media@vger.kernel.org; Tue, 05 May 2009 18:34:36 -0500
Message-ID: <4A00CD07.9030200@wowway.com>
Date: Tue, 05 May 2009 18:34:31 -0500
From: "John R." <johnr@wowway.com>
MIME-Version: 1.0
CC: linux-media@vger.kernel.org
Subject: Re: Hauppauge 950Q Analog (Composite Input) Problem
References: <49FF85F1.5080600@wowway.com>	 <412bdbff0905041753p744bf0b4n409989f9997703a9@mail.gmail.com> <cb69f9670905042002t76ac4871lb859b6122c324aa7@mail.gmail.com>
In-Reply-To: <cb69f9670905042002t76ac4871lb859b6122c324aa7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

kenny wang wrote:
> Hi, John
> 
> I am using exactly the same device, and several weeks ago Devin helped 
> me make it work perfectly. I downloaded and compiled the newest codes 
> from v4l mecurial, and simply use tvtime to play the video. But you need 
> to use some other command to play sound:

Thanks.  Devin's response got me through the basic stuff I was missing. 
  Yours should help quite a bit in getting sound to work.  For anyone 
that is working with composite input, here is a sample invocation for 
video only:

mplayer tv:// -tv 
driver=v4l2:input=1:norm=ntsc:width=640:height=480:device=/dev/video0 -vo xv

John
