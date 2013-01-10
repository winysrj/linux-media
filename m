Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:53509 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3AJW5I (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Jan 2013 17:57:08 -0500
Message-ID: <50EF4766.2070100@schinagl.nl>
Date: Thu, 10 Jan 2013 23:57:42 +0100
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Manu Abraham <abraham.manu@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Johannes Stezenbach <js@linuxtv.org>,
	linux-media <linux-media@vger.kernel.org>, jmccrohan@gmail.com,
	Christoph Pfister <christophpfister@gmail.com>
Subject: Re: [RFC] Initial scan files troubles and brainstorming
References: <507FE752.6010409@schinagl.nl> <50D0E7A7.90002@schinagl.nl> <50EAA778.6000307@gmail.com> <50EAC41D.4040403@schinagl.nl> <20130108200149.GB408@linuxtv.org> <50ED3BBB.4040405@schinagl.nl> <20130109084143.5720a1d6@redhat.com> <CAOcJUbyKv-b7mC3-W-Hp62O9CBaRLVP8c=AWGcddWNJOAdRt7Q@mail.gmail.com> <20130109124158.50ddc834@redhat.com> <CAHFNz9+=awiUjve3QPgHtu5Vs2rbGqcLUMzyOojguHnY4wvnOA@mail.gmail.com> <50EF0A4F.1000604@gmail.com> <CAHFNz9LrW4GCZb-BwJ8v7b8iT-+8pe-LAy8ZRN+mBDNLsssGPg@mail.gmail.com> <50EF1034.7060100@gmail.com> <CAHFNz9KWf=EtvpJ1kDGFPKSvqwd9S51O1=wVYcjNmZE-+_7Emg@mail.gmail.com> <20130110180434.0681a7e1@redhat.com> <CAHFNz9+Jon-YSjkX5gFOTXwX+Vsmi0Rq+X_N61-m2+AEX+8tGg@mail.gmail.com> <50EF29D1.2080102@schinagl.nl> <20130110201134.364d5bc6@redhat.com>
In-Reply-To: <20130110201134.364d5bc6@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/10/13 23:11, Mauro Carvalho Chehab wrote:
> Em Thu, 10 Jan 2013 21:51:29 +0100
> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>
>> Anyway, fighting about it won't help anyone
>
> Agreed. From my side, don't expect further comments. That's hopefully
> my last email on this thread.
>
> Oliver,
>
> You owns your time. So, it is really your call.
Well I did write the initial plea for the seperation. :)

>
>  From my side, I appreciate your efforts on keep maintaining it.
I will do my very best for as long as time permits. I find it personally 
important that my scanfiles are updated as quickly as possibly and so 
will also update others as quickly as I can.

>
> I don't really care if this is done as a separate tree and/or together
> with dvb-apps, although, except for the scan files, the dvb-apps seem
> pretty much orphaned for a long time. So, among other reasons, IMHO
> it is better to keep it forked.
I still think it does make sense for reasons I posted 3 months ago.
>
> In any case, reimporting the files from an external tree is easy. It is
> equally easy to add a script at dvb-apps and on other applications that
> would take a tarball of it and copy the files there. We do that approach
> on v4l-utils, in order to sync it with kernel headers and kernel IR scancode
> tables, as we do need new headers there during development, and users do
> need the very latest IR scancode tables.
If dvb-apps depends on the scanfiles that horribly specifically, then a 
script to copy over the latest release would be best.

>
> If you decide to keep it in separate, I recommend you to add there some
> version schema to make easier for distributions that may want to add
> a package there, for them to track when this gets updated.
Personally, I'd say date based would be best. After each commit a new 
tarball should be created. Since it's not 'code' that changes, but 
factual data, any change warrants a release. So 
dtv-scan-files-2013011.tar.bz2/xz and is common?

if for any reason a second release is needed on the same date ... too 
bad :p it's extremly unlikly anyway and can be done the next day's date. 
Or add an index after the date.

>
> Also, just like what we do with media-build's "todaytar" target, it may
> also make some sense to have an script running at linuxtv.org that would
> create daily tarballs when a new commit is merged there, or when a new tag
> is added. That would help to have scripts at applications to sync with
> the latest files.
Well you want to release every commit really, as above stated a commit 
indicates a change in a transponder. Users of that transponder want to 
be able to use it asap.

>
> If you decide to either drop the tree or to add such tarball script
> at the server, please ping me.
Ping :p
>

