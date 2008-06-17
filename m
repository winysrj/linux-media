Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m5HMH0Uu030938
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 18:17:00 -0400
Received: from mail-in-03.arcor-online.net (mail-in-03.arcor-online.net
	[151.189.21.43])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m5HMGkDr018129
	for <video4linux-list@redhat.com>; Tue, 17 Jun 2008 18:16:46 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Bozhan Boiadzhiev <bozhan@abv.bg>
In-Reply-To: <626861405.35803.1213730904672.JavaMail.apache@mail72.abv.bg>
References: <626861405.35803.1213730904672.JavaMail.apache@mail72.abv.bg>
Content-Type: text/plain
Date: Wed, 18 Jun 2008 00:14:33 +0200
Message-Id: <1213740873.6555.10.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] ASUS My-Cinema remote patch
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


Am Dienstag, den 17.06.2008, 22:28 +0300 schrieb Bozhan Boiadzhiev:
> 
> whatever ...
> adding option saa7134 card=78 
> solve all of my problems :)
> my card doesn't have dvb but that is all difference with card 78
> 
> thanks

Oh, sorry.

Thought this was clear, since all recent saa713x Asus stuff comes from
that one including support for the new remote and that is what was
always used for the analog only one too.

However, when discussing the autodetection of your card, Hartmut meant
the better solution is to have a own entry for your card and I think he
is right.

The pitfall with the current framework and duplicate PCI subsystem is,
that eeprom detection needs already working i2c and from there is no way
back for IR setup.

Have fun,

Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
