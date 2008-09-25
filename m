Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from web52911.mail.re2.yahoo.com ([206.190.49.21])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <rankincj@yahoo.com>) id 1Kir7y-0004da-VE
	for linux-dvb@linuxtv.org; Thu, 25 Sep 2008 15:43:32 +0200
Date: Thu, 25 Sep 2008 06:42:56 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
To: Patrick Boettcher <patrick.boettcher@desy.de>
In-Reply-To: <alpine.LRH.1.10.0809251152480.1247@pub1.ifh.de>
MIME-Version: 1.0
Message-ID: <766065.22236.qm@web52911.mail.re2.yahoo.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [PATCH] Add remote control support to Nova-TD
	(52009)
Reply-To: rankincj@yahoo.com
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--- On Thu, 25/9/08, Patrick Boettcher <patrick.boettcher@desy.de> wrote:
> Committed and ask to be pulled, thanks.

Thanks. However, as a further thought, I did notice that I was able to control my new Nova-TD using the same remote control as my Nova-T, and that the dvb-usb-dib0700 driver also recognised the codes for three other remote controls as well! Aren't we opening the door to "remote control wars" by just concatenating the codes from several different remotes into one big list called dib0700_rc_keys[]? Wouldn't it be better to allow the user to pick just one of the available remotes somehow? Maybe we need an array of dvb_usb_rc_key structures instead?

Mind you, I don't know what kind of selection API would be most appropriate. A module parameter would probably work, but I can imagine that a user might want to switch remotes more easily than by reloading the kernel module.

Cheers,
Chris


      

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
