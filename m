Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:41584 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1HPU51 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Aug 2011 16:57:27 -0400
Message-ID: <4E4AD9B4.2040908@iki.fi>
Date: Tue, 16 Aug 2011 23:57:24 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Jose Alberto Reguero <jareguero@telefonica.net>
CC: Josu Lazkano <josu.lazkano@gmail.com>, linux-media@vger.kernel.org
Subject: Re: Afatech AF9013
References: <CAL9G6WUpso9FFUzC3WWiBZDqQDr-+HQFouCO_2V-zVHVyiyKeg@mail.gmail.com> <201108160116.15648.jareguero@telefonica.net> <CAL9G6WXkyeBdy9V4gL8kp36U9Kzy3yEhb_Coh_d98BzNdR3qTQ@mail.gmail.com> <201108162227.00963.jareguero@telefonica.net>
In-Reply-To: <201108162227.00963.jareguero@telefonica.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/16/2011 11:27 PM, Jose Alberto Reguero wrote:
>> options dvb-usb force_pid_filter_usage=1
>>
>> I change the signal timeout and tuning timeout and now it works perfect!
>>
>> I can watch two HD channels, thanks for your help.
>>
>> I really don't understand what force_pid_filter_usage do on the
>> module, is there any documentation?
>>
>> Thanks and best regards.
>>
> 
> For usb devices with usb 2.0 when tunned to a channel there is enought usb 
> bandwith to deliver the whole transponder. With pid filters they only deliver 
> the pids needed for the channel. The only limit is that the pid filters is 
> limited normaly to 32 pids.

May I ask how wide DVB-T streams you have? Here in Finland it is about
22 Mbit/sec and I think two such streams should be too much for one USB
bus. I suspect there is some other bug in back of this.

regards
Antti

-- 
http://palosaari.fi/
