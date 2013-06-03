Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:57350 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab3FCUzp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Jun 2013 16:55:45 -0400
Message-ID: <51AD0113.2090307@schinagl.nl>
Date: Mon, 03 Jun 2013 22:48:19 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: daily tarballs of dtv-scan-tables - was Re: [RFC] Initial scan
 files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <50EF1034.7060100@gmail.com> <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com> <20130110180434.0681a7e1@redhat.com> <CAHFNz9+Jon-YSjkX5gFOTXwX+Vsmi0Rq+X_N61-m2+AEX+8tGg@mail.gmail.com> <50EF29D1.2080102@schinagl.nl> <20130110201134.364d5bc6@redhat.com> <50EF4766.2070100@schinagl.nl> <20130111103937.2cd0d5c8@redhat.com> <20130603142108.1db775f9@redhat.com>
In-Reply-To: <20130603142108.1db775f9@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/03/13 19:21, Mauro Carvalho Chehab wrote:
> Hi Oliver,
>
> Em Fri, 11 Jan 2013 10:39:37 -0200
> Mauro Carvalho Chehab <mchehab@redhat.com> escreveu:
>
>> Em Thu, 10 Jan 2013 23:57:42 +0100
>> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>>
> ...
>>> Personally, I'd say date based would be best. After each commit a new
>>> tarball should be created. Since it's not 'code' that changes, but
>>> factual data, any change warrants a release. So
>>> dtv-scan-files-2013011.tar.bz2/xz and is common?
>>>
>>> if for any reason a second release is needed on the same date ... too
>>> bad :p it's extremly unlikly anyway and can be done the next day's date.
>>> Or add an index after the date.
>>
>> To re-use the existing script, you'll need to create a Makefile target
>> to generate such tar. The script runs once during the night, comparing the
>> previous commit hash with the current one. If different, it creates a new
>> tarball.
>>
>> The Makefile there could be as simple as:
>>
>> tgz:
>> 	git archive --format tgz HEAD >dtv-scan-files-`date +"%Y%m%d.%H:%M"`.tar.gz
>>
>> The above is for tar.gz - I don't object if you want to use a different
>> compression provided that there are just one format. You may need to play
>> a little bit with git config files, to add support for xz and bz2.
>
> I found some time today to implement a script to generate the tarball
> files for dtv-scan-tables at the LinuxTV server.
>
> The script runs daily, checking if there was any new changeset at the
> repository. If it finds a new changeset there, it will take the date
> and the changeset of the latest commit at the tree and them as part of
> the tarball name, adding them to the following directory:
>
> 	http://linuxtv.org/downloads/dtv-scan-tables/
>
> The script will also create an hyperlink of the latest tarball at:
> 	dtv-scan-tables-LATEST.tar.bz2
Is there any easy way for me to see the script? Just so I can learn from it.
>
> Every time a new file is added there, it will also update the md5sum file,
> that could be used by someone to check the downloads.
That is very cool and very much thank you.

I'll immediately publicly admit I have been slacking here. I should have 
picked up on that and done it. I've been dragged away and been busy with 
http://linux-sunxi.org.

Anyway Thank you for picking that up. The dtv tree should be up to date 
however, all messages I saw passing the mailing lists have been pushed.

I will (slowly) inform others that are interested (package maintainers) 
and see how it goes.

Thanks again Mauro!
>
> Regards,
> Mauro
>
Oliver
