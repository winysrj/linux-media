Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vw0-f52.google.com ([209.85.212.52]:35787 "EHLO
	mail-vw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab1IMGZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Sep 2011 02:25:15 -0400
Received: by vws16 with SMTP id 16so466381vws.11
        for <linux-media@vger.kernel.org>; Mon, 12 Sep 2011 23:25:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110912202822.GB1845@valkosipuli.localdomain>
References: <CA+2YH7s-BH=4vN-DUZJXa9DKrwYsZORWq-YR9fK7JV9236ntMQ@mail.gmail.com>
	<20110912202822.GB1845@valkosipuli.localdomain>
Date: Tue, 13 Sep 2011 11:55:13 +0530
Message-ID: <CAK7N6vpr8uJSHMgTnrd=FrnvYf_Oqy8D3ua__S63T3nEvqaKGw@mail.gmail.com>
Subject: Re: omap3isp as a wakeup source
From: anish singh <anish198519851985@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Enrico <ebutera@users.berlios.de>, linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Sep 13, 2011 at 1:58 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> On Mon, Sep 12, 2011 at 04:50:42PM +0200, Enrico wrote:
>> Hi,
>
> Hi Enrico,
>
>> While testing omap3isp+tvp5150 with latest Deepthy bt656 patches
>> (kernel 3.1rc4) i noticed that yavta hangs very often when grabbing
>> or, if not hanged, it grabs at max ~10fps.
>>
>> Then i noticed that tapping on the (serial) console made it "unblock"
>> for some frames, so i thought it doesn't prevent the cpu to go
>> idle/sleep. Using the boot arg "nohlt" the problem disappear and it
>> grabs at a steady 25fps.
>>
>> In the code i found a comment that says the camera can't be a wakeup
>> source but the camera powerdomain is instead used to decide to not go
>> idle, so at this point i think the camera powerdomain is not enabled
>> but i don't know how/where to enable it. Any ideas?
>
> I can confirm this indeed is the case --- ISP can't wake up the system ---
> but don't know how to prevent the system from going to sleep when using the
> ISP.
Had it been on android i think wakelock would have been very useful.
>
> --
> Sakari Ailus
> e-mail: sakari.ailus@iki.fi     jabber/XMPP/Gmail: sailus@retiisi.org.uk
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
