Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m8SNfH3G001858
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 19:41:17 -0400
Received: from mail.gmx.net (mail.gmx.net [213.165.64.20])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id m8SNf2iD007059
	for <video4linux-list@redhat.com>; Sun, 28 Sep 2008 19:41:02 -0400
Date: Mon, 29 Sep 2008 01:40:44 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Joseph Shraibman <video4linux@jks.tupari.net>
Message-ID: <20080928234044.GA6399@daniel.bse>
References: <alpine.LFD.2.00.0809281653540.2524@tupari.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0809281653540.2524@tupari.net>
Cc: video4linux-list@redhat.com
Subject: Re: What is an ATI Wonder?
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

On Sun, Sep 28, 2008 at 04:56:21PM -0400, Joseph Shraibman wrote:
> http://www.linuxtv.org/wiki/index.php/ATSC_PCI_Cards lists "ATI HDTV 
> Wonder" as supported, but what model is that?  There are two models that 
> support HDTV, the 650 and the 600.  Are they both supported?

No, neither is supported.

You are talking about the "ATI TV Wonder HD 600" and "ATI TV Wonder HD 650"
cards listed here: http://ati.amd.com/products/tunermatrix.html

Of the devices listed there only the USB version of the "TV Wonder HD 600"
is currently supported (by the em28xx driver). (So the "single-chip solution"
Theater 600 Pro is mainly a conglomerate of other well known chips?)

Supported Wonder cards are:
- "ATI HDTV Wonder" http://ati.amd.com/products/hdtvwonder/index.html
- "ATI TV Wonder Pro" http://ati.amd.com/products/tvwonderpro/index.html
- "ATI TV Wonder VE" http://ati.amd.com/products/tvwonderve/index.html
- "ATI TV Wonder" http://ati.amd.com/products/tvwonder/index.html

  Daniel

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
