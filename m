Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n3H2MBPs019112
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 22:22:11 -0400
Received: from smtp127.rog.mail.re2.yahoo.com (smtp127.rog.mail.re2.yahoo.com
	[206.190.53.32])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n3H2LFQx020698
	for <video4linux-list@redhat.com>; Thu, 16 Apr 2009 22:21:16 -0400
Message-ID: <49E7E794.30604@rogers.com>
Date: Thu, 16 Apr 2009 22:21:08 -0400
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: hawk_eyes80@yahoo.com.mx
References: <804291.57323.qm@web57901.mail.re3.yahoo.com>
In-Reply-To: <804291.57323.qm@web57901.mail.re3.yahoo.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: Rv: Re: ATI TV Wonder PCI
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

Harol Hunter wrote:
>>> I have an ATI TV Wonder 550 PCI card and I can't make linux recognize it properly. I've been googling a
>>> lot with no result. Here I let you my lscpi results:
>>>
>>> 01:0b.0 Multimedia controller [0480]: ATI Technologies Inc Theater 550 PRO PCI [ATI TV Wonder 550] [1002:4d52]
>>>     Subsystem: ATI Technologies Inc Unknown device [1002:a346]
>>>
>>> ....
>>>
>>> I read that I have to load the right modules for it and this is what I've done 'till now 
>>> $ sudo modprobe bttv card=63 tuner=44 radio=1
>>> and with no parameters also. Bttv loads properly but still won't recognize the cards. Am I doing anything
>>> wrong or it's just my card. I must say I can watch TV on
>>> Windows with this very same card
>> You will find that ATI / AMD named almost all their tuners "ATI
>> Wonder" making it very difficult to distinguish which
>> is which 
>> ....
>> evidence that your card might not work can be found
>> here ... Ah, here's the coffin nail (search for your 550 card):
>> http://www.linuxtv.org/wiki/index.php/ATI/AMD 
>
> about my card as I say it's an ATI TV
> Wonder 550 PCI, reading CARDLIST.bttv in kernel Doc I found
> out it's supported by bttv driver so I thought it might
> be easy to configure, but the real problem is that even when
> then kernel sees the card it wont recognize it, anyone who
> has had this problem?
>   


Harol,

you have misunderstood -- your card is NOT supported.  Your device does
not use one of the PCI bridges supported by the bttv driver .  Your card
uses the Theater 550 Pro as its PCI bridge (as well as for some other
functions; A/V decoding, MPEG2 encoding) , and there is no driver for
that IC; and, consequently, no support for your card.

As an FYI, look again at the bttv card list and you will see that the
subsystem ID for entry 63 is different from your own card (which you
will see listed above in the output of lspci you generated;
specifically:[1002:a346]).  Also take note of the pertinent information
that Stuart previously provided and which I have included above in the
quotation.

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
