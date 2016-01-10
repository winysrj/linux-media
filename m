Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34874 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762AbcAJDnQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 22:43:16 -0500
Subject: Re: [REGRESSION/bisected] kernel panic after "rmmod cx23885" by
 "si2157: implement signal strength stats"
To: emw@nocabal.de, Martin Witte <emw-linux-media-2016@nocabal.de>
References: <20160108121852.GA29971@[192.168.115.1]>
 <20160109214237.GA25076@titiwu.nocabal.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Antti Palosaari <crope@iki.fi>
Message-ID: <5691D351.2030005@iki.fi>
Date: Sun, 10 Jan 2016 05:43:13 +0200
MIME-Version: 1.0
In-Reply-To: <20160109214237.GA25076@titiwu.nocabal.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
Those timers are activated on frontend init() ja de-activated on 
sleep(). Removing active driver does not sound good and IMHO it should 
not be even possible. I think it should be find out why it is possible 
to remove whole driver before it is put to sleep().

Antti


On 01/09/2016 11:42 PM, Ernst Martin Witte wrote:
> Hi again,
>
> seems  that the  cause  for the  kernel  panic is  a  missing call  to
> cancel_delayed_work_sync in  si2157_remove before  the call  to kfree.
> After adding cancel_delayed_work_sync(&dev->stat_work), rmmod does not
> trigger the kernel panic any more.
>
> However, very similar issues could be identified also in other modules:
>
>     ts2020
>     af9013
>     af9033
>     rtl2830
>
> when looking in drivers/media/tuners and drivers/media/dvb-frontends.
>
> Therefore,  the submitted  patch  set contains  fixes  also for  those
> modules. The submitted patch set is:
>
>     [PATCH 0/5] [media] cancel_delayed_work_sync before device removal / kfree
>
> I hope these patches completely fix the issue and are ok for inclusion
> in the kernel.
>
> BR and thx,
>     Martin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
http://palosaari.fi/
