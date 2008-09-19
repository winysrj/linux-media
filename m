Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <dec60b9dbdf2adac0b57a3bf0601ef3b.squirrel@78.226.152.136:8080>
In-Reply-To: <48D34D66.7000200@linuxtv.org>
References: <alpine.LRH.1.10.0809190830370.8673@pub1.ifh.de>
	<48D34D66.7000200@linuxtv.org>
Date: Fri, 19 Sep 2008 14:34:50 +0200 (CEST)
From: "Thierry Merle" <thierry.merle@free.fr>
To: "Steven Toth" <stoth@linuxtv.org>
MIME-Version: 1.0
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] [RFC] cinergyT2 rework final review
Reply-To: thierry.merle@free.fr
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


> Patrick Boettcher wrote:
>> Hi Thierry,
>>
>> On Fri, 19 Sep 2008, Thierry Merle wrote:
>>
>>> Hello all,
>>> About the rework from Tomi Orava I stored here:
>>> http://linuxtv.org/hg/~tmerle/cinergyT2
>>>
>>> since there seems to be no bug declared with this driver by testers (I
>>> tested this driver on AMD/Intel/ARM platforms for months), it is time
>>> for
>>> action.
>>> If I receive no problem report before 19th of October (in one month), I
>>> will push this driver into mainline.
>>
>> Are you really sure you want to wait until October 19 with that? You
>> heard
>> Jonathan this morning, he is expecting a new release every day now, so
>> the
>> merge window will start quite soon. Maybe it would be better to shorten
>> your deadline in favour of having the driver in-tree for 2.6.28. When it
>> is inside it is still possible for at least 1.5 months to fix occuring
>> problems.
>
> Agreed, shorten and aim for 2.6.28 - especially if you've already done a
> significant amount of personal testing.
>
> - Steve
>
>
OK. In my mind this patch was not a priority and some users reported bugs
but we don't have any news from their part. Maybe buggy users :)
I will wait just a little at least from Tomi and send a pull request to
Mauro within the middle of the next week.

Cheers,
Thierry

-- 
Sent from an ArmedSlack powered NSLU2.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
