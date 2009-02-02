Return-path: <linux-media-owner@vger.kernel.org>
Received: from echoes.night-light.net ([84.49.14.38]:8724 "EHLO
	echoes.night-light.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbZBBROh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 12:14:37 -0500
Received: from [192.168.1.22] (mediastation.night-light.localnet [192.168.1.22])
	by echoes.night-light.net (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id n12GiJ5c006736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Mon, 2 Feb 2009 17:44:19 +0100
Message-ID: <498722E3.5000206@night-light.net>
Date: Mon, 02 Feb 2009 17:44:19 +0100
From: Jonas Kvinge <linuxtv@night-light.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] Re : Technotrend Budget S2-3200 Digital artefacts
 on HDchannels
References: <640929.18092.qm@web23204.mail.ird.yahoo.com>	<157f4a8c0901260739p424a74f6rcca2d84df04737b9@mail.gmail.com>	<157f4a8c0901260741l4d263b8bk6e34cb5bb56d8c2@mail.gmail.com>	<c74595dc0901260744i32d7deeg9a5219faca10dc93@mail.gmail.com>	<157f4a8c0901260751l39214908ydfeed5ba12b4d48b@mail.gmail.com>	<157f4a8c0901260808i39b784f6m13db53db2f135a37@mail.gmail.com>	<c74595dc0901260819g22f690d1qe809808eacb829da@mail.gmail.com>	<1a297b360901260950r599b944aoea24dcbdecbc9515@mail.gmail.com>	<1232998154.24736.2@manu-laptop>	<497F66E5.9060901@gmail.com>	<c74595dc0901271237j7495ddeaif44288ad47416ddd@mail.gmail.com> <497F78E9.9090608@gmail.com>
In-Reply-To: <497F78E9.9090608@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

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

iEYEARECAAYFAkmHIuMACgkQpvOo+MDrK1H1wACggFIUgXQHcJxBhjCCGXtDLe44
b7EAn0VW7orjhEdbhyWgQhOITWopLxwg
=dSFB
-----END PGP SIGNATURE-----
