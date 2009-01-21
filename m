Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n0LN464s018329
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 18:04:06 -0500
Received: from mailrelay009.isp.belgacom.be (mailrelay009.isp.belgacom.be
	[195.238.6.176])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n0LN3pek017911
	for <video4linux-list@redhat.com>; Wed, 21 Jan 2009 18:03:51 -0500
From: Laurent Pinchart <laurent.pinchart@skynet.be>
To: video4linux-list@redhat.com
Date: Thu, 22 Jan 2009 00:03:45 +0100
References: <96DA7A230D3B2F42BA3EF203A7A1B3B501290FAB33@dlee07.ent.ti.com>
In-Reply-To: <96DA7A230D3B2F42BA3EF203A7A1B3B501290FAB33@dlee07.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901220003.46126.laurent.pinchart@skynet.be>
Cc: "Curran, Dominic" <dcurran@ti.com>
Subject: Re: Appropriate interface ?
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

On Wednesday 21 January 2009, Curran, Dominic wrote:
> > > The EEPROM is written with factory settings (sensor & lens info).
> > > It is meant to be read-only.
> > >
> > > Can anyone suggest an appropriate interface to usermode for the EEPROM
> > > ? Should I implement sysfs interface ?
> > > Or is there something more appropriate.
> >
> > The drivers/i2c/chips/at24.c driver, which should handle most EEPROMs,
> > exports EEPROM data through sysfs.
>
> Ok I see.
> Is there a board file that already has this enabled, so I can use as
> example.
>
> I grepped omap-linux kernel but didn't see anything.

linux/arch/arm/mach-omap2/board-h4.c

Best regards,

Laurent Pinchart

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
