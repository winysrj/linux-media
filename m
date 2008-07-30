Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6UKifgt017776
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 16:44:41 -0400
Received: from web63010.mail.re1.yahoo.com (web63010.mail.re1.yahoo.com
	[69.147.96.221])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m6UKiRAY031019
	for <video4linux-list@redhat.com>; Wed, 30 Jul 2008 16:44:27 -0400
Date: Wed, 30 Jul 2008 13:44:21 -0700 (PDT)
From: Fritz Katz <frtzkatz@yahoo.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <200807302104.07478.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <902301.97749.qm@web63010.mail.re1.yahoo.com>
Cc: video4linux-list@redhat.com
Subject: Re: What info does V-4-L expect to be in the "Identifier EEprom"?
Reply-To: frtzkatz@yahoo.com
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


Thank you Hans, 

  I need to correct my own mis-information.
  Vendor ID assignments are given out by an industry group PCISIG.
  Membership costs $3000 and has other benefits:

    http://www.pcisig.com/membership/join_pci_sig/

_________________________________________
--- On Wed, 7/30/08, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> >
> > Should those two hex numbers should be the first 32
> > bytes in the EEPROM?
> 
> No, PCI IDs are stored by the PCI hardware (I'm no
> expert on this). The boards already have PCI IDs since 
> they are mandated by the PCI standard. You can find them 
> with 'lspci -vn'.
> 
> > Unfortunately, the company I'm consulting for is
> > not in the list. I suppose we can submit an unused 
> > vendor ID to the site.
> 
> No! The cards already have
> vendor/device/subvendor/subdevice IDs. Ask 
> the engineers, they should have all the details on this.
> 



      

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
