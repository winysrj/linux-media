Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m34I0i1e024855
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 14:00:44 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m34I0U5l008604
	for <video4linux-list@redhat.com>; Fri, 4 Apr 2008 14:00:30 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Date: Fri, 4 Apr 2008 19:59:27 +0200
References: <1115343012.20080318233620@a-j.ru> <47F6258B.7020207@linuxtv.org>
	<37219a840804040623i274d7292ledbe91ac7a531171@mail.gmail.com>
In-Reply-To: <37219a840804040623i274d7292ledbe91ac7a531171@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041959.28748@orion.escape-edv.de>
Cc: video4linux-list@redhat.com, Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] TT S-1401 problem with kernel 2.6.24 ???
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

Michael Krufky wrote:
> On Fri, Apr 4, 2008 at 8:56 AM, Michael Krufky <mkrufky@linuxtv.org> wrote:
> >  Guys,
> >
> >  Please test this patch against 2.6.24.4 -stable.
> >
> >  I don't have this hardware, or any way to test this myself, so I will wait on your feedback before sending this to the -stable team.  (Please try to test it and get back to me quickly -- I'd like to send this over before the 2.6.24.5 review cycle begins)
> 
> 
> I also uploaded the patch to linuxtv.org, in case of mailer whitespace-mangling:
> 
> http://linuxtv.org/~mkrufky/stable/2.6.24.y/0002-DVB-tda10086-make-the-22kHz-tone-for-DISEQC-a-conf.patch
> 
> Please test.

The following devices are affected by the patch:

driver: budget
- Technontrend DVB-S 1401, pci subsystem id: 13c2:1018

driver ttusb2:
- USB_PID_PCTV_400E
- USB_PID_PCTV_450E

driver: saa7134
- SAA7134_BOARD_FLYDVB_TRIO
- SAA7134_BOARD_MEDION_MD8800_QUADRO
- SAA7134_BOARD_FLYDVBS_LR300
- SAA7134_BOARD_PHILIPS_SNAKE
- SAA7134_BOARD_MD7134_BRIDGE_2

Sorry, cannot do any tests, I do not own any of these devices.

CU
Oliver

-- 
----------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
----------------------------------------------------------------

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
