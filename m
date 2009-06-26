Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.emergencycommunicationsystems.com ([24.123.23.170]:51025
	"EHLO unifiedpaging.messagenetsystems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755046AbZFZSYr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:24:47 -0400
Message-ID: <4A451049.2060801@messagenetsystems.com>
Date: Fri, 26 Jun 2009 14:15:37 -0400
From: Robert Vincent Krakora <rob.krakora@messagenetsystems.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Andy Walls <awalls@radix.net>, video4linux-list@redhat.com,
	linux-media@vger.kernel.org
Subject: Re: Bah! How do I change channels?
References: <COL103-W53A73F78F552D9FD9BAA2A88350@phx.gbl>	 <1246017001.4755.4.camel@palomino.walls.org>	 <829197380906260642m2cd87ae5qd6487dc5eae91e51@mail.gmail.com>	 <b24e53350906261019u45bba60erc7ee41222896388b@mail.gmail.com>	 <829197380906261023n7e960f43pcd25d82eb12f91dd@mail.gmail.com>	 <b24e53350906261028n1cb1abf6r6e0691759c6b8772@mail.gmail.com> <829197380906261032h2f5f5828p94ba7519ce7f38db@mail.gmail.com>
In-Reply-To: <829197380906261032h2f5f5828p94ba7519ce7f38db@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Jun 26, 2009 at 1:28 PM, Robert
> Krakora<rob.krakora@messagenetsystems.com> wrote:
>   
>> Yes, it is run after mplayer initially tunes it.  However, what is the
>> difference between mplayer tuning and v4l-ctl tuning?  They are both
>> submitting the same IOCTLs to the driver to accomplish the same end
>> result; or is mplayer probably submitting some additional IOCTLS to
>> "wake" the device?
>>     
>
> The issue is that the tuner gets powered down when the v4l device is
> closed.  So, when running mplayer first, and then v4l-ctl is being
> used to tune, the file handle is held active by mplayer.  But if you
> run v4l-ctl first, the v4l-ctl opens the handle, tunes successfully,
> and then closes the handle (which powers down the tuner).  Then when
> running mplayer (or whatever app), the handle gets reopened but the
> tuner is not tuned to the target frequency that v4l-ctl set.
>
> Devin
>
>   
Aaahh yes...I think that you have told me that once before...sorry for 
making you repeat yourself...

However, with ivtv-tune I can issue a tune to a channel and then open 
mplayer with no tuning parameters and that channel is playing...

-- 
Rob Krakora
Senior Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
