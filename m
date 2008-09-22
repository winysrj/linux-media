Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from xdsl-83-150-88-111.nebulazone.fi ([83.150.88.111]
	helo=ncircle.nullnet.fi) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <tomimo@ncircle.nullnet.fi>) id 1Khfcn-00033q-7s
	for linux-dvb@linuxtv.org; Mon, 22 Sep 2008 09:14:25 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by ncircle.nullnet.fi (Postfix) with ESMTP id 10C0B1413274
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 10:14:21 +0300 (EEST)
Received: from ncircle.nullnet.fi ([127.0.0.1])
	by localhost (alderan.ncircle.nullnet.fi [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id u2b9VU6rdHE4 for <linux-dvb@linuxtv.org>;
	Mon, 22 Sep 2008 10:14:18 +0300 (EEST)
Received: from ncircle.nullnet.fi (localhost.localdomain [127.0.0.1])
	by ncircle.nullnet.fi (Postfix) with ESMTP
	for <linux-dvb@linuxtv.org>; Mon, 22 Sep 2008 10:14:18 +0300 (EEST)
Message-ID: <38254.192.100.124.219.1222067658.squirrel@ncircle.nullnet.fi>
Date: Mon, 22 Sep 2008 10:14:18 +0300 (EEST)
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

>> Patrick Boettcher wrote:
>>> Hi Thierry,
>>>
>>> On Fri, 19 Sep 2008, Thierry Merle wrote:
>>>
>>>> Hello all,
>>>> About the rework from Tomi Orava I stored here:
>>>> http://linuxtv.org/hg/~tmerle/cinergyT2
>>>>
>>>> since there seems to be no bug declared with this driver by testers
(I tested this driver on AMD/Intel/ARM platforms for months), it is
time for
>>>> action.
>>>> If I receive no problem report before 19th of October (in one month), I
>>>> will push this driver into mainline.
>>>
>>> Are you really sure you want to wait until October 19 with that? You
heard
>>> Jonathan this morning, he is expecting a new release every day now, so
the
>>> merge window will start quite soon. Maybe it would be better to
shorten your deadline in favour of having the driver in-tree for
2.6.28. When it
>>> is inside it is still possible for at least 1.5 months to fix occuring
problems.
>>
>> Agreed, shorten and aim for 2.6.28 - especially if you've already done
a significant amount of personal testing.
>>
>> - Steve
>>
>>
> OK. In my mind this patch was not a priority and some users reported
bugs but we don't have any news from their part. Maybe buggy users :) I
will wait just a little at least from Tomi and send a pull request to
Mauro within the middle of the next week.

Not much has been happening during the summertime. No new bug reports have
been reported and I never heard again from the person who claimed to have
had problems with this driver in May(?). This driver has been working in
my own use quite well, especially after upgrading the bios to the latest
available version from TerraTec.

Regards,
Tomi Orava


-- 



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
