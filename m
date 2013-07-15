Return-path: <linux-media-owner@vger.kernel.org>
Received: from 7of9.schinagl.nl ([88.159.158.68]:43334 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754038Ab3GOIVB (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jul 2013 04:21:01 -0400
Message-ID: <51E3B06A.5000701@schinagl.nl>
Date: Mon, 15 Jul 2013 10:18:50 +0200
From: Oliver Schinagl <oliver+list@schinagl.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	opensource@till.name
Subject: Re: dtv-scan-tables tar archive
References: <20130712085956.GZ4000@genius.invalid> <51DFC76B.6010208@schinagl.nl> <20130712155551.1ce19ab8.mchehab@infradead.org>
In-Reply-To: <20130712155551.1ce19ab8.mchehab@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12-07-13 20:55, Mauro Carvalho Chehab wrote:
> Em Fri, 12 Jul 2013 11:07:55 +0200
> Oliver Schinagl <oliver+list@schinagl.nl> escreveu:
>
>> Mauro,
>>
>> I think the archive is generated incorrectly. Could you take a look and
>> see why? I shamefully admit I still am not sure where you did what to
>> generate these ;)
>
> Basically, I run a script like the one below once a day at the crontab:
>
> #!/bin/bash
> LANG=C
> PATH=/usr/local/bin:/usr/bin:/bin:/usr/bin/X11:/usr/games
>
> DIR=/some_temp_location/dtv-scan-tables
>
> DATE="`git log -n1 '--pretty=format:%h %ai' |perl -ne 'print "$2-$1" if (m/([\da-f]+)\s+(\S+)/)'`"
>
> TODAY_TAR=dtv-scan-tables-$DATE.tar
> FILE="$TODAY_TAR.bz2"
> REPO=/the_www_location/downloads/dtv-scan-tables/
>
>
> run() {
> 	echo $@
> 	$@
> 	if [ "$?" != "0" ]; then
> 		echo "Error $?. Please fix."
> 		exit -1
> 	fi
> }
>
> run cd $DIR
> run git pull /git/dtv-scan-tables.git/ master
>
> CHANGES=`git log --pretty=oneline -n1`
> if [ "$CHANGES" = "`cat .changes`" ]; then
> 	echo "tarball already updated to the latest changeset."
> 	echo "Nothing to do."
> 	exit;
> fi
>
> git archive --format tar --prefix "/usr/share/dvb/" HEAD >$TODAY_TAR
> run bzip2 -f $TODAY_TAR
>
> run mv $FILE $REPO
> run ln -sf $FILE $REPO/dtv-scan-tables-LATEST.tar.bz2
> (cd $REPO; md5sum *.bz2 > md5sum)
> echo $CHANGES > .changes
>
>>
>> Oliver
>>
>>
>> -------- Original Message --------
>> Subject: 	dtv-scan-tables tar archive
>> Date: 	Fri, 12 Jul 2013 10:59:56 +0200
>> From: 	Till Maas <opensource@till.name>
>> To: 	Oliver Schinagl <oliver@schinagl.nl>
>>
>>
>>
>> Hi Oliver,
>>
>> the tar archives at
>> http://linuxtv.org/downloads/dtv-scan-tables/
>> are broken.
>> xxd dtv-scan-tables-2013-04-12-495e59e.tar | less shows:
>>
>> | 0000000: 6769 7420 6172 6368 6976 6520 2d2d 666f  git archive --fo
>> | 0000010: 726d 6174 2074 6172 202d 2d70 7265 6669  rmat tar --prefi
>> | 0000020: 7820 2f75 7372 2f73 6861 7265 2f64 7662  x /usr/share/dvb
>> | 0000030: 2f20 4845 4144 0a70 6178 5f67 6c6f 6261  / HEAD.pax_globa
>> | 0000040: 6c5f 6865 6164 6572 0000 0000 0000 0000  l_header........
>>
>> It seems like the git archive commandline somehow ended in the tarball.
>> E.g. the tarball should start with pax_global_header and not with "git
>> archive".
>
> Thanks for pointing it to me. I fixed the script.
Confirmed, it now shows proper archives.

Could you manually remove 'dtv-scan-tables-2013-04-12*' as that is 
invalid so shouldn't be mirrored/downloaded really.

Thanks,

Oliver
>
>>
>> Regards
>> Till
>>
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
> Regards,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

