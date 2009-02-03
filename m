Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from echoes.night-light.net ([84.49.14.38] ident=root)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linuxtv@night-light.net>) id 1LUQW7-0002Qt-AQ
	for linux-dvb@linuxtv.org; Tue, 03 Feb 2009 20:01:04 +0100
Received: from [192.168.1.22] (mediastation.night-light.localnet
	[192.168.1.22])
	by echoes.night-light.net (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n13J0wR9023538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-dvb@linuxtv.org>; Tue, 3 Feb 2009 20:00:58 +0100
Message-ID: <4988946A.9030502@night-light.net>
Date: Tue, 03 Feb 2009 20:00:58 +0100
From: Jonas Kvinge <linuxtv@night-light.net>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels]
Reply-To: linux-media@vger.kernel.org
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Manu Abraham wrote:
> Alex Betis wrote:
>> On Tue, Jan 27, 2009 at 9:56 PM, Manu Abraham <abraham.manu@gmail.com>wrote:
>>
>>>> Hmm OK, but is there by any chance a fix for those issues somewhere or
>>>> in the pipe at least? I am willing to test (as I already offered), I
>>>> can compile the drivers, spread printk or whatever else is needed to
>>>> get useful reports. Let me know if I can help sort this problem. BTW in
>>>> my case it is DVB-S2 30000 SR and FEC 5/6.
>>> It was quite not appreciable on my part to provide a fix or reply in
>>> time nor spend much time on it earlier, but that said i was quite
>>> stuck up with some other things.
>>>
>>> Can you please pull a copy of the multiproto tree
>>> http://jusst.de/hg/multiproto or the v4l-dvb tree from
>>> http://jusst.de/hg/v4l-dvb
>>>
>>> and apply the following patch and comment what your result is ?
>>> Before applying please do check whether you still have the issues.
>> Manu,
>> I've tried to increase those timers long ago when played around with my card
>> (Twinhan 1041) and scan utility.
>> I must say that I've concentrated mostly on DVB-S channels that wasn't
>> always locking.
>> I didn't notice much improvements. The thing that did help was increasing
>> the resolution of scan zigzags.
>
> With regards to the zig-zag, one bug is fixed in the v4l-dvb tree.
> Most likely you haven't tried that change.
>
>> I've sent a patch on that ML and people were happy with the results.
>
> I did look at your patch, but that was completely against the tuning
> algorithm.
>
> [..]
>
>> I believe DVB-S2 lock suffer from the same problem, but in that case the
>> zigzag is done in the chip and not in the driver.
>
> Along with the patch i sent, does the attached patch help you in
> anyway (This works out for DVB-S2 only)?
>
>
>

- From what I understand the driver still has some issues. Got feedback
from another guy with Canal Digital in Norway that he has the same
issues as me.

Not sure if the diff was an attempt to fix the digital artefacts but I
tried applying the diff manually on the source I grabbed from
http://jusst.de/hg/v4l-dvb/ but did not notice any improvements or
difference with the artefacts. Would any logs be helpful?

If there is anything else I could try I'm willing to try it out. I
appreciate your effort. Thanks.


Jonas
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkmIlGoACgkQpvOo+MDrK1H4yACdHPoej4cSsfPvp7m4NUGsAjAz
36EAn3cz9MffjPWztzyMEOcs0VcxhQdD
=h9tA
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
