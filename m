Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from widget.gizmolabs.org ([69.55.236.117])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <ecronin@gizmolabs.org>) id 1JrZzZ-00026z-No
	for linux-dvb@linuxtv.org; Thu, 01 May 2008 16:42:49 +0200
Message-Id: <3D1FCC6B-50EB-4F49-977D-6FF3A911F95E@gizmolabs.org>
From: Eric Cronin <ecronin@gizmolabs.org>
To: Michael Krufky <mkrufky@linuxtv.org>
In-Reply-To: <481937FD.7000908@linuxtv.org>
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Thu, 1 May 2008 10:41:54 -0400
References: <CAB8636B-64E8-40CB-9D6C-0F52E9CD2394@gizmolabs.org>
	<37219a840804301134q68a86301y2373329d2fef5a2f@mail.gmail.com>
	<37219a840804301136r71b240afi16dcf75b5442fe1b@mail.gmail.com>
	<B3017A65-6616-4FBF-BF82-30B3F69B6CAA@gizmolabs.org>
	<48190CDB.3080307@linuxtv.org>
	<BBCA0FD2-7BB0-44C4-9DF9-DF65DADEECFA@gizmolabs.org>
	<481937FD.7000908@linuxtv.org>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] HVR-1800 failing to detect any QAM256 channels
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1533495690=="
Mime-version: 1.0
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--===============1533495690==
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="Apple-Mail-19--582518997"
Content-Transfer-Encoding: 7bit

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-19--582518997
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit


On Apr 30, 2008, at 11:24 PM, Michael Krufky wrote:
> Eric Cronin wrote:
>>
>> On Apr 30, 2008, at 8:20 PM, Michael Krufky wrote:
>>> Eric Cronin wrote:
>>>>
>>>> On Apr 30, 2008, at 2:36 PM, Michael Krufky wrote:
>>>>
>>>>>>
>>>>>> Eric,
>>>>>>
>>>>>> When you use the scan command to scan for QAM channels, you must
>>>>>> specify -a2, to signify that you are scanning digital cable.
>>>>>>
>>>>>> Try that -- does that work?
>>>>>
>>>>>
>>>>> My bad -- I meant, "-A 2"  (capitol A, space, 2)
>>>
>>> scan -A 2 -vvv dvb-apps/util/scan/atsc/us-Cable-Standard-whatever >
>>> channels.conf
>>>
>>> Is THAT what you're doing to scan ?
>>>
>>>
>>> It looks like what you were doing was scan a tuned frequency for  
>>> pids.
>>> If you want to do THAT, then you must actually be tuned to the given
>>> frequency.  you need to azap SOME_CHANNEL -r, and keep that running
>>> before attempting to run 'scan -c' ...  I think you should try the  
>>> scan
>>> command that I mentioned above.
>>>
>>> HTH,
>>>
>>> Mike
>>>
>>
>>
>> I was only using one -v, but the scan file isn't the problem.  It is
>> just the single line out of
>> /usr/share/doc/dvb-utils/examples/scan/atsc/us-Cable-Standard- 
>> center-frequencies-QAM256
>> corresponding to a known good frequency.  Otherwise it scans from  
>> 0-70
>> which are all NTSC and gets annoying on repeated attempts...
>>
>> Adding two more -v's doesn't change anything, status is always 0x00
>> and nothing gets written to STDOUT (channels.conf)
>>
>> ~$ scan -A 2 -vvv
>
> The -v is just for verbosity.
>
> My question should have been, "did you give it a chance to scan  
> through
> the entire scan file?
>
> -Mike
>

Yes.

Thanks,
Eric


--Apple-Mail-19--582518997
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (Darwin)

iQEcBAEBCAAGBQJIGdayAAoJEIgz4Q+coYsSeVIH/1S2QOQ+K3GA+bxWqq4mKAXl
pRxTZKjogxHIJH8K5+ve5cGPR6IfIoFUNilIj8c9ub1H2EM2xsn9TyB8gSmGMRc8
a2eIejCdQmBb7niP+sg1Ne2/WU/pL1GlFCvEy2bGYOB6DvwWKB0K7UR7i9PYLVqo
1NTrkDsnZSxc5TLVam/ctgBlfonPQMFy2V1GTy7YtzhtBHKFx6C+fp5STB3I4njP
KmBNybru/0AU6yFLV3mN3OtidKEjEYn8slr/3YaC75/tWZYLgXIgFKRQjGmIj8yN
0E3hzBjLue/NKOPGBEQOzxA/BQ0f/mNhVzksrjhPuZt01UGXk+LkOW8/uQh2/Qo=
=Ucv3
-----END PGP SIGNATURE-----

--Apple-Mail-19--582518997--


--===============1533495690==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--===============1533495690==--
