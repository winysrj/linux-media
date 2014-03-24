Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:60011 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbaCXJVv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 05:21:51 -0400
Message-ID: <532FF92A.9090504@schinagl.nl>
Date: Mon, 24 Mar 2014 10:21:46 +0100
From: Olliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: DTV-Scan-tables tarballs not generated properly
References: <532EB3F5.9090607@schinagl.nl> <20140323115818.572d5bdb@samsung.com>
In-Reply-To: <20140323115818.572d5bdb@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/23/2014 03:58 PM, Mauro Carvalho Chehab wrote:
> Em Sun, 23 Mar 2014 11:14:13 +0100
> Olliver Schinagl <oliver+list@schinagl.nl> escreveu:
>
>> Hey Mauro,
>>
>> Hope everything is well.
>>
>> People have noticed that the tarballs for the dtv-scan-tables aren't
>> being generated properly. The 'LATEST' appears to be correct, but there
>> is only one dated one, no new ones. If you have a few minutes, can you
>> see what's going on?
>
> Fixed. Basically, the logic that were getting the date were after
> the command that was moving to the repository. So, it was returning an
> empty date. So, the file was always named as:
> 	dtv-scan-tables-.tar.gz
>
> As dtv-scan-tables-LATEST.tar.gz is actually a link to the produced
> file, it was working.
>
> Now, it was properly generated, based on git last commit:
> 	dtv-scan-tables-2014-03-09-177b522.tar.bz2
>
> The name there matches the latest changeset:
> 	http://git.linuxtv.org/dtv-scan-tables.git/commit/177b522e4c815d034cfda5d1a084ad074bc373b6
>
> As usual, the produced files are at:
> 	http://linuxtv.org/downloads/dtv-scan-tables/
>
> Please check it again the day after you add some new commit(s) there,
> for us to be sure that everything is working ok. Ah, you should never
> rebase the tree, as otherwise the script may fail.
But will 'work' again a commit later? Just wondering how badly it would 
break ;)
>
>> Secondly, I guess we are way past the year marker, how do you feel the
>> dtv-scan-tables are handled? I hope it is all satisfactory still?
>
> Yes. I would add a few things on a TODO list:
>
> 1) Work with major distros for them to have a package for dtv-scan-tables;
I know that debian and fedora allready package them. So that's a good 
thing, I'll see what I can do with regards to other major distro's 
(gentoo, arch come to mind)
>
> 2) Convert the files to the libdvbv5 format. On libdvbv5 format, all
> properties of a DVB channel/transponder are properly represented, as
> it uses the same definitions as found at DVBv5 API.
>
> I dunno if you are aware, but the current format is not compatible
> with some standards (like ISDB-T). Ok, there are tables there for
> ISDB-T, but that relies on the frontend to be able to auto-discover
> the properties, because the only thing that it is right there is
> the channel frequency.
>
> Even for DVB-T2/S2, there's a new property that is needed to tune
> a channel with is not represented with the current format
> (DTV_STREAM_ID). Thankfully, afaikt, there aren't many broadcasters
> using it.
>
> Of course, in order to preserve backward compat, we should still have
> the same format at /usr/share/dvb.
>
> So, my suggestion is to convert the files there to libdvbv5, and
> store them at /usr/share/dvbv5. Then, add a Makefile that will
> use dvb-format-convert to generate the current contents, and store
> them at /usr/share/dvb.

I'll put this on my todo list for this year.

Thanks Mauro!

Olliver
>
> Regards,
> Mauro
>

