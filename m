Return-path: <mchehab@pedra>
Received: from mailr.qinetiq-tim.net ([128.98.1.9]:2763 "EHLO
	mailr.qinetiq-tim.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0IOKI5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 15 Sep 2010 06:08:57 -0400
Received: from mailhost.eris.qinetiq.com (mailhost.eris.qinetiq.com [128.98.2.2])
	by mailr.qinetiq-tim.net (Postfix) with SMTP id A14B48CCFE
	for <linux-media@vger.kernel.org>; Wed, 15 Sep 2010 10:42:28 +0100 (BST)
Message-ID: <4C909475.70000@eris.qinetiq.com>
Date: Wed, 15 Sep 2010 10:40:05 +0100
From: Simon Kilvington <s.kilvington@eris.qinetiq.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Marc Murphy <marcmltd@marcm.co.uk>, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] DSM-CC question
References: <521CE7BF573A436C94F0D9CDAEAF3524@MARCM.local> <E0626F02-B5EC-439B-8673-EF870AC0B5BE@marcm.co.uk>
In-Reply-To: <E0626F02-B5EC-439B-8673-EF870AC0B5BE@marcm.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

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
> Have a look at libdsmcc. It will write by default to /tmp/cache I have modified my test software to notify of a new file or updated file version. 
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
>> First of all, I am new to this list, so I am not sire if this is right place for 
>> this question.
>> If not, please forgive me and point me to right list.
>>
>> I am writing a DSMCC decoding implementation to persist it to local filesystem.
>> I am unable to understand few thiings related to "srg"
>>
>> I know, it represents the top level directory. But how do I get the name of this 
>> directory?
>> I can extract the names of subdirs and files using name components but where is 
>> the name of top level directory?
>>
>> Also, as far as I understand it, I can't start writing to the local filesystem 
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
