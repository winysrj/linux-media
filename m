Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from node03.cambriumhosting.nl ([217.19.16.164])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jelledejong@powercraft.nl>) id 1Kph3W-0002di-Ev
	for linux-dvb@linuxtv.org; Tue, 14 Oct 2008 12:23:13 +0200
Received: from localhost (localhost [127.0.0.1])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id EE4F8B0001FD
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 12:23:05 +0200 (CEST)
Received: from node03.cambriumhosting.nl ([127.0.0.1])
	by localhost (node03.cambriumhosting.nl [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id OPMrG2x8cUmz for <linux-dvb@linuxtv.org>;
	Tue, 14 Oct 2008 12:23:03 +0200 (CEST)
Received: from ashley.powercraft.nl (84-245-3-195.dsl.cambrium.nl
	[84.245.3.195])
	by node03.cambriumhosting.nl (Postfix) with ESMTP id 179E6B0001FB
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 12:23:03 +0200 (CEST)
Received: from [192.168.1.180] (unknown [192.168.1.180])
	by ashley.powercraft.nl (Postfix) with ESMTPSA id D6CB623BC50D
	for <linux-dvb@linuxtv.org>; Tue, 14 Oct 2008 12:23:02 +0200 (CEST)
Message-ID: <48F47305.5090801@powercraft.nl>
Date: Tue, 14 Oct 2008 12:23:01 +0200
From: Jelle de Jong <jelledejong@powercraft.nl>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <48F44F1D.4080301@powercraft.nl> <200810141137.17034.hftom@free.fr>
In-Reply-To: <200810141137.17034.hftom@free.fr>
Content-Type: multipart/mixed; boundary="------------020704090506050106020203"
Subject: Re: [linux-dvb] mplayer dvb-t startup problems
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------020704090506050106020203
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Christophe Thommeret wrote:
> Le Tuesday 14 October 2008 09:49:49 Jelle de Jong, vous avez =EF=BF=BDc=
rit=EF=BF=BD:
>> Hello everybody,
>>
>> I am trying to build a dvb-t system and I am currently using mplayer t=
o
>> tune into the channels and watch and listen to them. However I got som=
e
>> startup problems. Mplayer does not always detect the TS file stream an=
d
>> the audio is sometimes distorted. I posted an more detailed descriptio=
n
>> of the problem on the mplayer mailinglist, but there was not much
>> response, so I am trying this channel since the change somebody readin=
g
>> this and has solved the issue is much greater:
>>
>> http://lists.mplayerhq.hu/pipermail/mplayer-users/2008-October/074693.=
html
>>
>> I hope somebody know how to fix the issues,
>=20
> -cache 4096
>

Thank you Christophem for responding.

I changed my cache from 512 to 4096. The problem still occurs, but  I
got feeling it happens a little bit less, but this can also be because
it takes a hole lot longer to startup the dvb-t channel (especially with
audio only streams, but with audio only there is also no TS detection
starup problem)

I attached my mplayer dvb-t wrapper script for some extra info.

Kind regards,

Jelle


--------------020704090506050106020203
Content-Type: application/x-sh;
 name="mplayer-dvb-play-channel.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mplayer-dvb-play-channel.sh"

#!/bin/bash

number="$1"

if [ -z "$number" ]
then
    number="1"
fi

if [ "$number" == "0" ]
then
    file="~/.mplayer/channels.conf"
    count=1
    while read line
    do
        if [ -n "$line" ]
        then
            channel=$(cat ~/.mplayer/channels.conf | sed -n "$count"p  | cut -f 1 -d ':')
            count=$(($count+1))
            channel_query+=("dvb://$channel" )
        fi
    done < "$file"
    /usr/bin/mplayer -cache 4096 -dvbin timeout=5 dvb:// "${channel_query[@]}"
else
    echo "number: $number"
    channel=$(cat ~/.mplayer/channels.conf | sed -n "$number"p  | cut -f 1 -d ':')
    # there are startup problems and syncronization issues, any solutions?
    echo "command: /usr/bin/mplayer -cache 4096 -dvbin timeout=5 dvb://$channel"
    /usr/bin/mplayer -cache 4096 -dvbin timeout=5 dvb://"$channel"
fi

sleep 1

exit

# debugging:
mplayer -dumpfile ~/dump-1.ts -dumpstream dvb://"Nederland 1(Digitenne)"
lftp
open ftp://upload.mplayerhq.hu/MPlayer/incoming/
put dump-1.ts dump-2.ts dump-3.ts dump-4.ts

--------------020704090506050106020203
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------020704090506050106020203--
