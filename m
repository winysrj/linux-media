Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from fg-out-1718.google.com ([72.14.220.152])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mkrufky@gmail.com>) id 1KbK2H-0006Al-Sb
	for linux-dvb@linuxtv.org; Thu, 04 Sep 2008 20:58:31 +0200
Received: by fg-out-1718.google.com with SMTP id e21so493259fga.25
	for <linux-dvb@linuxtv.org>; Thu, 04 Sep 2008 11:58:26 -0700 (PDT)
Message-ID: <37219a840809041158l25a6e22fr4a7505c301f2280a@mail.gmail.com>
Date: Thu, 4 Sep 2008 14:58:26 -0400
From: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Timothy E. Krantz" <tkrantz@stahurabrenner.com>
In-Reply-To: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAOMVmZh16nVIl8AQ98OnPV0BAAAAAA==@stahurabrenner.com>
MIME-Version: 1.0
Content-Disposition: inline
References: <!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAFlk6faj1j1FhIe00GqH5lMBAAAAAA==@stahurabrenner.com>
	<412bdbff0809041124o3ab340bci72e6d4f72b7653f9@mail.gmail.com>
	<!&!AAAAAAAAAAAYAAAAAAAAACQaAAE2cqNLuI5vSe3nryTCgAAAEAAAAOMVmZh16nVIl8AQ98OnPV0BAAAAAA==@stahurabrenner.com>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Getting firmware loaded to 2 cards of the same type
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

>> -----Original Message-----
>> From: Devin Heitmueller [mailto:devin.heitmueller@gmail.com]
>> Sent: Thursday, September 04, 2008 2:24 PM
>> To: Timothy E. Krantz
>> Cc: linux-dvb@linuxtv.org
>> Subject: Re: [linux-dvb] Getting firmware loaded to 2 cards
>> of the same type
>>
>> 2008/9/4 Timothy E. Krantz <tkrantz@stahurabrenner.com>:
>> > I have 2 tuner cards of the same type.  They have xc5000
>> tuner chips
>> > in them that require firmware to be loaded.  As best as I can tell
>> > from the dmesg, only the first card is actually getting the
>> firmware
>> > properly loaded. There seems to be a message related to the second
>> > card that says something about firmware previously loaded.
>> The second
>> > card fails to tune in either ATSC or NTSC mode, just a black screen.
>>
>> What type of card is it?
>>
On Thu, Sep 4, 2008 at 2:28 PM, Timothy E. Krantz
<tkrantz@stahurabrenner.com> wrote:
> Pinnacle PCTV HD (800i).
>


Timothy -- please do not top post.  The policy on this mailing list is
that replies shall appear below the quoted text.

Can you show us a full dmesg dump, starting from "Linux video capture
interface" , including all lines after.

Thanks,

Mike

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
