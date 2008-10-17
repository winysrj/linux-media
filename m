Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Date: Fri, 17 Oct 2008 09:31:15 -0400
From: Steven Toth <stoth@linuxtv.org>
In-reply-to: <48F86120.2020203@linuxtv.org>
To: Andreas Oberritter <obi@linuxtv.org>
Message-id: <48F893A3.4060607@linuxtv.org>
MIME-version: 1.0
References: <412bdbff0810150724h2ab46767ib7cfa52e3fdbc5fa@mail.gmail.com>
	<48F5FE80.5010106@linuxtv.org>
	<412bdbff0810150740h61049f5fvb679bdebbcd4084d@mail.gmail.com>
	<48F633FA.4000106@linuxtv.org> <48F86120.2020203@linuxtv.org>
Cc: Linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Revisiting the SNR/Strength issue
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

Andreas Oberritter wrote:
> Steven Toth wrote:
>> Devin Heitmueller wrote:
>>> Certainly I'm in favor of expressing that there is a preferred unit
>>> that new frontends should use (whether that be ESNO or db), but the
>>> solution I'm suggesting would allow the field to become useful *now*.
>>> This would hold us over until all the other frontends are converted to
>>> db (which I have doubts will ever actually happen).
>> I'm not in favour of this.
>>
>> I'd rather see a single unit of measure agreed up, and each respective 
>> maintainer go back and perform the necessary code changes. I'm speaking 
>> as a developer of eight (?) different demod drivers in the kernel. 
>> That's no small task, but I'd happily conform if I could.
>>
>> Lastly, for the sake of this discussion, assuming that db is agreed 
>> upon, if the driver cannot successfully delivery SNR in terms of db then 
>>   the bogus function returning junk should be removed.
>>
>> Those two changes alone would be a better long term approach, I think.
> 
> How about adding a new command instead (and a similar one for S2API)? 
> 
> /* Read SNR in units of dB/100 */
> #define FE_READ_SNR_DB _IOR('o', 74, __u16)
> 
> Then it's no problem to slowly migrate the drivers to this interface. The
> old interface can still stay for some time without changes. Applications
> can try this ioctl, and if it returns an error, then it is not implemented
> for the used device.

Devin has offered to review the demods and snr code, to see the differences.

BTW, I like a couple of the ideas mentioned so far.

Many of the recent Linux demods drivers were written from datasheets, so 
we have access to real credible numbers. I suspect I can also push NXP 
for datasheets on older parts if the maintainers of other demods are 
willing to go the extra mile and add add the code. Other vendors, maybe 
not - let's see.

You can't really judge good / better / best or db if you don't have 
credible esno / db registers, that's should be the first step - to 
understand how many demods have issues and how many are fixable.

The user-facing API is only any good after we know the demods are 
standardized. I tend to think we can get > 80% of the demods reporting 
db or esno, which in turn can easily be abstracted via dvb-core into 
good / better / best or a more appropriate user view.

I don't agree to blindly massaging the demod values and trying to add a 
fake user facing API is a real solution.

I do like that people are talking again, and I will certainly be willing 
to help in fixing demods.

- Steve

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
