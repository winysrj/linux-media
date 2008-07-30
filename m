Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UGDiEB016112
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 12:13:44 -0400
Received: from smtp-vbr15.xs4all.nl (smtp-vbr15.xs4all.nl [194.109.24.35])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6UGDWg5027588
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 12:13:33 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: video4linux-list@redhat.com, frtzkatz@yahoo.com
Date: Wed, 30 Jul 2008 18:13:30 +0200
References: <840865.6007.qm@web63010.mail.re1.yahoo.com>
In-Reply-To: <840865.6007.qm@web63010.mail.re1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807301813.30670.hverkuil@xs4all.nl>
Cc: 
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
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

On Wednesday 30 July 2008 17:54:36 Fritz Katz wrote:
> I'm a consultant for a company that wishes to produce a video cards
> that will run Video-4-Linux applications. The company currently
> produces tuners and video capture cards for Microsoft Windows.
>
> The company wishes to include an "Identifier EEprom" on the board so
> V4L will recognize the card and load appropriate drivers at boot-up.
>
> Please point me in the direction of documentation for the info V4L
> expects to be found in the ID eeprom.

Currently the tveeprom module is specific for Hauppauge cards. The 
documentation of how (most) of that eeprom is setup is part of the 
tveeprom.c source (see the tveeprom_hauppauge_analog function).

It is likely you will choose your own format, but it is very useful if 
the eeprom has information like:

- model number/type of the card
- what tuner chip(s) is/are used (tuners tend to be swapped for 
different models quite often).
- whether there is a radio supported
- IR support (none, just a receiver, both receiver and transmitter)
- Any encoder/decoder chips (unless that can be derived from the model 
number).

In general: anything you need to determine which chips are on the board 
and on which i2c address. And how external connectors are hooked up to 
those chips (if that can vary).

Of course, if all this can be directly determined by the PCI 
(sub)vendor/device IDs, then there is no need for an eeprom. Sadly, my 
experience is that the PCI IDs tend to be insufficient or plain wrong, 
especially by cheap cards based on a reference design from another 
company. In several cases the PCI IDs where unchanged from the 
reference design, making it impossible to discover which card it really 
is.

Regards,

	Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
