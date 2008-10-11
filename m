Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m9BJnsIU019279
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 15:49:54 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.155])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m9BJncLt031827
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 15:49:39 -0400
Received: by fg-out-1718.google.com with SMTP id e21so760563fga.7
	for <video4linux-list@redhat.com>; Sat, 11 Oct 2008 12:49:38 -0700 (PDT)
Message-ID: <d9def9db0810111249v5b8603afudeb96a64b4e6f0ef@mail.gmail.com>
Date: Sat, 11 Oct 2008 21:49:38 +0200
From: "Markus Rechberger" <mrechberger@gmail.com>
To: rafael2k <rafael@riseup.net>
In-Reply-To: <200810111551.13338.rafael@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1223640548.5171.64.camel@luis> <20081010130124.GA850@daniel.bse>
	<200810111551.13338.rafael@riseup.net>
Content-Transfer-Encoding: 8bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: analize ASI with dvbnoop and dektec 140
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

2008/10/11 rafael2k <rafael@riseup.net>:
> I think you could write a v4l2 wrapper using the dektec API.
>

v4l2 has nothing to do with dvbsnoop :-)

you might read the manual how you can get access to the mpeg-ts stream
and simply pipe it to dvbsnoop

eg.:
dvbstream -o 8192 | dvbsnoop -s ts -if /dev/stdin

note you have to replace the dvbstream command with something specific
from dektec I guess.

Markus
> bye,
> rafael diniz
>
> Em Friday 10 October 2008, Daniel Glöckner escreveu:
>> On Fri, Oct 10, 2008 at 02:09:08PM +0200, luisan82@gmail.com wrote:
>> > I've been trying to analyze a ts with dvbsnoop through an ASI input
>> > unsuccessfully.
>> > When I execute dvbsnoop, it tries to read from a location (/dev/dvb/...)
>> > wich doesn't exists.
>>
>> The drivers provided by DekTec do not implement the Linux DVB API.
>> You can't use dvbsnoop.
>> You need to write your own program using their proprietary DTAPI library.
>> At least their drivers are open source...
>
>
> --
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
> Ciência da Computação @  Unicamp
> Rádio Muda, radiolivre.org, TV Piolho, tvlivre.org, www.midiaindependente.org
> Chave PGP: http://pgp.mit.edu:11371/pks/lookup?op=get&search=0x2FF86098
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-
>
>
> --
> video4linux-list mailing list
> Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
> https://www.redhat.com/mailman/listinfo/video4linux-list
>

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
