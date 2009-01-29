Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp120.rog.mail.re2.yahoo.com ([68.142.224.75]:39741 "HELO
	smtp120.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751955AbZA2Xou (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 29 Jan 2009 18:44:50 -0500
Message-ID: <49823F6C.8090401@rogers.com>
Date: Thu, 29 Jan 2009 18:44:44 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Michael Krufky <mkrufky@linuxtv.org>,
	hermann pitton <hermann-pitton@arcor.de>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Josh Borke <joshborke@gmail.com>,
	David Lonie <loniedavid@gmail.com>, linux-media@vger.kernel.org
Subject: Re: KWorld ATSC 115 all static
References: <7994.62.70.2.252.1232028088.squirrel@webmail.xs4all.nl> <200901171720.03890.hverkuil@xs4all.nl> <49737088.7060800@rogers.com> <200901182011.11960.hverkuil@xs4all.nl> <49739D1E.5050800@rogers.com>
In-Reply-To: <49739D1E.5050800@rogers.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CityK wrote:
> Hans Verkuil wrote:
>   
>> I've made a new tree http://linuxtv.org/hg/~hverkuil/v4l-dvb-kworld/ 
>> that calls 'enables the tuner' before loading the module. See if that 
>> works.
>>
>> ...
>>   
>> I suspect that this might fix the bug.
>>     
>
> Hans,
>
> ...  it works !!  

I may have found a problem (tvtime works perfectly; other analogue apps
like xawtv/motv, kdetv ... are not working properly now -- you can do a
channel scan with them and everything_appears_to work as expected (i.e.
channels are found and are displayed/played correctly during the scan),
BUT as soon as you actually go to use the app, it does not work
(static).  It appears that the issue is related to dga and Xv (as
passing the -nodga -noxv options with xawtv/motv actually works ...
kdetv is hit and miss -- sometimes the v4l1 mode works, other times it
doesn't (likely a pattern there but haven't found it yet), but v4l2
plugin does NOT work at all (static)).  In addition, the nvidia driver
is NOT the source of the error, as the same occurs under the nv driver
as well. 

Will have to do another test to confirm whether this error was
introduced in the KWorld repo.  Consequently:

> Mauro Carvalho Chehab wrote:
>   
>> Hans Verkuil wrote:
>>     
>>> Note that Mauro merged my saa7134 changes, so these are now in the master 
>>> repository.
>>>     
>>>       
>> Yes. We need to fix it asap, to avoid regressions. It is time to review also
>> the other codes that are touching on i2c gates at _init2().
>>   
>>     
>
> Thoughts on merging the changes from Hans' KWorld repo? 

If there were any thoughts on this, please put them on hold until I can
test further. 
