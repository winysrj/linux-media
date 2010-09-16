Return-path: <mchehab@pedra>
Received: from web55406.mail.re4.yahoo.com ([206.190.58.200]:37479 "HELO
	web55406.mail.re4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750727Ab0IPH1Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Sep 2010 03:27:25 -0400
Message-ID: <276313.51207.qm@web55406.mail.re4.yahoo.com>
References: <521CE7BF573A436C94F0D9CDAEAF3524@MARCM.local> <E0626F02-B5EC-439B-8673-EF870AC0B5BE@marcm.co.uk> <4C909475.70000@eris.qinetiq.com>
Date: Thu, 16 Sep 2010 00:27:24 -0700 (PDT)
From: Suchita Gupta <suchitagupta@yahoo.com>
Subject: Re: [linux-dvb] DSM-CC question
To: linux-media@vger.kernel.org
In-Reply-To: <4C909475.70000@eris.qinetiq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Its a very good idea. I will look at it as soon as possible and may be come back 
to you for questions.
I have already done most of the implementation by storing blocks in memory and I 
have to finish it as soon as possible.
But later on I can use this idea, it to optimize memory utilization and 
performance of my code

Thanks.


----- Original Message ----
From: Simon Kilvington <s.kilvington@eris.qinetiq.com>
To: linux-media@vger.kernel.org
Cc: linux-dvb@linuxtv.org
Sent: Wed, 15 September, 2010 10:40:05
Subject: Re: [linux-dvb] DSM-CC question

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

also have a look at my rb-download code,

http://redbutton.sourceforge.net/

this gets around the problem of having to know the directory structure
before you download files by using symlinks - ie you download the files
as they arrive on the carousel, then when you get a directory you create
the directory but make all the file entries in it symlinks - if the
files have already arrived, then the links point to them, if the files
haven't arrived yet, you just have some dangling symlinks until they do

this means you don't have to worry about trying to cache files in memory
before you can write them to disc and so makes the whole thing a lot
simpler to implement

On 14/09/10 22:06, Marc Murphy wrote:
> Have a look at libdsmcc. It will write by default to /tmp/cache I have modified 
>my test software to notify of a new file or updated file version. 
>
> 
> Hope this helps
> 
> Marc
> 
> Sent from my iPhone
> 
> On 14 Sep 2010, at 21:31, "Suchita Gupta" <suchitagupta@yahoo.com> wrote:
> 
>> Hi,
>>
>> First of all, I am new to this list, so I am not sire if this is right place 
>>for 
>>
>> this question.
>> If not, please forgive me and point me to right list.
>>
>> I am writing a DSMCC decoding implementation to persist it to local 
>filesystem.
>> I am unable to understand few thiings related to "srg"
>>
>> I know, it represents the top level directory. But how do I get the name of 
>>this 
>>
>> directory?
>> I can extract the names of subdirs and files using name components but where is 
>>
>> the name of top level directory?
>>
>> Also, as far as I understand it, I can't start writing to the local filesystem 
>
>> until I have acquired the whole carousel.
>>
>> Can, anyone please provide me some guidance.
>>
>> Thanks in Advance,
>> rs
>>
>>
>>
>>
>> _______________________________________________
>> linux-dvb users mailing list
>> For V4L/DVB development, please use instead linux-media@vger.kernel.org
>> linux-dvb@linuxtv.org
>> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
>>
> 
> _______________________________________________
> linux-dvb users mailing list
> For V4L/DVB development, please use instead linux-media@vger.kernel.org
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 
> 

- -- 
Simon Kilvington


-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkyQlHUACgkQmt9ZifioJSwN7QCffyS4wY25IMysdwFcJEUS/Aaw
JBEAoIGShJ/kxMvOT73o7vEqfXMNKr/r
=Jf4M
-----END PGP SIGNATURE-----

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



      
