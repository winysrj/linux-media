Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1Khfiz-0003gI-4u
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 09:20:49 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ncircle.nullnet.fi (Postfix) with ESMTP id A7B381413187
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 10:20:45 +0300 (EEST)
Received: from ncircle.nullnet.fi ([127.0.0.1])
	by localhost (alderan.ncircle.nullnet.fi [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id mgEg5gXAHHuV for <linux-dvb@linuxtv.org>;
	Mon, 22 Sep 2008 10:20:42 +0300 (EEST)
Received: from ncircle.nullnet.fi (localhost.localdomain [127.0.0.1])
	by ncircle.nullnet.fi (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 10:20:42 +0300 (EEST)
Message-ID: <28756.192.100.124.219.1222068042.squirrel@ncircle.nullnet.fi>
Date: Mon, 22 Sep 2008 10:20:42 +0300 (EEST)
From: "Tomi Orava" <tomimo@ncircle.nullnet.fi>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
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



Hi,

> On Fri, Sep 19, 2008 at 14:34:50 +0200, Thierry Merle wrote:
>
> [...]
>
>> OK. In my mind this patch was not a priority and some users reported bugs
>> but we don't have any news from their part. Maybe buggy users :) I will
wait just a little at least from Tomi and send a pull request to Mauro
within the middle of the next week.
>
> I had 2 issues:
>
> - irrecord didn't work
>
> - a failure after resume after suspend with the driver loaded, the
>   keyboard went crazy. Unloading the driver and unplugging the
>   CinergyT2 helped in this case
>
> I don't know if theses issues are still present, though. I don't use the
> IR receiver anymore, and always unload the driver before suspend. I'll
> try to update to the current driver and re-test.

I think that the version in Thierry's repository should contain
the missing key repeat functionality that Thierry added in June.
This should help to get the irrecord running again.

Could you check what is the firmware version in your device ?
Check for the "bcdDevice" keyword with lsusb -v -s <busid>:<devnum> I had
way too many problems with 1.06 firmware version, but the
newer 1.08 seems to be a little bit better in stability.
I do think that this device is certainly not the most stable tuner on
earth but if you don't do suspend/resume with it,
it should work quite fine.

Regards,
Tomi Orava

-- 




-- 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
